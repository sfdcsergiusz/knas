public with sharing class KARegisterController {

	public String username { get; set; }
	public String password { get; set; }
	public String firstName { get; set; }
	public String lastName { get; set; }

	private PageReference currentPage;

	public KARegisterController() {
		currentPage = ApexPages.currentPage();
	}

	public PageReference onLoad() {
		if (getLoginCookie() != null) {
			return new PageReference('/apex/KARegularUserHome');
		}
		else {
			return null;
		}
	}

	public PageReference login() {
		return new PageReference('/apex/KALogin');
	}

	public PageReference register() {
		if (registerNewEmployee()) {
			setLoginCookie(username);
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
		return employeeSaveResult.isSuccess();
	}

	private void setLoginCookie(String username) {
		currentPage.setCookies(
		    new Cookie[] {
		        new Cookie('KALogin', username, null, 1000, false)
		    }
		);
	}

	private Cookie getLoginCookie() {
		return currentPage.getCookies().get('KALogin');
	}
}