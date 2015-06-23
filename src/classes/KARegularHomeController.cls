public with sharing class KARegularHomeController {

	private String username { private get; private set; }

	public String launchedTestId { get; set; }
	public String lastTestResult { get; set; }
	public Datetime lastTimeResult { get; set; }

	public List<Pass_History__c> statistics { get; private set; }
	public List<Employee_Task__c> upcomingTests { get; private set; }
	public List<Pass_History__c> passedTests { get; private set; }

	public KARegularHomeController() {
		Cookie tmpCookie = ApexPages.currentPage().getCookies().get('KALogin');
		if (tmpCookie != null) {
			username = tmpCookie.getValue();

			upcomingTests = [
				SELECT Name, Task__r.AssignTime__c, Task__r.Test__r.Name, Task__r.Test__r.Subject__r.Name, Task__r.Test__r.Id
				FROM Employee_Task__c
				WHERE Employee__r.Name =: username
				ORDER BY Task__r.AssignTime__c DESC
				LIMIT 50000
			];
			passedTests = [
				SELECT Name, Employee__c, CreatedDate, Result__c, Test__r.Name, Test__r.Subject__r.Name
				FROM Pass_History__c
				WHERE Employee__r.Name =: username
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			if (passedTests.size() > 0) {
				lastTestResult = String.valueOf(passedTests.get(0).Result__c);
				lastTimeResult = passedTests.get(0).CreatedDate;
			}
		}
	}

	public PageReference launchTest() {
		if (launchedTestId != null && launchedTestId != '') {
			return new PageReference('/apex/KATestPassing?test=' + launchedTestId);
		}
		return null;
	}

}