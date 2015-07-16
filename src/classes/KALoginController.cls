public with sharing class KALoginController {

	public String username { get; set; }
	public String password { get; set; }
	public Boolean isSend {get; set; }
	public Boolean noSend {get; set; }

	private Browser__c browserId { private get; private set; }

	private PageReference currentPage;

	public KALoginController() {
		currentPage = ApexPages.currentPage();
		browserId = new Browser__c();
		this.isSend = false;
		this.noSend = false;
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
		List<Employee__c> existingEmployees = [
			SELECT Name, First_Name__c, Waiting_Reset__c
			FROM Employee__c
			WHERE Name = :username
		];
		if ( ! existingEmployees.isEmpty()) {
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


			/*List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			List<String> sendTo = new List<String>();
			sendTo.add(username);
			email.setSubject( 'Request for new password on the Knowledge Assessment System' );
			email.setToAddresses(sendTo);
			email.setHtmlBody( 'Dear '+ existingEmployees.get(0).First_Name__c +
				',</br><p>You requested a password recovery for your account on the Knowledge Assessment System </br>Your login:'+
				username +'</p>To recover your password, go to ' + '<a href="' +
				URL.getSalesforceBaseUrl().toExternalForm() + '/apex/KACreateNewPassword?hashLink=' +
				username + '">this link</a>' );
			mails.add(email);
      		Messaging.sendEmail(mails);
			*/
      		this.isSend = true;
		}
		else {
			noSend = true;
		}
	}

	private void setLoginCookie(String id) {
		currentPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', id, null, 10000, false)
			}
		);
	}

}