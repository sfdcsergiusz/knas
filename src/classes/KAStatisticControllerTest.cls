@isTest
private class KAStatisticControllerTest {
	private static Employee__c testEmploee1;
	private static Employee__c testEmploee2;
	private static Test__c test1;
	private static Test__c test2;
	private static Double testResult1;
	private static Double testResult2;
	private static Subject__c testSubject1;
	private static Subject__c testSubject2;
	private static Pass_History__c testHistory1;
	private static Pass_History__c testHistory2;


	private static void init() {
		testEmploee1 = new Employee__c(First_Name__c = 'testName', Last_Name__c = 'testLastName', Password__c = 'testPass');
		insert testEmploee1;
		testEmploee2 = new Employee__c(First_Name__c = 'testName2', Last_Name__c = 'testLastName2', Password__c = 'testPass2');
		insert testEmploee2;
		testSubject1 = new Subject__c();
		insert testSubject1;
		testSubject2 = new Subject__c();
		insert testSubject2;
		test1 = new Test__c(Name = 'test1', Subject__c = testSubject1.Id);
		insert test1;
		test2 = new Test__c(Name = 'test2', Subject__c = testSubject2.Id);
		insert test2;
		testResult1 = 66.5;
		testResult2 = 10;
		testHistory1 = new Pass_History__c(Employee__c = testEmploee1.Id, Result__c = testResult1, Test__c = test1.Id );
		insert testHistory1;
		testHistory2 = new Pass_History__c(Employee__c = testEmploee2.Id, Result__c = testResult2, Test__c = test2.Id );
		insert testHistory2;
	}

	@isTest static void testRefreshRecentResults() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.refreshRecentResults();
		Integer tableSize = testStatContr.recentResults.size();
		System.assertEquals(2, tableSize);

	}

	@isTest static void testOrderByCreatedOn() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.orderByCreatedOn();
		Datetime  testItem1 = testStatContr.recentResults.get(0).createdDate;
		testStatContr.orderByCreatedOn();
		Datetime  testItem2 = testStatContr.recentResults.get(0).createdDate;
		System.assertEquals(testItem1, testItem2);

	}

	@isTest static void testOrderByName() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.orderByName();
		String  testName1 = testStatContr.recentResults.get(0).Employee__r.First_Name__c;
		testStatContr.orderByName();
		String  testName2 = testStatContr.recentResults.get(0).Employee__r.First_Name__c;
		System.assertNotEquals(testName1, testName2);

	}

	@isTest static void testOrderByLastName() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.orderByLastName();
		String  testName1 = testStatContr.recentResults.get(0).Employee__r.Last_Name__c;
		testStatContr.orderByLastName();
		String  testName2 = testStatContr.recentResults.get(0).Employee__r.Last_Name__c;
		System.assertNotEquals(testName1, testName2);

	}

	@isTest static void testOrderBySubject() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.orderBySubject();
		String  testName1 = testStatContr.recentResults.get(0).Test__r.Subject__r.Name;
		testStatContr.orderBySubject();
		String  testName2 = testStatContr.recentResults.get(0).Test__r.Subject__r.Name;
		System.assertNotEquals(testName1, testName2);

	}

	@isTest static void testOrderByTestTitle() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.orderByTestTitle();
		String  testName1 = testStatContr.recentResults.get(0).Test__r.Name;
		testStatContr.orderByTestTitle();
		String  testName2 = testStatContr.recentResults.get(0).Test__r.Name;
		System.assertNotEquals(testName1, testName2);

	}

	@isTest static void testOrderByPassResult() {
		init();
		KAStatisticController testStatContr = new KAStatisticController();
		testStatContr.orderByPassResult();
		Double  testName1 = testStatContr.recentResults.get(0).Result__c;
		testStatContr.orderByPassResult();
		Double  testName2 = testStatContr.recentResults.get(0).Result__c;
		System.assertNotEquals(testName1, testName2);

	}


}