public with sharing class KANavigationBarController {

	public Browser__c browserUser { get; private set; }
	public Boolean isStartPage { get; private set; }
	public Boolean isAdminPage { get; private set; }
	public PageReference target { get; private set; }
	public String showingPageName { get; private set; }
	public String packagePrefix { get; private set; }

	private PageReference currentPage { private get; private set; }

	private void init() {
		currentPage = ApexPages.currentPage();
		isStartPage = currentPage.getUrl().toUpperCase().contains('LOGIN') || currentPage.getUrl().toUpperCase().contains('REGISTER') || currentPage.getUrl().toUpperCase().contains('PASSWORD');
		isAdminPage = isStartPage ? false : true;

		if ( ! isStartPage) {
			for (String page : KAPageConstants.userPages) {
				if (currentPage.getUrl().toUpperCase().contains(page.toUpperCase())) {
					isAdminPage = false;
					break;
				}
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

		showingPageName = KAPageConstants.pageNames.get(currentPage.getUrl().split('/apex/')[1].split('\\?')[0].toUpperCase());
	}

	public KANavigationBarController() {
		init();
	}

	public PageReference onLoad() {
		target = null;
		packagePrefix = KAPageConstants.packagePrefix;

		if (getLoginCookie() != null) {
			List<Browser__c> browsers = [
				SELECT Identifier__c, Employee__r.Name, Employee__r.Password__c,
					Employee__r.IsAdmin__c, Employee__r.IsActive__c,
					Employee__r.First_Name__c, Employee__r.Last_Name__c
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
		if ( ! isStartPage) {
			if (browserUser.Employee__r.IsAdmin__c) {
				homePage = new PageReference('/apex/KAAdminUserHome');
			}
			else {
				homePage = new PageReference('/apex/KARegularUserHome');
			}
			homePage.setRedirect(true);
		}
		return homePage;
	}

	public PageReference goToUsers() {
		return new PageReference('/apex/KACommonUsers');
	}

	public PageReference goToData() {
		return new PageReference('/apex/KACommonSubjects');
	}

	public PageReference goToTests() {
		return new PageReference('/apex/KACommonTests');
	}

	public PageReference makeLogout() {
		ApexPages.currentPage().setCookies(
			new Cookie[] {
				new Cookie('Identifier', '', null, 0, false)
			}
		);
		if (browserUser != null) {
			List<Browser__c> currentBrowserList = [
				SELECT Id
				FROM Browser__c
				WHERE Id = :browserUser.Id
			];
			if ( ! currentBrowserList.isEmpty()) {
				delete currentBrowserList;
				browserUser = null;
			}
		}

		return new PageReference('/apex/KALogin');
	}

	private Cookie getLoginCookie() {
		return ApexPages.currentPage().getCookies().get('Identifier');
	}
}