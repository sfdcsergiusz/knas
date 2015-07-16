public with sharing class KACreateNewPasswordController {
	public String newPassword {get; set;}
	public String confirmPassword {get; set;}
	public Employee__c user {get; set;}
	public String hash {get; set; }
	public Boolean isRightLink { get; set; }

	public void onLoad() {
		if (ApexPages.currentPage().getParameters().get('hashLink') == null) {
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.ERROR,
					'You haven\'t access to this page.'
				)
			);				
		}
		else if(ApexPages.currentPage().getParameters().get('hashLink') != '') {
			List<Employee__c> users = [
				SELECT Name, Password__c, Action_Hash__c, Waiting_Reset__c
				FROM Employee__c
				WHERE Action_Hash__c = :hash AND Waiting_Reset__c = true
				LIMIT 1
			];
			if ( ! users.isEmpty()) {
				user = users.get(0);
				isRightLink = true;
			}
			else {
				ApexPages.addMessage(
					new ApexPages.Message(
						ApexPages.Severity.ERROR,
						'You haven\'t access to this page.'
					)
				);	
			}
		}
		else {
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.ERROR,
					'You haven\'t access to this page.'
				)
			);	
		}
	}

	public KACreateNewPasswordController() {
		this.user = new Employee__c();
		this.hash = ApexPages.currentPage().getParameters().get('hashLink');
		this.isRightLink = false;
	}


	public PageReference setNewPassword() {
		if (hash != null && hash != '' && user != null) {
			if (newPassword == confirmPassword) {
				user.Password__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(newPassword)));
				user.Action_Hash__c = null;
				user.Waiting_Reset__c  = false;
				update user;

				PageReference updatingPage = new PageReference('/apex/KALogin');
				updatingPage.setRedirect(true);
				return updatingPage;				
			}
			else if (newPassword != confirmPassword) {
				ApexPages.addMessage(
					new ApexPages.Message(
						ApexPages.Severity.ERROR,
						'Passwords aren\'t the same.'
					)
				);
				return null;
			}
		}			
		ApexPages.addMessage(
			new ApexPages.Message(
				ApexPages.Severity.ERROR,
				'You haven\'t access to this page.'
			)
		);
		return null;	
	}

}