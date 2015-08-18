@isTest
private class KACommonSubjectsControllerTest {

	private static KACommonSubjectsController subjectsController;

	private static void init() {
		Subject__c testSubject = new Subject__c(Name = 'testSubject');
		insert testSubject;

		Test__c testTest = new Test__c(Duration__c = 120, Subject__c = testSubject.Id);
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
		currPage.getParameters().put('subjectName', testSubject.Name);
		currPage.getParameters().put('deleteParam', 'somethingToDelete');
		currPage.getParameters().put('deleteTopicId', testTheme.Id);
		currPage.getParameters().put('deleteSubjectId', testSubject.Id);
		currPage.getParameters().put('updateTopicId', testTheme.Id);
		currPage.getParameters().put('updateSubjectId', testSubject.Id);
		Test.setCurrentPage(currPage);

		subjectsController = new KACommonSubjectsController();
	}

	@isTest static void testTypeSubjectSelect_Success() {
		init();

		Test.startTest();

		subjectsController.tmpSubject = 'testSubject';
		subjectsController.typeSubject();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() > 0, true);
	}

	@isTest static void testCreateSubject_Success() {
		init();

		Test.startTest();

		subjectsController.tmpSubject = 'newTestSubject';
		subjectsController.createSubject();
		subjectsController.tmpSubject = '';
		subjectsController.typeSubject();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 2, true);
	}

	@isTest static void testCreateSubject_ExistingFailure() {
		init();

		Test.startTest();

		subjectsController.tmpSubject = 'testSubject';
		subjectsController.typeSubject();
		subjectsController.createSubject();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testCreateSubject_EmptyFailure() {
		init();

		Test.startTest();

		subjectsController.tmpSubject = '';
		subjectsController.typeSubject();
		subjectsController.createSubject();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testCreateTheme_Success() {
		init();

		Test.startTest();

		subjectsController.tmpTheme = 'newTestTheme';
		subjectsController.createTheme();

		Test.stopTest();

		System.assertEquals(subjectsController.tmpTheme == '', true);
	}

	@isTest static void testCreateThemeAnotherCondition_Success() {
		init();

		Test.startTest();

		subjectsController.tmpTheme = 'newTestTheme';
		subjectsController.tmpSubject = 'newTestSubject';
		subjectsController.createTheme();

		Test.stopTest();

		System.assertEquals(subjectsController.tmpTheme == '', true);
	}

	@isTest static void testCreateTheme_ExistingFailure() {
		init();

		Test.startTest();

		subjectsController.tmpTheme = 'testTheme';
		subjectsController.createTheme();

		Test.stopTest();

		System.assertEquals(subjectsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreateTheme_EmptyFailure() {
		init();

		Test.startTest();

		subjectsController.tmpTheme = '';
		subjectsController.createTheme();

		Test.stopTest();

		System.assertEquals(subjectsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testDeleteSubject_Success() {
		init();

		Test.startTest();

		subjectsController.typeSubject();

		insert new Subject__c(Name = 'somethingToDelete');

		subjectsController.deleteSubject();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, false);
	}

	@isTest static void testDeleteSubjectAnotherCondition_Success() {
		init();

		Test.startTest();

		subjectsController.typeSubject();

		insert new Subject__c(Name = 'somethingToDelete');

		subjectsController.tmpSubject = 'newTestSubject';
		subjectsController.prepareSubjectToDelete();
		subjectsController.deleteSubject();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 0, true);
	}

	@isTest static void testRedirectToThemeList_Success() {
		init();

		System.assertNotEquals(subjectsController.goToThemeList(), null);
	}

	@isTest static void testRedirectToSubjectList_Success() {
		init();

		System.assertNotEquals(subjectsController.goToSubjectList(), null);
	}

	@isTest static void testRedirectToCSVUpload_Success() {
		init();

		System.assertNotEquals(subjectsController.goToUploadCSV(), null);
	}

	@isTest static void testResetSearch_Success() {
		init();

		Test.startTest();

		subjectsController.resetSearch();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testDeletingTopic_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		subjectsController.prepareTopicToDelete();
		subjectsController.deleteTopic();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testUpdatingTopic_Failure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		subjectsController.prepareTopicToUpdate();
		subjectsController.updateTopic();
		subjectsController.resetSearch();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testUpdatingSubject_Failure() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		subjectsController.prepareSubjectToUpdate();
		subjectsController.updateSubject();
		subjectsController.resetSearch();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testUpdatingTopic_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		subjectsController.prepareTopicToUpdate();
		subjectsController.tmpTheme = 'testUpdate';
		subjectsController.updateTopic();
		subjectsController.resetSearch();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testUpdatingSubject_Success() {
		init();

		Test.setMock(HttpCalloutMock.class, new KADropBoxServiceMock());

		Test.startTest();

		subjectsController.prepareSubjectToUpdate();
		subjectsController.tmpSubject = 'testUpdate';
		subjectsController.updateSubject();
		subjectsController.resetSearch();

		Test.stopTest();

		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testBackLinkInit_Success() {
		init();

		System.assert(subjectsController.backLink.contains('Admin'));
	}

}