public with sharing class KACommonTestsController {

	public List<Subject__c> subjects { get; set; }
	public List<Test__c> tests { get; set; }

	public String tmpSubject { get; set; }
	public String updatingTest { get; set; }
	public String testThemeName { get; set; }
	public Integer themeAvailableQuestions { get; set; }
	public String testSubjectName { get; set; }

	public TestTheme__c preCreatedTestTheme { get; set; }
	public Test__c preCreatedTest { get; set; }
	public Test__c deletingTest { get; set; }
	public List<TestTheme__c> themeStatistic { get; set; }

	public KANotificationMapWrapper notificMap { get; private set; }
	public String backLink {
		get {
			return 'apex/' + KAPageConstants.packagePrefix + 'KAAdminUserHome';
		}
		private set;
	}

	private Theme__c tmpTheme { private get; private set; }

	public KACommonTestsController() {
		tmpSubject = '';
		preCreatedTestTheme = new TestTheme__c();
		preCreatedTest = new Test__c();
		deletingTest = new Test__c(Name = 'Loading...');
		themeStatistic = new List<TestTheme__c>();
		notificMap = new KANotificationMapWrapper();

		selectAllSubjects();
	}

	public void typeSubject() {
		String searchSubject = '%' + tmpSubject + '%';
		subjects = [
			SELECT Name, Themes_Number__c,
			(
				SELECT Name, Questions_Number__c, Tests_Number__c
				FROM Themes__r
				ORDER BY Name ASC
				LIMIT 50000
			)
			FROM Subject__c
			WHERE Name LIKE :searchSubject
			ORDER BY Name ASC
			LIMIT 50000
		];
	}

	public void preCreateTest() {
		if (ApexPages.currentPage().getParameters().get('themeId') != null && ApexPages.currentPage().getParameters().get('themeId') != '') {
			tmpTheme = [
				SELECT Id, Name, Subject__r.Name, Questions_Number__c,
					(
						SELECT Id
						FROM Questions__r
						WHERE Level__c = :preCreatedTest.Difficulty__c
					)
				FROM Theme__c
				WHERE Id = :ApexPages.currentPage().getParameters().get('themeId')
			];
		}
		else {
			tmpTheme = [
				SELECT Id, Name, Subject__r.Name, Questions_Number__c,
					(
						SELECT Id
						FROM Questions__r
						WHERE Level__c = :preCreatedTest.Difficulty__c
					)
				FROM Theme__c
				WHERE Id = :tmpTheme.Id
			];
		}
		themeAvailableQuestions = tmpTheme.Questions__r.size();
		testThemeName = tmpTheme.Name;
		testSubjectName = tmpTheme.Subject__r.Name;

		if (preCreatedTest.Name == null || preCreatedTest.Name == '') {
			preCreatedTest.Name = 'Test #' + String.valueOf(Math.round(Math.random()*1000));
		}
	}

	public PageReference createTest() {
		List<Test__c> checkEqualTestList = [
			SELECT Name
			FROM Test__c
			WHERE Name = :preCreatedTest.Name
		];
		List<Subject__c> subjectForTest = [
			SELECT Id
			FROM Subject__c
			WHERE Name = :testSubjectName
			LIMIT 1
		];

		if ((preCreatedTestTheme.Questions_Captured__c <= 0 || preCreatedTestTheme.Questions_Captured__c > themeAvailableQuestions) ||
			checkEqualTestList.size() > 0 || preCreatedTest.Duration__c <= 0 || preCreatedTest.Passing_Threshold__c == null || subjectForTest.isEmpty() ||
			preCreatedTest.Duration__c == null || preCreatedTestTheme.Questions_Captured__c == null ||
			preCreatedTest.Passing_Threshold__c < 0 || preCreatedTest.Passing_Threshold__c > 100) {
			if (preCreatedTestTheme.Questions_Captured__c <= 0) {
				notificMap.addDanger('Number of questions should be more than 0.');
			}
			else if (preCreatedTestTheme.Questions_Captured__c > themeAvailableQuestions) {
				notificMap.addDanger('Number of questions should be less than available: ' + themeAvailableQuestions + '.');
			}
			else if (checkEqualTestList.size() > 0) {
				notificMap.addDanger('Test with name "' + preCreatedTest.Name + '" already exists.');
			}
			else if (preCreatedTest.Duration__c <= 0) {
				notificMap.addDanger('Duration of the test should be more than 0 minutes.');
			}
			else if (subjectForTest.isEmpty()) {
				notificMap.addDanger('Test cannot be created. Please, refresh page.');
			}
			else if (preCreatedTest.Passing_Threshold__c == null) {
				notificMap.addDanger('Please, input passing threshold.');
			}
			else if (preCreatedTest.Passing_Threshold__c < 0) {
				notificMap.addDanger('Threshold shold be equal or greater than 0.');
			}
			else if (preCreatedTest.Passing_Threshold__c > 100) {
				notificMap.addDanger('Threshold shold be equal or less than 100.');
			}
			else if (preCreatedTest.Duration__c == null) {
				notificMap.addDanger('Please, enter duration.');
			}
			else if (preCreatedTestTheme.Questions_Captured__c == null) {
				notificMap.addDanger('Please, enter number of questions.');
			}
		}
		else {
			preCreatedTest.Subject__c = subjectForTest.get(0).Id;
			insert preCreatedTest;

			preCreatedTestTheme.Test__c = preCreatedTest.Id;
			preCreatedTestTheme.Theme__c = tmpTheme.Id;
			insert preCreatedTestTheme;

			notificMap.addSuccess('Test was created. ' + testSubjectName
				+ ', ' + testThemeName
				+ ', ' + preCreatedTestTheme.Questions_Captured__c + ' questions'
				+ ', ' + preCreatedTest.Duration__c + ' minutes.'
			);

			clearThemeStatistic();
			selectAllSubjects();
			preCreatedTest = new Test__c();
			preCreatedTest.Name = 'Test #' + String.valueOf(Math.round(Math.random()*1000));
			preCreatedTestTheme = new TestTheme__c();
		}
		return null;
	}

	public void createThemeStatistic() {
		themeStatistic = [
			SELECT Test__r.Name, Test__r.Duration__c, Questions_Captured__c, Theme__r.Id
			FROM TestTheme__c
			WHERE Theme__c = :ApexPages.currentPage().getParameters().get('statTheme')
		];
	}

	public void clearThemeStatistic() {
		themeStatistic = new List<TestTheme__c>();
	}


	public void resetSearch() {
		tmpSubject = '';
		selectAllSubjects();
	}

	public PageReference goToSubjectList() {
		return new PageReference('/apex/KASubjectQuestionsList?subjectId=' + ApexPages.currentPage().getParameters().get('listParam'));
	}

	public PageReference goToUploadCSV() {
		return new PageReference('/apex/KAImportQuestionsCSV?themeId=' + ApexPages.currentPage().getParameters().get('CSVParam'));
	}

	private void selectAllSubjects() {
		subjects = [
			SELECT Name, Themes_Number__c,
			(
				SELECT Name, Questions_Number__c, Tests_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
			ORDER BY Name ASC
			LIMIT 50000
		];
	}

	public void prepareTestToDelete() {
		deletingTest = [
			SELECT Id, Name, Subject__r.Name
			FROM Test__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('deleteTestId')
		];
	}

	public void deleteTest() {
		tests = [
			SELECT Id
			FROM Test__c
			LIMIT 50000
		];
		for (Integer i = 0; i < tests.size(); i++) {
			if (tests[i].Id == deletingTest.Id) {
				tests.remove(i);
				break;
			}
		}

		notificMap.addInfo(deletingTest.Name + ' was deleted from ' + deletingTest.Subject__r.Name + '.');
		delete deletingTest;

		clearThemeStatistic();
		typeSubject();
		deletingTest = new Test__c(Name = 'Loading...');
	}

	public void prepareTestToUpdate() {
		if (ApexPages.currentPage().getParameters().get('updateTestId') != null && 
			ApexPages.currentPage().getParameters().get('updateTestId') != '') {	

			preCreatedTest = [
				SELECT Subject__r.Name, Name, Difficulty__c, Passing_Threshold__c, Duration__c,
				(
					SELECT Theme__r.Questions_Number__c, Theme__r.Name, Questions_Captured__c
					FROM TestTheme__r
				)
				FROM Test__c
				WHERE Id = :ApexPages.currentPage().getParameters().get('updateTestId')
			];
			
			preCreatedTestTheme = preCreatedTest.TestTheme__r.get(0);

			tmpTheme = [
				SELECT Id, Name, Subject__r.Name, Questions_Number__c,
					(
						SELECT Id
						FROM Questions__r
						WHERE Level__c = :preCreatedTest.Difficulty__c
					)
				FROM Theme__c
				WHERE Id = :preCreatedTest.TestTheme__r.get(0).Theme__r.Id
			];
		}		
		else {
			tmpTheme = [
				SELECT Id, Name, Subject__r.Name, Questions_Number__c,
					(
						SELECT Id
						FROM Questions__r
						WHERE Level__c = :preCreatedTest.Difficulty__c
					)
				FROM Theme__c
				WHERE Id = :tmpTheme.Id
			];
		}	
		
		testSubjectName = preCreatedTest.Subject__r.Name;
		testThemeName = preCreatedTest.TestTheme__r.get(0).Theme__r.Name;
		themeAvailableQuestions = tmpTheme.Questions__r.size();
		updatingTest = preCreatedTest.Name;

	}

	public void updateTest() {
		List<Subject__c> subjectForTest = [
			SELECT Id
			FROM Subject__c
			WHERE Name = :testSubjectName
			LIMIT 1
		];
		List<Test__c> checkEqualTestList = [
			SELECT Name
			FROM Test__c
			WHERE Name = :preCreatedTest.Name
		];
		if ((preCreatedTestTheme.Questions_Captured__c <= 0 || preCreatedTestTheme.Questions_Captured__c > themeAvailableQuestions) ||
			checkEqualTestList.size() > 0 && checkEqualTestList.get(0).Name != updatingTest || preCreatedTest.Duration__c <= 0 || preCreatedTest.Passing_Threshold__c == null ||
			preCreatedTest.Duration__c == null || preCreatedTestTheme.Questions_Captured__c == null ||
			preCreatedTest.Passing_Threshold__c < 0 || preCreatedTest.Passing_Threshold__c > 100) {
			if (preCreatedTestTheme.Questions_Captured__c <= 0) {
				notificMap.addDanger('Number of questions should be more than 0.');
			}
			else if (preCreatedTestTheme.Questions_Captured__c > themeAvailableQuestions) {
				notificMap.addDanger('Number of questions should be less than available: ' + themeAvailableQuestions + '.');
			}
			else if (checkEqualTestList.size() > 0 && checkEqualTestList.get(0).Name != updatingTest) {
				notificMap.addDanger('Test with name "' + preCreatedTest.Name + '" already exists.');
			}
			else if (preCreatedTest.Duration__c <= 0) {
				notificMap.addDanger('Duration of the test should be more than 0 minutes.');
			}
			else if (preCreatedTest.Passing_Threshold__c == null) {
				notificMap.addDanger('Please, input passing threshold.');
			}
			else if (preCreatedTest.Passing_Threshold__c < 0) {
				notificMap.addDanger('Threshold shold be equal or greater than 0.');
			}
			else if (preCreatedTest.Passing_Threshold__c > 100) {
				notificMap.addDanger('Threshold shold be equal or less than 100.');
			}
			else if (preCreatedTest.Duration__c == null) {
				notificMap.addDanger('Please, enter duration.');
			}
			else if (preCreatedTestTheme.Questions_Captured__c == null) {
				notificMap.addDanger('Please, enter number of questions.');
			}
		}
		else {
			preCreatedTest.Subject__c = subjectForTest.get(0).Id;
			update preCreatedTest;
			
			update preCreatedTestTheme;

			notificMap.addSuccess('Test was updated. ' + testSubjectName
				+ ', ' + testThemeName
				+ ', ' + preCreatedTestTheme.Questions_Captured__c + ' questions'
				+ ', ' + preCreatedTest.Duration__c + ' minutes.'
			);

			clearThemeStatistic();
			preCreatedTest = new Test__c();
			preCreatedTestTheme = new TestTheme__c();
		}
	}

}