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

		DropBox__c dropToken = new DropBox__c(Name = 'Token');
		insert dropToken;

		PageReference currPage = Page.KAAdminUserHome;
		currPage.getParameters().put('chosenEmployee', testEmployee.Id);
		currPage.getParameters().put('chosenTest', testTest.Id);
		currPage.getParameters().put('deleteTaskId', testTask.Id);
		currPage.getParameters().put('updateTaskId', testEmploTask.Id);
		Test.setCurrentPage(currPage);

		adminController = new KAAdminHomeController();

		adminController.tmpEmployee = testEmployee.First_Name__c;
		adminController.tmpTest = testTest.Name;
	}

	@isTest static void testSwitchEmailing_On() {
		init();

		Test.startTest();

		adminController.switchEmailing();
		List<CronTrigger> scheduledTriggers = [
			SELECT Id
			FROM CronTrigger
		];

		Test.stopTest();

		System.assertEquals(scheduledTriggers.size() > 0, true);
	}

	@isTest static void testSwitchEmailing_Off() {
		init();

		Test.startTest();

		adminController.switchEmailing();
		adminController.switchEmailing();

		List<CronTrigger> scheduledTriggers = [
			SELECT Id
			FROM CronTrigger
		];

		Test.stopTest();

		System.assertEquals(scheduledTriggers.size() > 0, false);
	}

	@isTest static void testRefreshingTasks_Success() {
		init();

		Test.startTest();

		adminController.refreshRecentTasks();

		Test.stopTest();

		System.assertEquals(adminController.recentTasks.size(), 1);
	}

	@isTest static void testRefreshingResults_Success() {
		init();

		Test.startTest();

		adminController.refreshRecentResults();

		Test.stopTest();

		System.assertEquals(adminController.recentResults.size(), 1);
	}

	@isTest static void testTypingEmployee_Success() {
		init();

		Test.startTest();

		adminController.typeEmployee();

		Test.stopTest();

		System.assertEquals(adminController.employees.size(), 1);
	}

	@isTest static void testTypingTest_Success() {
		init();

		Test.startTest();

		adminController.typeTest();

		Test.stopTest();

		System.assertEquals(adminController.tests.size(), 1);
	}

	@isTest static void testChoosingEmployee_Success() {
		init();

		Test.startTest();

		adminController.chooseEmployee();

		Test.stopTest();

		System.assertEquals(adminController.employees.size(), 0);
	}

	@isTest static void testChoosingTest_Success() {
		init();

		Test.startTest();

		adminController.chooseTest();

		Test.stopTest();

		System.assertEquals(adminController.tests.size(), 0);
	}

	@isTest static void testCreatingTask_Success() {
		init();

		Test.startTest();

		adminController.chooseEmployee();
		adminController.chooseTest();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 10;
		adminController.createNewTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('success'), null);
	}

	@isTest static void testCreatingTask_TestFailure() {
		init();

		Test.startTest();

		adminController.chooseEmployee();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 10;
		adminController.createNewTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testCreatingTask_EmployeeFailure() {
		init();

		Test.startTest();

		adminController.chooseTest();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 10;
		adminController.createNewTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testCreatingTask_DateFailure() {
		init();

		Test.startTest();

		adminController.chooseEmployee();
		adminController.chooseTest();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() - 10;
		adminController.createNewTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testCreatingTask_ValidationFailure() {
		init();

		Test.startTest();

		adminController.chooseEmployee();
		adminController.chooseTest();
		adminController.createNewTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('danger'), null);
	}

	@isTest static void testDeletingTask_Success() {
		init();

		Test.startTest();

		adminController.prepareTaskToDelete();
		adminController.deleteTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('success'), null);
	}

	@isTest static void testUpdatingTask_Success() {
		init();

		Test.startTest();

		adminController.prepareTaskToUpdate();
		adminController.preCreatedTask.AssignTime__c = Datetime.now() + 1000;
		adminController.updateTask();

		Test.stopTest();

		System.assertNotEquals(adminController.notificMap.notificationMap.get('success'), null);
	}

}