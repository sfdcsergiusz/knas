global class KAEmailHandler implements Schedulable  {

	//System.schedule('Daily emails', '0 0 9,10,11,12,13,14,15,16,17,18 * * ?', new KAEmailHandler());

	global void execute(SchedulableContext SC) {
		/*List<Employee_Task__c> employeeTasksToSend = [
			SELECT Employee__r.Name, Employee__r.First_Name__c, Task__r.AssignTime__c, IsEmailQueue__c
			FROM Employee_Task__c
			WHERE IsEmailQueue__c = true
		];

		List<Employee__c> existingEmployees = [
			SELECT First_Name__c, Id, Hash__c
			FROM Employee__c
			WHERE Hash__c !=null
		];

		List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		for (Employee_Task__c sendNotification : employeeTasksToSend) {
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			mail.setToAddresses(new List<String> { sendNotification.Employee__r.Name });
			mail.setSenderDisplayName('Commander');
			mail.setSubject('Test Examination');
			String body = 'Hello ' + sendNotification.Employee__r.First_Name__c + ', ';
			body += 'You need to pass test ' + sendNotification.Task__r.AssignTime__c + '. ';
			body += 'Good luck';
			mail.setHtmlBody(body);
			mails.add(mail);
		}




		Messaging.sendEmail(mails);

		for (Employee_Task__c clearEmailRecipients : employeeTasksToSend) {
			clearEmailRecipients.IsEmailQueue__c = false;
		}
		update employeeTasksToSend;*/
	}

}