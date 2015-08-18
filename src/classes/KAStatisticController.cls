public with sharing class KAStatisticController {

	public List<Pass_History__c> recentResults { get; set; }
	public String sortResults { get; set; }

	public String userId { get; set; }
	private Boolean isSort { private get; private set; }

	private void init() {
		userId = ApexPages.currentPage().getParameters().get('userId');
		refreshRecentResults();
		sortResults = 'SELECT Employee__r.First_Name__c, Employee__r.Last_Name__c, CreatedDate, Result__c, Test__r.Subject__r.Name, Test__r.Name FROM Pass_History__c ';
		isSort = true;
	}

	public KAStatisticController() {
		init();
	}
	public void refreshRecentResults() {
		recentResults = [
			SELECT Employee__r.First_Name__c, Employee__r.Last_Name__c,
				CreatedDate, Result__c, Test__r.Subject__r.Name, Test__r.Name
			FROM Pass_History__c
			WHERE Employee__r.Id = :userId
			ORDER BY CreatedDate DESC
			LIMIT 50000
		];
	}

	public void orderByCreatedOn() {
		isSort = isSort ? false : true;

		if (isSort) {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY CreatedDate DESC  LIMIT 50000');
		}
		else {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY CreatedDate LIMIT 50000');
		}
	}

	public void orderBySubject() {
		isSort = isSort ? false : true;

		if (isSort) {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY Test__r.Subject__r.Name LIMIT 50000');
		}
		else {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY Test__r.Subject__r.Name DESC LIMIT 50000');
		}
	}

	public void orderByTestTitle() {
		isSort = isSort ? false : true;

		if (isSort) {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY Test__r.Name LIMIT 50000');
		}
		else {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY Test__r.Name DESC LIMIT 50000');
		}
	}

	public void orderByPassResult() {
		isSort = isSort ? false : true;

		if (isSort) {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY Result__c LIMIT 50000');
		}
		else {
			recentResults = database.query(sortResults + 'WHERE Employee__r.Id = \'' + userId + '\' ORDER BY Result__c DESC LIMIT 50000');
		}
	}
}