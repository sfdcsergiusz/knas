trigger KAUniqueSubject on Subject__c (before insert, after insert, before update, after update, 
		before delete, after delete, after undelete) {
	
	if (KAUniqueSubjectHandler.enablesTrigger) {
		if (Trigger.isBefore && Trigger.isInsert)  {
			KAUniqueSubjectHandler.addNewSubject(Trigger.new);
		} 
		else if (Trigger.isBefore && Trigger.isUpdate) {
			KAUniqueSubjectHandler.addNewSubject(Trigger.new);
		} 
	}
}