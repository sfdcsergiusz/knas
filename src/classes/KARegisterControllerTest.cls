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
		registerController.firstName = 'testFirstName';
		registerController.lastName = 'testLastName';
	}

	@isTest static void testRegister_Success() {
		init();

		registerController.setIdentifier();
		System.assertNotEquals(registerController.register(), null);
	}

	@isTest static void testLogin_Success() {
		init();

		registerController.setIdentifier();
		System.assertNotEquals(registerController.login(), null);
	}

	@isTest static void testUsernameNotification_Success() {
		init();

		registerController.setIdentifier();
		registerController.username = '';
		registerController.register();
		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

	@isTest static void testPasswordNotification_Success() {
		init();

		registerController.setIdentifier();
		registerController.password = '';
		registerController.register();

		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

	@isTest static void testFirstNameNotification_Success() {
		init();

		registerController.setIdentifier();
		registerController.firstName = '';
		registerController.register();
		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

	@isTest static void testLastNameNotification_Success() {
		init();

		registerController.setIdentifier();
		registerController.lastName = '';
		registerController.register();
		System.assertNotEquals(registerController.notificMap.notificationMap.keyset().size(), 0);
	}

}