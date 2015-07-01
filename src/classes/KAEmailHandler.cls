public with sharing class KAEmailHandler {

	public static void sendEmail (List<Employee_Task__c> p_employee_task) {
		/*List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<String> sendTo = new List<String>();
		List<Employee_Task__c> employeeName = [
			SELECT Employee__r.Name, Employee__r.First_Name__c, Task__r.AssignTime__c
			FROM Employee_Task__c
			WHERE Employee__c = :p_employee_task.get(0).Employee__c
		];
      	sendTo.add(employeeName.get(0).Employee__r.Name);
      	mail.setToAddresses(sendTo);
      	mail.setReplyTo('pasha149@yandex.ru');
      	mail.setSenderDisplayName('Commander');
      	mail.setSubject('Test Examination');
      	String body = 'Hello ' + employeeName.get(0).Employee__r.First_Name__c + ', ';
      	body += 'You need to pass test ' + employeeName.get(0).Task__r.AssignTime__c + '. ';
      	body += 'Good luck';
      	mail.setHtmlBody(body);
      	mails.add(mail);
      	Messaging.sendEmail(mails);*/
	}
}