@isTest
private class KACommonTestsControllerTest {

	private static KACommonTestsController testsController;

	private static void init() {
		Subject__c testSubject = new Subject__c(Name = 'testSubject');
		insert testSubject;

		Test__c testTest = new Test__c(Name = 'testTest', Duration__c = 120, Subject__c = testSubject.Id);
		insert testTest;

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

		PageReference currPage = Page.KAAdminUserHome;
		currPage.getParameters().put('themeId', testTheme.Id);
		currPage.getParameters().put('statTheme', testTheme.Id);
		currPage.getParameters().put('testToDelete', testTest.Id);
		Test.setCurrentPage(currPage);

		testsController = new KACommonTestsController();
	}
	
	@isTest static void testTypeSubjectSelect_Success() {
		init();

		testsController.tmpSubject = 'testSubject';
		testsController.typeSubject();
		System.assertEquals(testsController.subjects.size() > 0, true);
	}

	@isTest static void testCreatingTest_Success() {
		init();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_QuestionsFailure() {
		init();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = -1;
		testsController.preCreateTest();
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_NullQuestionsFailure() {
		init();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = null;
		testsController.preCreateTest();
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_ThemeQuestionsFailure() {
		init();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 10;
		testsController.preCreateTest();
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_DurationFailure() {
		init();

		testsController.preCreatedTest.Duration__c = -120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_NullDurationFailure() {
		init();

		testsController.preCreatedTest.Duration__c = null;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_EqualTestFailure() {
		init();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.preCreatedTest.Name = 'testTest';
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_SubjectForTestFailure() {
		init();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.testSubjectName = 'failure';
		testsController.createTest();
		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}
	
	@isTest static void testCreatingThemeStatistic_Success() {
		init();

		testsController.createThemeStatistic();
		System.assertNotEquals(testsController.themeStatistic.size() == 0, true);
	}

	@isTest static void testClearingThemeStatistic_Success() {
		init();

		testsController.createThemeStatistic();
		testsController.clearThemeStatistic();
		System.assertEquals(testsController.themeStatistic.size() == 0, true);
	}

	@isTest static void testDeleteingTest_Success() {
		init();

		testsController.deleteTest();
		System.assertEquals(testsController.subjects.size() == 1, true);
	}

	@isTest static void testSubjectsListRedirecting_Success() {
		init();

		System.assertNotEquals(testsController.goToSubjectList(), null);
	}

	@isTest static void testUploadCSVRedirecting_Success() {
		init();

		System.assertNotEquals(testsController.goToUploadCSV(), null);
	}

	@isTest static void testResetSearch_Success() {
		init();

		testsController.resetSearch();
		System.assertEquals(testsController.subjects.size() == 1, true);
	}
	
}