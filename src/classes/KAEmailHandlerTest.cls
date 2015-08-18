@isTest
private class KAEmailHandlerTest {

	private static KAEmailHandler emailHandler;

	private static void init() {
		Employee__c testEmployee = new Employee__c(Name = 'test@mail.ru', First_Name__c = 'testFName', Waiting_Reset__c = true, Action_Hash__c = 'testHash');
		insert testEmployee;

		Test__c testTest = new Test__c(Name = 'testTest');
		insert testTest;

		Task__c testTask = new Task__c(Test__c = testTest.Id, AssignTime__c = Datetime.now() + 200);
		insert testTask;

		Employee_Task__c testEmploTask = new Employee_Task__c(Task__c = testTask.Id, Employee__c = testEmployee.Id, IsEmailQueue__c = true);
		insert testEmploTask;

		emailHandler = new KAEmailHandler();
	}

	@isTest static void testExecute() {
		init();

		Test.startTest();

		emailHandler.sendAction();
		Employee_Task__c assertEmploTask = [
			SELECT IsEmailQueue__c
			FROM Employee_Task__c
			LIMIT 1
		];

		Test.stopTest();

		System.assertEquals(assertEmploTask.IsEmailQueue__c, false);
	}

}