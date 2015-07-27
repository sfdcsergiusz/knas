@isTest
private class KATestPassingControllerTest {

	private static KATestPassingController passingController;

	private static void init() {
		Subject__c testSubject = new Subject__c(Name = 'testSubject');
		insert testSubject;

		Test__c testTest = new Test__c(Duration__c = 120, Subject__c = testSubject.Id, Difficulty__c = 'Lead');
		insert testTest;

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

		Question__c testQuestion = new Question__c(Theme__c = testTheme.Id, Statement__c = 'testStatement', Level__c = 'Lead');
		insert testQuestion;

		Answer__c testFirstAnswer = new Answer__c(Question__c = testQuestion.Id, Variant__c = 'testVariant', Right__c = true);
		Answer__c testSecondAnswer = new Answer__c(Question__c = testQuestion.Id, Variant__c = 'testVariant', Right__c = false);
		insert testFirstAnswer;
		insert testSecondAnswer;

		Question__c testQuestion2 = new Question__c(Theme__c = testTheme.Id, Statement__c = 'testStatement', Level__c = 'Lead');
		insert testQuestion2;

		Answer__c testFirstAnswer2 = new Answer__c(Question__c = testQuestion2.Id, Variant__c = 'testVariant', Right__c = true);
		Answer__c testSecondAnswer2 = new Answer__c(Question__c = testQuestion2.Id, Variant__c = 'testVariant', Right__c = true);
		insert testFirstAnswer2;
		insert testSecondAnswer2;

		PageReference currPage = Page.KATestPassing;
		currPage.getParameters().put('test', testTest.Id);
		currPage.getParameters().put('questOnEdit', '1');
		currPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', testBrowser.Identifier__c, null, 1000, false)
			}
		);
		Test.setCurrentPage(currPage);

		passingController = new KATestPassingController();
	}

	@isTest static void testBackAction_Success() {
		init();

		System.assertEquals(passingController.goBack().getRedirect(), true);
	}

	@isTest static void testStartTest_Success() {
		init();

		passingController.startTest();
		System.assertNotEquals(passingController.questions.size(), 0);
	}

	@isTest static void testConstructionWithoutTest_Success() {
		init();
		List<Test__c> testsListToDelete = [
			SELECT Id
			FROM Test__c
		];
		delete testsListToDelete;
		passingController = new KATestPassingController();

		passingController.startTest();
		System.assertEquals(passingController.totalQuestionsNum, null);
	}

	@isTest static void testStartTestWithoutUser_Success() {
		init();
		List<Employee__c> usersListToDelete = [
			SELECT Id
			FROM Employee__c
		];
		delete usersListToDelete;

		passingController.startTest();
		System.assertEquals(passingController.totalQuestionsNum, null);
	}

	@isTest static void testStartTestWithoutTask_Success() {
		init();
		List<Task__c> tasksListToDelete = [
			SELECT Id
			FROM Task__c
		];
		delete tasksListToDelete;

		passingController.startTest();
		System.assertEquals(passingController.totalQuestionsNum, null);
	}

	@isTest static void testSingleQuestionTransfer_Success() {
		init();

		passingController.startTest();

		passingController.goToNext();
		passingController.goToPrev();
		passingController.goToFinish();
		System.assertEquals(passingController.isFinishBlockEnabled, true);
	}

	@isTest static void testQuestionAnswersEdit_Success() {
		init();

		passingController.startTest();
		passingController.goToQuestions();
		System.assertNotEquals(passingController.currentQuestion, null);
	}

	@isTest static void testGettingSelectOptions_Success() {
		init();

		passingController.startTest();
		passingController.goToQuestions();
		passingController.getVariantOptions();
		System.assertNotEquals(passingController.getVariantOptions().size(), 0);
	}

	@isTest static void testFinishTest_Success() {
		init();

		passingController.startTest();
		passingController.goToNext();
		passingController.goToPrev();
		passingController.goToFinish();
		System.assertEquals(passingController.finishTest().getRedirect(), true);
	}

}