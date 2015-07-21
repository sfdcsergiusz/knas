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

		notificWrapper.addDanger('success');
		System.assertEquals(notificWrapper.isEmpty, false);
	}

	@isTest static void testAddSuccess_Success() {
		init();

		notificWrapper.addSuccess('success');
		System.assertEquals(notificWrapper.isEmpty, false);
	}

	@isTest static void testAddInfo_Success() {
		init();

		notificWrapper.addInfo('success');
		System.assertEquals(notificWrapper.isEmpty, false);
	}

	@isTest static void testClearMap_Success() {
		init();

		notificWrapper.addDanger('success');
		notificWrapper.addDanger('cleared');
		notificWrapper.addSuccess('success');
		notificWrapper.addInfo('success');
		System.assertEquals(notificWrapper.getCurrentMessage().split(':')[2], 'cleared');
	}

	@isTest static void testGetDanger_Success() {
		init();

		notificWrapper.addDanger('success');
		System.assertNotEquals(notificWrapper.getCurrentMessage(), null);
	}

	@isTest static void testGetSuccess_Success() {
		init();

		notificWrapper.addSuccess('success');
		System.assertNotEquals(notificWrapper.getCurrentMessage(), null);
	}

	@isTest static void testGetInfo_Success() {
		init();

		notificWrapper.addInfo('success');
		System.assertNotEquals(notificWrapper.getCurrentMessage(), null);
	}

	@isTest static void testGetNullMessage_Success() {
		init();

		System.assertEquals(notificWrapper.getCurrentMessage(), null);
	}

}