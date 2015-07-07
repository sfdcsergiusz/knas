public with sharing class KACommonTestsController {

	public List<Subject__c> subjects { get; set; }

	public String tmpSubject { get; set; }
	public String testThemeName { get; set; }
	public Integer themeAvailableQuestions { get; set; }
	public String testSubjectName { get; set; }

	public TestTheme__c preCreatedTestTheme { get; set; }
	public Test__c preCreatedTest { get; set; }
	public List<TestTheme__c> themeStatistic { get; set; }

	private Theme__c tmpTheme { private get; private set; }

	public KACommonTestsController() {
		tmpSubject = '';
		preCreatedTestTheme = new TestTheme__c();
		preCreatedTest = new Test__c();
		themeStatistic = new List<TestTheme__c>();

		subjects = [
			SELECT Name, Themes_Number__c,
			(
				SELECT Name, Questions_Number__c, Tests_Number__c
				FROM Themes__r
				ORDER BY Name ASC
				LIMIT 50000
			)
			FROM Subject__c
			ORDER BY Name ASC
			LIMIT 50000
		];

	}

	public PageReference goHome() {
		return new PageReference('/apex/KAAdminUserHome');
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
			ORDER BY Name ASC
			LIMIT 50000
		];
	}

	public void preCreateTest() {
		tmpTheme = [
			SELECT Id, Name, Subject__r.Name, Questions_Number__c
			FROM Theme__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('themeId')
		];
		themeAvailableQuestions = (Integer) tmpTheme.Questions_Number__c;
		testThemeName = tmpTheme.Name;
		testSubjectName = tmpTheme.Subject__r.Name;
		preCreatedTest.Name = 'Test #' + String.valueOf(Math.round(Math.random()*1000));
	}

	public PageReference createTest() {
		List<Subject__c> subjectForTest = [
			SELECT Id
			FROM Subject__c
			WHERE Name = :testSubjectName
			LIMIT 1
		];
		if ( ! subjectForTest.isEmpty()) {
			preCreatedTest.Subject__c = subjectForTest.get(0).Id;
		}
		insert preCreatedTest;

		preCreatedTestTheme.Test__c = preCreatedTest.Id;
		preCreatedTestTheme.Theme__c = tmpTheme.Id;
		KAUniqueThemeHandler.enablesTrigger = false;
		insert preCreatedTestTheme;
		KAUniqueThemeHandler.enablesTrigger = true;

		PageReference updatingPage = new PageReference('/apex/KACommonTests');
		updatingPage.setRedirect(true);
		return updatingPage;
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

	public void deleteTest() {
		Test__c deletingTest = [
			SELECT Id
			FROM Test__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('testToDelete')
		];
		delete deletingTest;

		clearThemeStatistic();

		subjects = [
			SELECT Name,
			(
				SELECT Name, Questions_Number__c, Tests_Number__c
				FROM Themes__r
				ORDER BY Name ASC
				LIMIT 50000
			)
			FROM Subject__c
			ORDER BY Name ASC
			LIMIT 50000
		];
	}

	public PageReference goToThemeList() {
		return new PageReference('/apex/KASubjectQuestionsList?themeName=' + ApexPages.currentPage().getParameters().get('listParam'));
	}

	public PageReference goToSubjectList() {
		return new PageReference('/apex/KASubjectQuestionsList?subjectName=' + ApexPages.currentPage().getParameters().get('listParam'));
	}

	public PageReference goToUploadCSV() {
		return new PageReference('/apex/KAImportQuestionsCSV?themeId=' + ApexPages.currentPage().getParameters().get('CSVParam'));
	}

}