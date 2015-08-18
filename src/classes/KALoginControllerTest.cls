@isTest
private class KALoginControllerTest {

	private static KALoginController loginController;

	private static void init() {
		Employee__c testEmployee = new Employee__c(
			Name = 'testName', First_Name__c = 'testFirstName',
			Password__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf('testPass')))
		);
		insert testEmployee;

		Browser__c testBrowser = new Browser__c(Employee__c = testEmployee.Id, Identifier__c = 'testIdentifier');
		insert testBrowser;

		PageReference currPage = Page.KALogin;
		currPage.getParameters().put('mainId', testBrowser.Identifier__c);
		Test.setCurrentPage(currPage);

		loginController = new KALoginController();
		loginController.username = testEmployee.Name;
		loginController.password = 'testPass';
	}

	@isTest static void testRegisterRedirect_Success() {
		init();

		Test.startTest();

		loginController.setIdentifier();

		Test.stopTest();

		System.assertNotEquals(loginController.register(), null);
	}

	@isTest static void testResetPass_Success() {
		init();

		Test.startTest();

		loginController.setIdentifier();
		loginController.resetPass();

		Test.stopTest();

		System.assertEquals(loginController.notificMap.notificationMap.keyset().isEmpty(), false);
	}

	@isTest static void testResetPass_Failure() {
		init();

		Test.startTest();

		loginController.setIdentifier();
		loginController.username = 'failure';
		loginController.resetPass();

		Test.stopTest();

		System.assertEquals(loginController.notificMap.notificationMap.keyset().isEmpty(), false);
	}

	@isTest static void testLogin_Success() {
		init();

		Test.startTest();

		loginController.setIdentifier();

		Test.stopTest();

		System.assertNotEquals(loginController.login(), null);
	}

	@isTest static void testLoginAdmin_Success() {
		init();

		Test.startTest();

		List<Employee__c> employeesToDelete = [
			SELECT Id
			FROM Employee__c
		];
		delete employeesToDelete;

		Employee__c testEmployee = new Employee__c(
			Name = 'testName', First_Name__c = 'testFirstName',
			Password__c = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', Blob.valueOf('testPass'))),
			IsAdmin__c = true
		);
		insert testEmployee;

		loginController.setIdentifier();

		Test.stopTest();

		System.assertNotEquals(loginController.login(), null);
	}

	@isTest static void testLogin_PassFailure() {
		init();

		Test.startTest();

		loginController.password = 'failure';
		loginController.setIdentifier();

		Test.stopTest();

		System.assertEquals(loginController.login(), null);
	}

	@isTest static void testLogin_UsernameFailure() {
		init();

		Test.startTest();

		loginController.username = 'failure';
		loginController.setIdentifier();

		Test.stopTest();

		System.assertEquals(loginController.login(), null);
	}

}