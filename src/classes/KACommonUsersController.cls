public with sharing class KACommonUsersController {

	public List<Employee__c> users { get; set; }

	public Employee__c renderedUser { get; set; }
	public List<Pass_History__c> userPassingStat { get; set; }
	public List<TestTheme__c> testThemeStat { get; set; }

	public Map<Subject__c, Map<Theme__c, Map<Test__c, Pass_History__c>>> renderedStatistic { get; set; }
	public List<Subject__c> allSubjects { get; set; }


	public String backLink {
		get {
			return 'apex/' + KAPageConstants.packagePrefix + 'KAAdminUserHome';
		}
		private set;
	}
	public String tmpUser { get; set; }

	private void init() {
		allSubjects = [
			SELECT Name,
			(
				SELECT Name
				FROM Themes__r
			)
			FROM Subject__c
		];
		renderedStatistic = new Map<Subject__c, Map<Theme__c, Map<Test__c, Pass_History__c>>>();

		renderedUser = new Employee__c();
		userPassingStat = new List<Pass_History__c>();
		testThemeStat = new List<TestTheme__c>();
		tmpUser = '';

		users = [
			SELECT Name, First_Name__c, Last_Name__c, CreatedDate, IsActive__c
			FROM Employee__c
			WHERE IsAdmin__c = false
		];
	}

	public KACommonUsersController() {
		init();
	}

	public void typeUser() {
		String searchUser = '%' + tmpUser + '%';
		users = [
			SELECT Name, First_Name__c, Last_Name__c, CreatedDate, IsActive__c
			FROM Employee__c
			WHERE IsAdmin__c = false
				AND (
					Name LIKE :searchUser
					OR First_Name__c LIKE :searchUser
					OR Last_Name__c LIKE :searchUser
				)
		];
	}

	public void changeActivity() {
		Employee__c activeFreezeUser = [
			SELECT Name, First_Name__c, Last_Name__c, CreatedDate, IsActive__c
			FROM Employee__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('activeUserId')
			LIMIT 1
		];
		activeFreezeUser.IsActive__c = activeFreezeUser.IsActive__c ? false : true;
		update activeFreezeUser;

		users = [
			SELECT Name, First_Name__c, Last_Name__c, CreatedDate, IsActive__c
			FROM Employee__c
			WHERE IsAdmin__c = false
		];
	}

	public void renderUser() {
		renderedUser = [
			SELECT Name, First_Name__c, Last_Name__c, CreatedDate
			FROM Employee__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('userId')
			LIMIT 1
		];

		userPassingStat = [
			SELECT Employee__r.Name, Employee__r.First_Name__c, Employee__r.Last_Name__c, Employee__r.CreatedDate,
				CreatedDate, Result__c, Test__r.Id, Test__r.Name, Test__r.Duration__c
			FROM Pass_History__c
			WHERE Employee__r.Id = :ApexPages.currentPage().getParameters().get('userId')
		];

		testThemeStat = [
			SELECT Questions_Captured__c, Theme__r.Name, Theme__r.Subject__r.Name,
				Test__r.Id, Test__r.Name, Test__r.Duration__c, Test__r.Difficulty__c, Test__r.Passing_Threshold__c
			FROM TestTheme__c
		];

		renderedStatistic = new Map<Subject__c, Map<Theme__c, Map<Test__c, Pass_History__c>>>();
		Map<Theme__c, Map<Test__c, Pass_History__c>> secondLevelMap;
		Map<Test__c, Pass_History__c> thirdLevelMap;

		for (Subject__c tmpSubject : allSubjects) {

			secondLevelMap = new Map<Theme__c, Map<Test__c, Pass_History__c>>();
			for (Theme__c tmpTheme : tmpSubject.Themes__r) {

				thirdLevelMap = new Map<Test__c, Pass_History__c>();
				for (TestTheme__c tmpTestTheme : testThemeStat) {

					if (tmpTestTheme.Theme__r.Id == tmpTheme.Id) {
						Boolean wasPassed = false;
						for (Pass_History__c currentPassing : userPassingStat) {
							if (currentPassing.Test__r.Id == tmpTestTheme.Test__r.Id) {
								thirdLevelMap.put(
									new Test__c(
										Name = tmpTestTheme.Test__r.Name,
										Duration__c = tmpTestTheme.Test__r.Duration__c,
										Difficulty__c = tmpTestTheme.Test__r.Difficulty__c,
										Passing_Threshold__c = tmpTestTheme.Test__r.Passing_Threshold__c
									),
									currentPassing
								);
								wasPassed = true;
								break;
							}
						}
						if ( ! wasPassed) {
							thirdLevelMap.put(
								new Test__c(
									Name = tmpTestTheme.Test__r.Name,
									Duration__c = tmpTestTheme.Test__r.Duration__c,
									Difficulty__c = tmpTestTheme.Test__r.Difficulty__c
								),
								new Pass_History__c(
									Result__c = -1
								)
							);
						}
					}
				}

				secondLevelMap.put(tmpTheme, thirdLevelMap);
			}

			renderedStatistic.put(tmpSubject, secondLevelMap);
		}
	}

}