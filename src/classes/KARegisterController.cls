public with sharing class KARegisterController {

	public String username { get; set; }
	public String password { get; set; }
	public String firstName { get; set; }
	public String lastName { get; set; }

	private PageReference currentPage;

	private Browser__c browserId { private get; private set; }

	public KARegisterController() {
		currentPage = ApexPages.currentPage();
		browserId = new Browser__c();
	}

	public void setIdentifier() {
		String tmpBrowserId = ApexPages.currentPage().getParameters().get('mainId');
		browserId.Identifier__c = tmpBrowserId;
	}

	public PageReference login() {
		return new PageReference('/apex/KALogin');
	}

	public PageReference register() {
		if (registerNewEmployee()) {
			setLoginCookie(browserId.Identifier__c);
			return new PageReference('/apex/KARegularUserHome');
		}
		else {
			return null;
		}
	}

	private boolean registerNewEmployee() {
		Employee__c newestEmployee = new Employee__c(
		    Name = username,
		    Password__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(password))),
		    First_Name__c = firstName,
		    Last_Name__c = lastName
		);
		Database.SaveResult employeeSaveResult = Database.insert(newestEmployee);
		if (employeeSaveResult.isSuccess()) {
			browserId.Employee__c = newestEmployee.Id;
			insert browserId;
		}
		return employeeSaveResult.isSuccess();
	}

	private void setLoginCookie(String id) {
		currentPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', id, null, 1000, false)
			}
		);
	}

}