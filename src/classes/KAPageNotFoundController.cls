public with sharing class KAPageNotFoundController {

	public KANotificationMapWrapper notificMap { get; private set; }
	
	public KAPageNotFoundController() {
		notificMap = new KANotificationMapWrapper();
		notificMap.addInfo('This page is not found.');
	}
}