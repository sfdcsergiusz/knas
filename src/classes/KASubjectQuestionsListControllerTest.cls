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

		DropBox__c dropToken = new DropBox__c(Name = 'Token');
		insert dropToken;

		PageReference currPage = Page.KATestPassing;
		currPage.getParameters().put('themeId', testTheme.Id);
		currPage.getParameters().put('subjectId', testSubject.Id);
		currPage.getParameters().put('chosenTheme', testTheme.Id);
		currPage.getParameters().put('chosenSubject', testSubject.Id);
		currPage.getParameters().put('answerIndex', '0');
		currPage.getParameters().put('chosenQuestion', testQuestion.Id);
		currPage.getParameters().put('deleteQuestionId', testQuestion.Id);
		currPage.getParameters().put('updateQuestionId', testQuestion.Id);
		Test.setCurrentPage(currPage);
	}

	@isTest static void testDeletingQuestion() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.prepareQuestionToDelete();
		questListController.deleteQuestion();

		Test.stopTest();

		System.assertNotEquals(questListController.notificMap.notificationMap.get('info'), null);
	}

	@isTest static void testUpdatingQuestion() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.prepareQuestionToUpdate();
		questListController.tmpSubject = [
			SELECT Name
			FROM Subject__c
			LIMIT 1
		].get(0).Name;
		questListController.tmpTheme = [
			SELECT Name
			FROM Theme__c
			LIMIT 1
		].get(0).Name;
		questListController.preCreatedQuestion.Statement__c = 'testStatement';
		questListController.preCreatedQuestion.Level__c = 'Junior';
		questListController.preCreatedAnswers = [
			SELECT Variant__c, Right__c
			FROM Answer__c
		];
		questListController.updateQuestion();

		Test.stopTest();

		System.assertNotEquals(questListController.notificMap.notificationMap.get('success'), null);
	}

	@isTest static void testTypingSubject_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.typeSubject();

		Test.stopTest();

		System.assertEquals(questListController.subjects.size(), 1);
	}

	@isTest static void testTypingTheme_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.typeTheme();

		Test.stopTest();

		System.assertEquals(questListController.themes.size(), 1);
	}

	@isTest static void testChoosingSubject_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.chooseSubject();

		Test.stopTest();

		System.assertEquals(questListController.subjects.size(), 0);
	}

	@isTest static void testChoosingTheme_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.chooseTheme();

		Test.stopTest();

		System.assertEquals(questListController.themes.size(), 0);
	}

	@isTest static void testAddEmptyAnswer_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.addAnswer();

		Test.stopTest();

		System.assertNotEquals(questListController.preCreatedAnswers.size() == 0, true);
	}

	@isTest static void testReduceAnswer_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.reduceAnswer();

		Test.stopTest();

		System.assertEquals(questListController.preCreatedAnswers.size() == 2, true);
	}

	@isTest static void testRefreshingWithoutQuestions_Success() {
		init();
		Subject__c testSubjectForId = new Subject__c(Name = 'testSubjectForId');
		insert testSubjectForId;

		Theme__c testThemeForId = new Theme__c(Name = 'testThemeForId', Subject__c = testSubjectForId.Id);
		insert testThemeForId;
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.themeId = testThemeForId.Id;
		questListController.refreshQuestions(false);

		Test.stopTest();

		System.assertNotEquals(questListController.subjectId, null);
	}

	@isTest static void testRefreshingWithoutTheme_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.themeId = null;
		questListController.refreshQuestions(false);

		Test.stopTest();

		System.assertNotEquals(questListController.subjectId, null);
	}

	@isTest static void testCreatingQuestion_Success() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();

		Test.stopTest();

		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_EmptyAnswerFailure() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = '', Right__c = false));
		questListController.createQuestion();

		Test.stopTest();

		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_WrongAnswerFailure() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();

		Test.stopTest();

		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}


	@isTest static void testCreatingQuestion_QuestionStatementFailure() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.preCreatedQuestion = new Question__c(Statement__c = null, Level__c = 'Junior');
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = '', Right__c = false));
		questListController.createQuestion();

		Test.stopTest();

		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_QuestionLevelFailure() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = null);
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();

		Test.stopTest();

		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingQuestion_ThemeExistenceFailure() {
		init();
		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		questListController = new KASubjectQuestionsListController();

		questListController.tmpTheme = 'testFailure';
		questListController.tmpSubject = 'testFailure';
		questListController.preCreatedQuestion = new Question__c(Statement__c = 'testStatement', Level__c = null);
		questListController.preCreatedAnswers.clear();
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = true));
		questListController.preCreatedAnswers.add(new Answer__c(Variant__c = 'testVariant', Right__c = false));
		questListController.createQuestion();

		Test.stopTest();

		System.assertEquals(questListController.notificMap.notificationMap.keyset().size() == 1, true);
	}
}