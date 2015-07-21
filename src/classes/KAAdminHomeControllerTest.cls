@isTest
private class KAAdminHomeControllerTest {

	private static KAAdminHomeController adminController;

	private static void init() {
		Employee__c testEmployee = new Employee__c(Name = 'test@test.com', First_Name__c = 'testFirstName');
		insert testEmployee;

		Test__c testTest = new Test__c(Name = 'testTest');
		insert testTest;

		Task__c testTask = new Task__c(Test__c = testTest.Id);
		insert testTask;

		Pass_History__c testHistory = new Pass_History__c(Test__c = testTest.Id, Employee__c = testEmployee.Id);
		insert testHistory;

		Employee_Task__c testEmploTask = new Employee_Task__c(Employee__c = testEmployee.Id, Task__c = testTask.Id);
		insert testEmploTask;

		PageReference currPage = Page.KAAdminUserHome;
		currPage.getParameters().put('chosenEmployee', testEmployee.Id);
		currPage.getParameters().put('chosenTest', testTest.Id);
		Test.setCurrentPage(currPage);

		adminController = new KAAdminHomeController();

		adminController.tmpEmployee = testEmployee.First_Name__c;
		adminController.tmpTest = testTest.Name;
	}

	@isTest static void testSwitchEmailing_On() {
		init();

		adminController.switchEmailing();
		List<CronTrigger> scheduledTriggers = [
			SELECT Id
			FROM CronTrigger
		];
		System.assertEquals(scheduledTriggers.size() > 0, true);
	}

	@isTest static void testSwitchEmailing_Off() {
		init();

		adminController.switchEmailing();
		adminController.switchEmailing();

		List<CronTrigger> scheduledTriggers = [
			SELECT Id
			FROM CronTrigger
		];
		System.assertEquals(scheduledTriggers.size() > 0, false);
	}

	@isTest static void testRefreshingTasks_Success() {
		init();

		adminController.refreshRecentTasks();
		System.assertEquals(adminController.recentTasks.size(), 1);
	}

	@isTest static void testRefreshingResults_Success() {
		init();

		adminController.refreshRecentResults();
		System.assertEquals(adminController.recentResults.size(), 1);
	}

	@isTest static void testTypingEmployee_Success() {
		init();

		adminController.typeEmployee();
		System.assertEquals(adminController.employees.size(), 1);
	}

	@isTest static void testTypingTest_Success() {
		init();

		adminController.typeTest();
		System.assertEquals(adminController.tests.size(), 1);
	}

	@isTest static void testChoosingEmployee_Success() {
		init();

		adminController.chooseEmployee();
		System.assertEquals(adminController.employees.size(), 0);
	}

	@isTest static void testChoosingTest_Success() {
		init();

		adminController.chooseTest();
		System.assertEquals(adminController.tests.size(), 0);
	}

	@isTest static void testCreatingTask_Success() {
		init();

		adminController.chooseEmployee();
		adminController.chooseTest();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 10;
		adminController.createNewTask();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('success'), null);
	}

	@isTest static void testCreatingTask_TestFailure() {
		init();

		adminController.chooseEmployee();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 10;
		adminController.createNewTask();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testCreatingTask_EmployeeFailure() {
		init();

		adminController.chooseTest();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 10;
		adminController.createNewTask();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testCreatingTask_DateFailure() {
		init();

		adminController.chooseEmployee();
		adminController.chooseTest();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() - 10;
		adminController.createNewTask();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testCreatingTask_ValidationFailure() {
		init();

		adminController.chooseEmployee();
		adminController.chooseTest();
		adminController.createNewTask();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

}