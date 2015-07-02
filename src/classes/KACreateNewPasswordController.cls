public with sharing class KACreateNewPasswordController {
	public String newPassword {get; set;}
	public String confirmPassword {get; set;}
	public Employee__c user {get; set;}
	public String username {get; set; }

	public KACreateNewPasswordController() {
		this.user = new Employee__c();
		this.username = ApexPages.currentPage().getParameters().get('hashLink');
	}

	public PageReference setNewPassword() {
		List<Employee__c> users = [
			SELECT Name, Password__c
			FROM Employee__c
			WHERE Name = :username
			LIMIT 1
		];

		user = users.get(0);

		if (newPassword == confirmPassword) {
				user.Password__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf(newPassword)));
				update user;
				PageReference updatingPage = new PageReference('/apex/KALogin');
				updatingPage.setRedirect(true);
				return updatingPage;
			}
			else {
			ApexPages.addMessage(
				new ApexPages.Message(
					ApexPages.Severity.ERROR,
					'Passwords aren\'t the same.'));
			return null;
		}
	}
}