public with sharing class KANavigationBarController {

	public Browser__c browserUser { get; private set; }
	public Boolean isStartPage { get; private set; }
	public Boolean isAdminPage { get; private set; }
	public PageReference target { get; private set; }

	private PageReference currentPage { private get; private set; }

	public KANavigationBarController() {
		currentPage = ApexPages.currentPage();
		isStartPage = currentPage.getUrl().contains('Login') || currentPage.getUrl().contains('Register');
		isAdminPage = true;

		for (String page : KAPageConstants.userPages) {
			if (currentPage.getUrl().contains(page)) {
				isAdminPage = false;
				break;
			}
		}

		if (getLoginCookie() != null) {
			List<Browser__c> browsers = [
				SELECT Identifier__c, Employee__r.Name, Employee__r.Password__c, Employee__r.IsAdmin__c, Employee__r.First_Name__c, Employee__r.Last_Name__c
				FROM Browser__c
				WHERE Identifier__c = :getLoginCookie().getValue()
				LIMIT 1
			];
			browserUser = ! browsers.isEmpty() ? browsers.get(0) : null;
		}
	}

	public PageReference onLoad() {
		target = null;

		if (getLoginCookie() != null) {
			List<Browser__c> browsers = [
				SELECT Identifier__c, Employee__r.Name, Employee__r.Password__c, Employee__r.IsAdmin__c, Employee__r.First_Name__c, Employee__r.Last_Name__c
				FROM Browser__c
				WHERE Identifier__c = :getLoginCookie().getValue()
				LIMIT 1
			];
			browserUser = ! browsers.isEmpty() ? browsers.get(0) : null;
			if (browserUser != null) {
				return target;
			}
		}
		else if ( ! isStartPage) {
			target = new PageReference('/apex/KALogin');
			target.setRedirect(true);
		}
		return target;
	}

	public PageReference goHome() {
		PageReference homePage;
		if (browserUser.Employee__r.IsAdmin__c) {
			homePage = Page.KAAdminUserHome;
		}
		else {
			homePage = Page.KARegularUserHome;
		}
		homePage.setRedirect(true);
		return homePage;
	}

	public PageReference makeLogout() {
		ApexPages.currentPage().setCookies(
			new Cookie[] {
				new Cookie('Identifier', '', null, 0, false)
			}
		);
		if (browserUser != null) {
			delete browserUser;
			browserUser = null;
		}

		return new PageReference('/apex/KALogin');
	}

	private void setLoginCookie(String id) {
		ApexPages.currentPage().setCookies(
		    new Cookie[] {
		        new Cookie('Identifier', id, null, 1000, false)
		    }
		);
	}

	private Cookie getLoginCookie() {
		return ApexPages.currentPage().getCookies().get('Identifier');
	}
}