public with sharing class KALoginController {

	public String username { get; set; }
	public String password { get; set; }

	public KANotificationMapWrapper notificMap { get; private set; }

	private Browser__c browserId { private get; private set; }

	private PageReference currentPage;

	private void init() {
		notificMap = new KANotificationMapWrapper();
		currentPage = ApexPages.currentPage();
		browserId = new Browser__c();
	}

	public KALoginController() {
		init();
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
		else {
			if (emploUsers.size() == 0) {
				notificMap.addDanger('Username doesn\'t exist.');
			}
			else if (emploUsers.get(0).Password__c != EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(password)))) {
				notificMap.addDanger('Incorrect password.');
			}
 		}
		return null;
	}

	public PageReference register() {
		return new PageReference('/apex/KARegister');
	}

	public void resetPass() {
		List<Employee__c> existingEmployees = [
			SELECT Name, First_Name__c, Waiting_Reset__c
			FROM Employee__c
			WHERE Name = :username
		];
		if ( ! existingEmployees.isEmpty() && username != null && username != '') {
			Employee__c resettingUser = existingEmployees.get(0);
			if ( ! resettingUser.Waiting_Reset__c) {
				resettingUser.Action_Hash__c = EncodingUtil.convertToHex(
					Crypto.generateDigest(
						'MD5',
						Blob.valueOf(
							String.valueOf(
								Datetime.now()
							)
							+
							String.valueOf(
								Math.round(
									Math.random() * 1000
								)
							)
							+
							resettingUser.Name
						)
					)
				);
				resettingUser.Waiting_Reset__c = true;
				update resettingUser;
			}
			notificMap.addSuccess('Please, check your e-mail for creating new password.');
		}
		else {
			notificMap.addDanger('Username doesn\'t exist.');
		}
	}

	private void setLoginCookie(String id) {
		currentPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', id, null, 100000000, false)
			}
		);
	}

}