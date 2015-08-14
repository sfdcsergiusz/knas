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

		DropBox__c dropToken = new DropBox__c(Name = 'Token');
		insert dropToken;

		PageReference currPage = Page.KAAdminUserHome;
		currPage.getParameters().put('themeId', testTheme.Id);
		currPage.getParameters().put('statTheme', testTheme.Id);
		currPage.getParameters().put('deleteTestId', testTest.Id);
		currPage.getParameters().put('updateTestId', testTest.Id);
		Test.setCurrentPage(currPage);

		testsController = new KACommonTestsController();
	}

	@isTest static void testTypeSubjectSelect_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.tmpSubject = 'testSubject';
		testsController.typeSubject();

		Test.stopTest();

		System.assertEquals(testsController.subjects.size() > 0, true);
	}

	@isTest static void testCreatingTest_Failure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreateTest();
		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTest.Passing_Threshold__c = 66;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.createTest();

		Test.stopTest();

		System.assert(testsController.notificMap.notificationMap.get('danger') != null);
	}

	@isTest static void testUpdatingTest_Failure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.prepareTestToUpdate();
		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTest.Passing_Threshold__c = 66;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.updateTest();

		Test.stopTest();

		System.assert(testsController.notificMap.notificationMap.get('danger') != null);
	}

	@isTest static void testDeletingTest_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.prepareTestToDelete();
		testsController.deleteTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_QuestionsFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = -1;
		testsController.preCreateTest();
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_NullQuestionsFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = null;
		testsController.preCreateTest();
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_ThemeQuestionsFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 10;
		testsController.preCreateTest();
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_DurationFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = -120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_NullDurationFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = null;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_EqualTestFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.preCreatedTest.Name = 'testTest';
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingTest_SubjectForTestFailure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.preCreatedTest.Duration__c = 120;
		testsController.preCreatedTestTheme.Questions_Captured__c = 1;
		testsController.preCreateTest();
		testsController.testSubjectName = 'failure';
		testsController.createTest();

		Test.stopTest();

		System.assertEquals(testsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreatingThemeStatistic_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.createThemeStatistic();

		Test.stopTest();

		System.assertNotEquals(testsController.themeStatistic.size() == 0, true);
	}

	@isTest static void testClearingThemeStatistic_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.createThemeStatistic();
		testsController.clearThemeStatistic();

		Test.stopTest();

		System.assertEquals(testsController.themeStatistic.size() == 0, true);
	}

	@isTest static void testSubjectsListRedirecting_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		PageReference testRef = testsController.goToSubjectList();

		Test.stopTest();

		System.assertNotEquals(testRef, null);
	}

	@isTest static void testUploadCSVRedirecting_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		PageReference testRef = testsController.goToUploadCSV();

		Test.stopTest();

		System.assertNotEquals(testRef, null);
	}

	@isTest static void testResetSearch_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		testsController.resetSearch();

		Test.stopTest();

		System.assertEquals(testsController.subjects.size() == 1, true);
	}

	@isTest static void testBackLinkRightness_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		System.assert(testsController.backLink.contains('Admin'));
	}

}