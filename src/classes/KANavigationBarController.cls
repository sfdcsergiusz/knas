public with sharing class KANavigationBarController {

	public Browser__c browserUser { get; private set; }

	private String username { private get; private set; }
	private PageReference currentPage { private get; private set; }

	public KANavigationBarController() {
		currentPage = ApexPages.currentPage();
		Cookie tmpCookie = currentPage.getCookies().get('KALogin');
		if (tmpCookie != null) {
			username = tmpCookie.getValue();
		}
	}

	public PageReference onLoad() {
		if (getLoginCookie() != null) {
			List<Browser__c> browsers = [
				SELECT Identifier__c, Employee__r.Name, Employee__r.Password__c, Employee__r.IsAdmin__c, Employee__r.First_Name__c, Employee__r.Last_Name__c
				FROM Browser__c
				WHERE Identifier__c = :getLoginCookie().getValue()
				LIMIT 1
			];
			browserUser = ! browsers.isEmpty() ? browsers.get(0) : null;
			if (browserUser != null) {
				return null;
			}
		}
		return new PageReference('/apex/KALogin');
	}

	public PageReference goHome() {
		return null;
	}

	public PageReference makeLogout() {
		ApexPages.currentPage().setCookies(
			new Cookie[] {
				new Cookie('Identifier', '', null, 0, false)
			}
		);
		return new PageReference('/apex/KALogin');
	}

	private void setLoginCookie(String id) {
		currentPage.setCookies(
		    new Cookie[] {
		        new Cookie('Identifier', id, null, 1000, false)
		    }
		);
	}

	private Cookie getLoginCookie() {
		return currentPage.getCookies().get('Identifier');
	}
}