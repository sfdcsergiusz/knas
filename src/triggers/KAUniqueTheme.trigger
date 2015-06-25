trigger KAUniqueTheme on Theme__c (before insert, after insert, before update, after update, 
		before delete, after delete, after undelete) {
	
	if (KAUniqueThemeHandler.enablesTrigger) {
		if (Trigger.isBefore && Trigger.isInsert)  {
			KAUniqueThemeHandler.addNewTheme(Trigger.new);
		} 
		else if (Trigger.isBefore && Trigger.isUpdate) {
			KAUniqueThemeHandler.addNewTheme(Trigger.new);
		} 
	}
}