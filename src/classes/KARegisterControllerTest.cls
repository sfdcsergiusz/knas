@isTest
private class KARegisterControllerTest {

	private static KARegisterController registerController;

	private static void init() {
		PageReference currPage = Page.KARegister;
		currPage.getParameters().put('mainId', 'identifier');
		Test.setCurrentPage(currPage);

		registerController = new KARegisterController();
		registerController.username = 'testUsername';
		registerController.password = 'testPassword';
		registerController.passwordConfirmation = 'testPassword';
		registerController.firstName = 'testFirstName';
		registerController.lastName = 'testLastName';
	}

	@isTest static void testRegister_Success() {
		init();

		Test.startTest();

		registerController.setIdentifier();

		Test.stopTest();

		System.assertNotEquals(registerController.register(), null);
	}

	@isTest static void testLogin_Success() {
		init();

		Test.startTest();

		registerController.setIdentifier();

		Test.stopTest();

		System.assertNotEquals(registerController.login(), null);
	}

	@isTest static void testUsernameNotification_Success() {
		init();

		Test.startTest();

		registerController.setIdentifier();
		registerController.username = '';
		registerController.register();

		Test.stopTest();

		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

	@isTest static void testPasswordNotification_Success() {
		init();

		Test.startTest();

		registerController.setIdentifier();
		registerController.password = '';
		registerController.register();

		Test.stopTest();

		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

	@isTest static void testFirstNameNotification_Success() {
		init();

		Test.startTest();

		registerController.setIdentifier();
		registerController.firstName = '';
		registerController.register();

		Test.stopTest();

		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

	@isTest static void testLastNameNotification_Success() {
		init();

		Test.startTest();

		registerController.setIdentifier();
		registerController.lastName = '';
		registerController.register();

		Test.stopTest();

		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

}