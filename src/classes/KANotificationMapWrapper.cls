public with sharing class KANotificationMapWrapper {

	public Map<String, String> notificationMap { get; private set; }
	public Boolean isEmpty {
		get {
			if (notificationMap.keySet().size() == 0) {
				return true;
			}
			return false;
		}
		private set;
	}

	public KANotificationMapWrapper() {
		notificationMap = new Map<String, String>();
	}

	public void addDanger(String message) {
		notificationMap.put('danger', message);
	}

	public void addSuccess(String message) {
		notificationMap.put('success', message);
	}

	public void addInfo(String message) {
		notificationMap.put('info', message);
	}

	public String getCurrentMessage() {
		if (notificationMap.get('danger') != null) {
			String returnValue = 'danger:splitter:' + notificationMap.get('danger');
			clearMap();
			return returnValue;
		}
		else if (notificationMap.get('success') != null) {
			String returnValue = 'success:splitter:' + notificationMap.get('success');
			clearMap();
			return returnValue;
		}
		else if (notificationMap.get('info') != null) {
			String returnValue = 'info:splitter:' + notificationMap.get('info');
			clearMap();
			return returnValue;
		}
		return null;
	}

	private void clearMap() {
		notificationMap = new Map<String,String>();
	}

}