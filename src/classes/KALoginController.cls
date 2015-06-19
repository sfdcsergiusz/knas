public with sharing class KALoginController {

	public String username { get; set; }
	public String password { get; set; }

	private PageReference currentPage;

	public KALoginController() {
		currentPage = ApexPages.currentPage();
	}

	public PageReference onLoad() {
		if (getLoginCookie() != null) {
			Employee__c emploUser = [
				SELECT Name, Password__c, IsAdmin__c
				FROM Employee__c
				WHERE Name =: getLoginCookie().getValue()
				LIMIT 1
			];
			if ( ! emploUser.IsAdmin__c) {
				return new PageReference('/apex/KARegularUserHome');
			}
			else {
				return new PageReference('/apex/KAAdminUserHome');
			}
		}
		else {
			return null;
		}
	}

	public PageReference login() {
		Employee__c emploUser = [
			SELECT Name, Password__c, IsAdmin__c
			FROM Employee__c
			WHERE Name =: username
			LIMIT 1
		];
		if (emploUser != null && emploUser.Password__c == EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(password)))) {
			setLoginCookie(username);
			if ( ! emploUser.IsAdmin__c) {
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