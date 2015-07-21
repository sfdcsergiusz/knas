@isTest
private class KASubjectQuestionsListControllerTest {

	private static KASubjectQuestionsListController questListController;

	private static void init() {
		Subject__c testSubject = new Subject__c(Name = 'testSubject');
		insert testSubject;

		Test__c testTest = new Test__c(Duration__c = 120, Subject__c = testSubject.Id);
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

		PageReference currPage = Page.KATestPassing;
		currPage.getParameters().put('themeId', testTheme.Id);
		currPage.getParameters().put('subjectId', testSubject.Id);
		currPage.getParameters().put('chosenTheme', testTheme.Id);
		currPage.getParameters().put('chosenSubject', testSubject.Id);
		currPage.getParameters().put('answerIndex', '0');
		currPage.getParameters().put('chosenQuestion', testQuestion.Id);
		Test.setCurrentPage(currPage);

		questListController = new KASubjectQuestionsListController();		
	}
	
	@isTest static void testDeletingQuestion() {
		init();

		questListController.deleteQuestion();
		System.assertEquals(questListController.questions.size() == 1, true);
	}
	
	@isTest static void testTypingSubject_Success() {
		init();

		questListController.typeSubject();
		System.assertEquals(questListController.subjects.size(), 1);
	}

	@isTest static void testTypingTheme_Success() {
		init();

		questListController.typeTheme();
		System.assertEquals(questListController.themes.size(), 1);
	}

	@isTest static void testChoosingSubject_Success() {
		init();

		questListController.chooseSubject();
		System.assertEquals(questListController.subjects.size(), 0);
	}

	@isTest static void testChoosingTheme_Success() {
		init();

		questListController.chooseTheme();
		System.assertEquals(questListController.themes.size(), 0);
	}

	@isTest static void testRemoteQuestionUpdate_Success() {
		init();

		KASubjectQuestionsListController.tmpJSON = new JSON(); 
		System.assertEquals(KASubjectQuestionsListController.startUpdateQuestion('id'), null);
	}

	@isTest static void testAddEmptyAnswer_Success() {
		init();

		questListController.addAnswer();
		System.assertNotEquals(questListController.preCreatedAnswers.size() == 0, true);
	}

	@isTest static void testReduceAnswer_Success() {
		init();

		questListController.reduceAnswer();
		System.assertEquals(questListController.preCreatedAnswers.size() == 1, true);
	}

	@isTest static void testRefreshingWithoutQuestions_Success() {
		init();

		Subject__c testSubjectForId = new Subject__c(Name = 'testSubjectForId');
		insert testSubjectForId;

		Theme__c testThemeForId = new Theme__c(Name = 'testThemeForId', Subject__c = testSubjectForId.Id);
		insert testThemeForId;

		questListController.themeId = testThemeForId.Id;
		questListController.refreshQuestions();
		System.assertNotEquals(questListController.subjectId, null);
	}

	@isTest static void testRefreshingWithoutTheme_Success() {
		init();
		
		questListController.themeId = null;
		questListController.refreshQuestions();
		System.assertNotEquals(questListController.subjectId, null);
	}

	@isTest static void testCreatingQuestion_Success() {
		init();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();
		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}
	
	@isTest static void testCreatingQuestion_EmptyAnswerFailure() {
		init();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = '', Right__c = false));
		questListController.createQuestion();
		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_WrongAnswerFailure() {
		init();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();
		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}


	@isTest static void testCreatingQuestion_QuestionStatementFailure() {
		init();

		questListController.preCreatedQuestion = new Question__c(Statement__c = null, Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = '', Right__c = false));
		questListController.createQuestion();
		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_QuestionLevelFailure() {
		init();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = null);
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();
		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_ThemeExistenceFailure() {
		init();

		questListController.tmpTheme = 'testFailure';
		questListController.tmpSubject = 'testFailure';
		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = null);
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();
		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}
}