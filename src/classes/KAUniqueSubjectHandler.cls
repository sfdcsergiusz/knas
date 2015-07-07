public with sharing class KAUniqueSubjectHandler {
	public static Boolean enablesTrigger = false;

	public static void addNewSubject(List<Subject__c> p_subject) {
		List<Subject__c> subjects = [
				SELECT Name
				FROM Subject__c
				WHERE Name = :p_subject.get(0).Name
				LIMIT 1 
		];

		if (subjects.size() > 0) {
			 //p_subject;
			 //addError
			 p_subject.get(0).addError('error');
		}
	}
}