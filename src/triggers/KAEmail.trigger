trigger KAEmail on Employee_Task__c (before insert, after insert, before update, after update, 
		before delete, after delete, after undelete) {
	if (Trigger.isAfter && Trigger.isInsert)  {
			KAEmailHandler.sendEmail(Trigger.new);
		} 
		else if (Trigger.isAfter && Trigger.isUpdate) {
			KAEmailHandler.sendEmail(Trigger.new);
		} 
	
}