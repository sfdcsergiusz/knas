@isTest
private class KANotificationMapWrapperTest {

	private static KANotificationMapWrapper notificWrapper;

	private static void init() {
		notificWrapper = new KANotificationMapWrapper();
	}

	@isTest static void testIsMapEmpty_Success() {
		init();

		System.assertEquals(notificWrapper.isEmpty, true);
	}

	@isTest static void testAddDanger_Success() {
		init();

		Test.startTest();

		notificWrapper.addDanger('success');

		Test.stopTest();

		System.assertEquals(notificWrapper.isEmpty, false);
	}

	@isTest static void testAddSuccess_Success() {
		init();

		Test.startTest();

		notificWrapper.addSuccess('success');

		Test.stopTest();

		System.assertEquals(notificWrapper.isEmpty, false);
	}

	@isTest static void testAddInfo_Success() {
		init();

		Test.startTest();

		notificWrapper.addInfo('success');

		Test.stopTest();

		System.assertEquals(notificWrapper.isEmpty, false);
	}

	@isTest static void testClearMap_Success() {
		init();

		Test.startTest();

		notificWrapper.addDanger('success');
		notificWrapper.addDanger('cleared');
		notificWrapper.addSuccess('success');
		notificWrapper.addInfo('success');

		Test.stopTest();

		System.assertEquals(notificWrapper.getCurrentMessage().split(':')[2], 'cleared');
	}

	@isTest static void testGetDanger_Success() {
		init();

		Test.startTest();

		notificWrapper.addDanger('success');

		Test.stopTest();

		System.assertNotEquals(notificWrapper.getCurrentMessage(), null);
	}

	@isTest static void testGetSuccess_Success() {
		init();

		Test.startTest();

		notificWrapper.addSuccess('success');

		Test.stopTest();

		System.assertNotEquals(notificWrapper.getCurrentMessage(), null);
	}

	@isTest static void testGetInfo_Success() {
		init();

		Test.startTest();

		notificWrapper.addInfo('success');

		Test.stopTest();

		System.assertNotEquals(notificWrapper.getCurrentMessage(), null);
	}

	@isTest static void testGetNullMessage_Success() {
		init();

		System.assertEquals(notificWrapper.getCurrentMessage(), null);
	}

}