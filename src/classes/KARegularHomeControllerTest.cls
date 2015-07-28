@isTest
private class KARegularHomeControllerTest {

	private static KARegularHomeController regularController;

	private static void init() {
		Employee__c testEmployee = new Employee__c(Name = 'test@test.com', First_Name__c = 'testFirstName');
		insert testEmployee;

		Browser__c testBrowser = new Browser__c(Employee__c = testEmployee.Id, Identifier__c = 'testIdentifier');
		insert testBrowser;

		Test__c testTest = new Test__c(Name = 'testTest');
		insert testTest;

		Task__c testTask = new Task__c(Test__c = testTest.Id);
		insert testTask;

		Pass_History__c testHistory = new Pass_History__c(Test__c = testTest.Id, Employee__c = testEmployee.Id);
		insert testHistory;

		Employee_Task__c testEmploTask = new Employee_Task__c(Employee__c = testEmployee.Id, Task__c = testTask.Id);
		insert testEmploTask;

		PageReference currPage = Page.KARegularUserHome;
		currPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', testBrowser.Identifier__c, null, 1000, false)
			}
		);
		Test.setCurrentPage(currPage);

		regularController = new KARegularHomeController();
	}

	@isTest static void testConstruction_Success() {
		init();

		System.assertNotEquals(regularController.upcomingTests, null);
	}

	@isTest static void testLaunchingTest_Success() {
		init();

		regularController.launchedTestId = 'success';
		System.assertNotEquals(regularController.launchTest(), null);
	}

	@isTest static void testLaunchingTest_Failure() {
		init();

		System.assertEquals(regularController.launchTest(), null);
	}

}