public with sharing class CreateNewPasswordController {
	public String newPassword {get; set;}
	public String confirmPassword {get; set;}
	public Employee__c user {get; set;}
	public String username {get; set; }

	public CreateNewPasswordController() {
		this.user = new Employee__c();
		this.username = ApexPages.currentPage().getParameters().get('s');
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
				user.Password__c = newPassword;
				update user;
				return Page.KALogin;
			} else {
				ApexPages.addMessage(
					new ApexPages.Message(
						ApexPages.Severity.ERROR,
						'Passwords aren\'t the same.'));
				return null;
		}
	}	
}