global class KAEmailHandler implements Schedulable  {

	//System.schedule('Daily emails', '0 0 9,10,11,12,13,14,15,16,17,18 * * ?', new KAEmailHandler());

	global void execute(SchedulableContext SC) {
		List<Employee_Task__c> employeeTasksToSend = [
			SELECT Employee__r.Name, Employee__r.First_Name__c, Task__r.AssignTime__c, IsEmailQueue__c
			FROM Employee_Task__c
			WHERE IsEmailQueue__c = true
		];


		List<Employee__c> employeePasswordToSend = [
			SELECT Name, First_Name__c, Waiting_Reset__c, Action_Hash__c
			FROM Employee__c
			WHERE Waiting_Reset__c = true
		];

		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();

		for (Employee_Task__c sendNotification : employeeTasksToSend) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(
				new List<String> {
					sendNotification.Employee__r.Name
				}
			);
			mail.setSenderDisplayName('CS Knowledge Assessment');
			mail.setSubject('Test Examination');
			mail.setHtmlBody('Hello, ' + sendNotification.Employee__r.First_Name__c + '! There is a test for you on ' + 
				sendNotification.Task__r.AssignTime__c + '. Good luck :)');
			mails.add(mail);
		}

		for (Employee__c sendPassword : employeePasswordToSend) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(
				new List<String> {
					sendPassword.Name
				}
			);
			mail.setSenderDisplayName('CS Knowledge Assessment');
			mail.setSubject('Request for new password on the Knowledge Assessment System' );
			mail.setHtmlBody('Dear '+ sendPassword.First_Name__c +
				',</br><p>you requested a password recovery for your account on the Knowledge Assessment System </br>Your login:'+
				sendPassword.Name +'</p>To recover your password, go to ' + '<a href="' +
				URL.getSalesforceBaseUrl().toExternalForm() + '/apex/KACreateNewPassword?hashLink=' +
				sendPassword.Action_Hash__c + '">this link.</a>' );
			mails.add(mail);
		}

		Messaging.sendEmail(mails);

		for (Employee_Task__c clearEmailRecipients : employeeTasksToSend) {
			clearEmailRecipients.IsEmailQueue__c = false;
		}
		update employeeTasksToSend;
	}

}