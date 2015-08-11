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

		PageReference currPage = Page.KAAdminUserHome;
		currPage.getParameters().put('subjectName', testSubject.Name);
		currPage.getParameters().put('deleteParam', 'somethingToDelete');
		Test.setCurrentPage(currPage);

		subjectsController = new KACommonSubjectsController();
	}

	@isTest static void testTypeSubjectSelect_Success() {
		init();

		subjectsController.tmpSubject = 'testSubject';
		subjectsController.typeSubject();
		System.assertEquals(subjectsController.subjects.size() > 0, true);
	}

	@isTest static void testCreateSubject_Success() {
		init();

		subjectsController.tmpSubject = 'newTestSubject';
		subjectsController.createSubject();
		subjectsController.tmpSubject = '';
		subjectsController.typeSubject();
		System.assertEquals(subjectsController.subjects.size() == 2, true);
	}

	@isTest static void testCreateSubject_ExistingFailure() {
		init();

		subjectsController.tmpSubject = 'testSubject';
		subjectsController.createSubject();
		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testCreateSubject_EmptyFailure() {
		init();

		subjectsController.tmpSubject = '';
		subjectsController.createSubject();
		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testCreateTheme_Success() {
		init();

		subjectsController.tmpTheme = 'newTestTheme';
		subjectsController.createTheme();
		System.assertEquals(subjectsController.tmpTheme == '', true);
	}

	@isTest static void testCreateThemeAnotherCondition_Success() {
		init();

		subjectsController.tmpTheme = 'newTestTheme';
		subjectsController.tmpSubject = 'newTestSubject';
		subjectsController.createTheme();
		System.assertEquals(subjectsController.tmpTheme == '', true);
	}

	@isTest static void testCreateTheme_ExistingFailure() {
		init();

		subjectsController.tmpTheme = 'testTheme';
		subjectsController.createTheme();
		System.assertEquals(subjectsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testCreateTheme_EmptyFailure() {
		init();

		subjectsController.tmpTheme = '';
		subjectsController.createTheme();
		System.assertEquals(subjectsController.notificMap.notificationMap.keyset().size() == 1, true);
	}

	@isTest static void testDeleteSubject_Success() {
		init();

		insert new Subject__c(Name = 'somethingToDelete');

		subjectsController.deleteSubject();
		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

	@isTest static void testDeleteSubjectAnotherCondition_Success() {
		init();

		insert new Subject__c(Name = 'somethingToDelete');

		subjectsController.tmpSubject = 'newTestSubject';
		subjectsController.deleteSubject();
		System.assertEquals(subjectsController.subjects.size() == 0, true);
	}

	//@isTest static void testDeleteTheme_Success() {
	//	init();

	//	Subject__c subjectForTheme = new Subject__c(Name = 'subjectForTheme');
	//	insert subjectForTheme;

	//	insert new Theme__c(Name = 'somethingToDelete', Subject__c = subjectForTheme.Id);

	//	subjectsController.deleteTheme();
	//	System.assertEquals(subjectsController.subjects.size() == 2, true);
	//}

	//@isTest static void testDeleteThemeAnotherCondition_Success() {
	//	init();

	//	Subject__c subjectForTheme = new Subject__c(Name = 'subjectForTheme');
	//	insert subjectForTheme;

	//	insert new Theme__c(Name = 'somethingToDelete', Subject__c = subjectForTheme.Id);

	//	subjectsController.tmpSubject = 'newTestSubject';
	//	subjectsController.deleteTheme();
	//	System.assertEquals(subjectsController.subjects.size() == 0, true);
	//}

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

		subjectsController.resetSearch();
		System.assertEquals(subjectsController.subjects.size() == 1, true);
	}

}