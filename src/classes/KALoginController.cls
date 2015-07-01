public with sharing class KALoginController {

	public String username { get; set; }
	public String password { get; set; }

	private Browser__c browserId { private get; private set; }

	private PageReference currentPage;

	public KALoginController() {
		currentPage = ApexPages.currentPage();
		browserId = new Browser__c();
	}

	public void setIdentifier() {
		String tmpBrowserId = ApexPages.currentPage().getParameters().get('mainId');
		browserId.Identifier__c = tmpBrowserId;
	}

	public PageReference login() {
		List<Employee__c> emploUsers = [
			SELECT Name, Password__c, IsAdmin__c
			FROM Employee__c
			WHERE Name =: username
			LIMIT 1
		];
		if (emploUsers.size() != 0 && emploUsers.get(0).Password__c == EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(password)))) {

			List<Browser__c> sameUsedIds = [
				SELECT Id
				FROM Browser__c
				WHERE Identifier__c = :browserId.Identifier__c
			];
			delete sameUsedIds;

			browserId.Employee__c = emploUsers.get(0).Id;
			insert browserId;

			setLoginCookie(browserId.Identifier__c);

			if ( ! emploUsers.get(0).IsAdmin__c) {
				return new PageReference('/apex/KARegularUserHome');
			}
			else {
				return new PageReference('/apex/KAAdminUserHome');
			}
		}
		return null;
	}

	public PageReference register() {
		return new PageReference('/apex/KARegister');
	}

	public void resetPass() {

	}

	private void setLoginCookie(String id) {
		currentPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', id, null, 10000, false)
			}
		);
	}

}