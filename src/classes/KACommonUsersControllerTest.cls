@isTest
private class KACommonUsersControllerTest {

	private static KACommonUsersController usersController;

	private static void init() {
		Subject__c testSubject = new Subject__c(Name = 'testSubject');
		insert testSubject;

		Test__c testTest = new Test__c(Duration__c = 120, Subject__c = testSubject.Id);
		insert testTest;

		Test__c testTestNotPassed = new Test__c(Duration__c = 120, Subject__c = testSubject.Id);
		insert testTestNotPassed;

		Employee__c testEmployee = new Employee__c(Name = 'testName', First_Name__c = 'testFirstName');
		insert testEmployee;

		Browser__c testBrowser = new Browser__c(Employee__c = testEmployee.Id, Identifier__c = 'testIdentifier');
		insert testBrowser;

		Task__c testTask = new Task__c(Test__c = testTest.Id, Status__c = 'Scheduled');
		insert testTask;

		Employee_Task__c testEmploTask = new Employee_Task__c(Employee__c = testEmployee.Id, Task__c = testTask.Id);
		insert testEmploTask;

		Theme__c testTheme = new Theme__c(Name = 'testTheme', Subject__c = testSubject.Id);
		insert testTheme;

		TestTheme__c testTestTheme = new TestTheme__c(Theme__c = testTheme.Id, Test__c = testTest.Id, Questions_Captured__c = 2);
		insert testTestTheme;

		TestTheme__c testTestThemeNotPassed = new TestTheme__c(Theme__c = testTheme.Id, Test__c = testTestNotPassed.Id, Questions_Captured__c = 2);
		insert testTestThemeNotPassed;

		Question__c testQuestion = new Question__c(Theme__c = testTheme.Id, Statement__c = 'testStatement', Level__c = 'Junior');
		insert testQuestion;

		Answer__c testFirstAnswer = new Answer__c(Question__c = testQuestion.Id, Variant__c = 'testVariant', Right__c = true);
		Answer__c testSecondAnswer = new Answer__c(Question__c = testQuestion.Id, Variant__c = 'testVariant', Right__c = false);
		insert testFirstAnswer;
		insert testSecondAnswer;

		Question__c testQuestion2 = new Question__c(Theme__c = testTheme.Id, Statement__c = 'testStatement', Level__c = 'Junior');
		insert testQuestion2;

		Answer__c testFirstAnswer2 = new Answer__c(Question__c = testQuestion2.Id, Variant__c = 'testVariant', Right__c = true);
		Answer__c testSecondAnswer2 = new Answer__c(Question__c = testQuestion2.Id, Variant__c = 'testVariant', Right__c = true);
		insert testFirstAnswer2;
		insert testSecondAnswer2;

		Pass_History__c testHistory = new Pass_History__c(Test__c = testTest.Id, Employee__c = testEmployee.Id, Result__c = 50);
		insert testHistory;


		PageReference currPage = Page.KACommonUsers;
		currPage.getParameters().put('userId', testEmployee.Id);
		currPage.getParameters().put('activeUserId', testEmployee.Id);
		Test.setCurrentPage(currPage);

		usersController = new KACommonUsersController();
	}

	@isTest static void testTypeUserSelect_Success() {
		init();

		usersController.tmpUser = 'testName';
		usersController.typeUser();
		System.assertEquals(usersController.users.size() == 1, true);
	}

	@isTest static void testFreezeUser_Success() {
		init();

		usersController.changeActivity();
		System.assertEquals(usersController.users.get(0).IsActive__c, true);
	}

	@isTest static void testRenderUser_Success() {
		init();

		usersController.renderUser();
		System.assertEquals(usersController.renderedStatistic.keyset().size() == 1, true);
	}

}