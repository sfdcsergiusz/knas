@isTest
private class KAStatisticControllerTest {

	private static KAStatisticController testStatContr;

	private static void init() {
		Employee__c testEmployee = new Employee__c(First_Name__c = 'testName', Last_Name__c = 'testLastName', Password__c = 'testPass');
		insert testEmployee;

		Subject__c testSubject1 = new Subject__c();
		insert testSubject1;

		Subject__c testSubject2 = new Subject__c();
		insert testSubject2;

		Test__c test1 = new Test__c(Name = 'test1', Subject__c = testSubject1.Id);
		insert test1;

		Test__c test2 = new Test__c(Name = 'test2', Subject__c = testSubject2.Id);
		insert test2;

		Double testResult1 = 66.5;
		Double testResult2 = 10;
		Pass_History__c testHistory1 = new Pass_History__c(Employee__c = testEmployee.Id, Result__c = testResult1, Test__c = test1.Id );
		insert testHistory1;

		Pass_History__c testHistory2 = new Pass_History__c(Employee__c = testEmployee.Id, Result__c = testResult2, Test__c = test2.Id );
		insert testHistory2;

		PageReference currPage = Page.KAStatistic;
  		currPage.getParameters().put('userId', testEmployee.Id);
  		Test.setCurrentPage(currPage);
		testStatContr = new KAStatisticController();

	}

	@isTest static void testRefreshRecentResults() {
		init();

		Test.startTest();

		testStatContr.refreshRecentResults();
		Integer tableSize = testStatContr.recentResults.size();

		Test.stopTest();

		System.assertEquals(2, tableSize);

	}

	@isTest static void testOrderByCreatedOn() {
		init();

		Test.startTest();

		testStatContr.orderByCreatedOn();
		Datetime  testItem1 = testStatContr.recentResults.get(0).createdDate;
		testStatContr.orderByCreatedOn();
		Datetime  testItem2 = testStatContr.recentResults.get(0).createdDate;

		Test.stopTest();

		System.assertEquals(testItem1, testItem2);

	}


	@isTest static void testOrderBySubject() {
		init();

		Test.startTest();

		testStatContr.orderBySubject();
		String  testName1 = testStatContr.recentResults.get(0).Test__r.Subject__r.Name;
		testStatContr.orderBySubject();
		String  testName2 = testStatContr.recentResults.get(0).Test__r.Subject__r.Name;

		Test.stopTest();

		System.assertNotEquals(testName1, testName2);

	}

	@isTest static void testOrderByTestTitle() {
		init();

		Test.startTest();

		testStatContr.orderByTestTitle();
		String  testName1 = testStatContr.recentResults.get(0).Test__r.Name;
		testStatContr.orderByTestTitle();
		String  testName2 = testStatContr.recentResults.get(0).Test__r.Name;

		Test.stopTest();

		System.assertNotEquals(testName1, testName2);

	}

	@isTest static void testOrderByPassResult() {
		init();

		Test.startTest();

		testStatContr.orderByPassResult();
		Double  testName1 = testStatContr.recentResults.get(0).Result__c;
		testStatContr.orderByPassResult();
		Double  testName2 = testStatContr.recentResults.get(0).Result__c;

		Test.stopTest();

		System.assertNotEquals(testName1, testName2);

	}


}