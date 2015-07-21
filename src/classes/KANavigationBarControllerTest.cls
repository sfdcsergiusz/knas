@isTest
private class KANavigationBarControllerTest {

	private static KANavigationBarController navigationController;

	private static void init() {
		Employee__c testEmployee = new Employee__c(Name = 'testName', First_Name__c = 'testFirstName');
		insert testEmployee;

		Browser__c testBrowser = new Browser__c(Employee__c = testEmployee.Id, Identifier__c = 'testIdentifier');
		insert testBrowser;

		PageReference currPage = Page.KARegularUserHome;
		currPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', testBrowser.Identifier__c, null, 1000, false)
			}
		);
		Test.setCurrentPage(currPage);

		navigationController = new KANavigationBarController();
	}

	@isTest static void testUserPageConstruction_Success() {
		init();

		System.assertNotEquals(navigationController.browserUser, null);
	}

	@isTest static void testUsersRedirection_Success() {
		init();

		System.assertNotEquals(navigationController.goToUsers(), null);
	}

	@isTest static void testTestsRedirection_Success() {
		init();

		System.assertNotEquals(navigationController.goToTests(), null);
	}

	@isTest static void testDataRedirection_Success() {
		init();

		System.assertNotEquals(navigationController.goToData(), null);
	}

	@isTest static void testOnLoadStartPage_Success() {
		init();

		System.assertEquals(navigationController.onLoad(), null);
	}

	@isTest static void testOnLoadNotStartPage_Success() {
		init();
		PageReference currPage = Page.KACreateNewPassword;
		Test.setCurrentPage(currPage);

		System.assertNotEquals(navigationController.onLoad(), null);
	}

	@isTest static void testLogout_Success() {
		init();

		System.assertNotEquals(navigationController.makeLogout(), null);
	}

	@isTest static void testRegularHomeRedirection_Success() {
		init();

		System.assertEquals(navigationController.goHome().getUrl().toUpperCase().contains('REGULAR'), true);
	}

	@isTest static void testAdminHomeRedirection_Success() {
		init();

		List<Employee__c> usersToDeleteList = [
			SELECT Id
			FROM Employee__c
		];
		delete usersToDeleteList;

		Employee__c testEmployee = new Employee__c(Name = 'testName', First_Name__c = 'testFirstName', IsAdmin__c = true);
		insert testEmployee;

		Browser__c testBrowser = new Browser__c(Employee__c = testEmployee.Id, Identifier__c = 'testIdentifier');
		insert testBrowser;

		PageReference currPage = Page.KARegularUserHome;
		currPage.setCookies(
			new Cookie[] {
				new Cookie('Identifier', testBrowser.Identifier__c, null, 1000, false)
			}
		);
		Test.setCurrentPage(currPage);

		navigationController = new KANavigationBarController();

		System.assertEquals(navigationController.goHome().getUrl().toUpperCase().contains('ADMIN'), true);
	}

}