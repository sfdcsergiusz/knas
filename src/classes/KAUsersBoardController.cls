public with sharing class KAUsersBoardController {

	public List<Employee__c> users { get; private set; }

	public KAUsersBoardController() {
		users = [
			SELECT First_Name__c, Last_Name__c
			FROM Employee__c
			LIMIT 50000
		];
	}
	
	public PageReference goToUsers() {
		//Employee__c currentEmployee = [
		//	SELECT Id
		//	FROM Employee__c
		//	WHERE Name = :username
		//	LIMIT 1
		//];
	return new PageReference('/apex/KAStatistic?userId=' + ApexPages.currentPage().getParameters().get('userId'));	
	}
}