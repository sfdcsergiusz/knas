public with sharing class KARegularHomeController {

	private Id userId { private get; private set; }

	public String launchedTestId { get; set; }
	public String lastTestResult { get; set; }
	public Datetime lastTimeResult { get; set; }

	public Boolean isUserActive { get; private set; }
	public List<Pass_History__c> statistics { get; private set; }
	public List<Employee_Task__c> upcomingTests { get; private set; }
	public List<Pass_History__c> passedTests { get; private set; }
	public KANotificationMapWrapper notificMap { get; private set; }

	public KARegularHomeController() {
		notificMap = new KANotificationMapWrapper();
		upcomingTests = new List<Employee_Task__c>();
		passedTests = new List<Pass_History__c>();
		statistics = new List<Pass_History__c>();

		Cookie tmpCookie = ApexPages.currentPage().getCookies().get('Identifier');
		if (tmpCookie != null) {
			List<Browser__c> tmpBrowsers = [
				SELECT Employee__r.Id, Employee__r.IsActive__c
				FROM Browser__c
				WHERE Identifier__c = :tmpCookie.getValue()
				LIMIT 1
			];

			if ( ! tmpBrowsers.isEmpty()) {
				userId = tmpBrowsers.get(0).Employee__r.Id;
				isUserActive = tmpBrowsers.get(0).Employee__r.IsActive__c;

				if ( ! isUserActive) {
					notificMap.addInfo('You are registered now. Please, wait for activation.');
				}

				upcomingTests = [
					SELECT Name, Task__r.AssignTime__c, Task__r.Test__r.Name, Task__r.Test__r.Difficulty__c,
					Task__r.Test__r.Subject__r.Name, Task__r.Test__r.Id, Task__r.Status__c
					FROM Employee_Task__c
					WHERE Employee__r.Id = :userId
					ORDER BY Task__r.AssignTime__c DESC
					LIMIT 50000
				];
				passedTests = [
					SELECT Name, Employee__c, CreatedDate, Result__c, Test__r.Name, Test__r.Subject__r.Name, Test__r.Passing_Threshold__c, Test__r.Difficulty__c
					FROM Pass_History__c
					WHERE Employee__r.Id = :userId
					ORDER BY CreatedDate DESC
					LIMIT 50000
				];
				if (passedTests.size() > 0) {
					lastTestResult = String.valueOf(passedTests.get(0).Result__c);
					lastTimeResult = passedTests.get(0).CreatedDate;
				}
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