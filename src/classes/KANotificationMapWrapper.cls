public with sharing class KANotificationMapWrapper {

	public Map<String, String> notificationMap { get; private set; }
	public Boolean isEmpty { get; private set; }

	public KANotificationMapWrapper() {
		resetNotifications();
	}

	public void addDanger(String message) {
		addMessage('danger', message);
	}

	public void addSuccess(String message) {
		addMessage('success', message);
	}

	public void addInfo(String message) {
		addMessage('info', message);
	}

	public String getCurrentMessage() {
		if (notificationMap.get('danger') != null || notificationMap.get('success') != null || notificationMap.get('info') != null) {
			String returnValue;
			if (notificationMap.get('danger') != null) {
				returnValue = 'danger:splitter:' + notificationMap.get('danger');
			}
			else if (notificationMap.get('success') != null) {
				returnValue = 'success:splitter:' + notificationMap.get('success');
			}
			else if (notificationMap.get('info') != null) {
				returnValue = 'info:splitter:' + notificationMap.get('info');
			}
			resetNotifications();
			return returnValue;
		}
		else {
			return null;
		}
	}

	private void resetNotifications() {
		notificationMap = new Map<String, String>();
		isEmpty = true;
	}

	private void addMessage(String type, String message) {
		notificationMap.put(type, message);
		isEmpty = false;
	}

}