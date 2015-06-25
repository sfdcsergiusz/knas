public with sharing class KACommonSubjectsController {

	public List<Subject__c> subjects { get; set; }

	public String tmpSubject { get; set; }
	public String tmpTheme { get; set; }

	public KACommonSubjectsController() {
		tmpSubject = '';

		subjects = [
			SELECT Name,
			(
				SELECT Name, Questions_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
			LIMIT 50000
		];
	}

	public PageReference goHome() {
		return new PageReference('/apex/KAAdminUserHome');
	}

	public void typeSubject() {
		String searchSubject = '%' + tmpSubject + '%';
		subjects = [
			SELECT Name,
			(
				SELECT Name, Questions_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
			WHERE Name LIKE :searchSubject
			LIMIT 50000
		];
	}

	public void createSubject() {
		if (tmpSubject != null && tmpSubject != '') {
			Subject__c preCreatedSubject = new Subject__c(Name = tmpSubject);
			insert preCreatedSubject;

			tmpSubject = '';

			subjects = [
				SELECT Name,
				(
					SELECT Name, Questions_Number__c
					FROM Themes__r
					LIMIT 50000
				)
				FROM Subject__c
				LIMIT 50000
			];
		}
	}

	public void createTheme() {
		if (tmpTheme != null && tmpTheme != '') {
			Subject__c tmpSubjectObject = [
				SELECT Name
				FROM Subject__c
				WHERE Name = :ApexPages.currentPage().getParameters().get('subjectName')
				LIMIT 1
			];
			Theme__c preCreatedTheme = new Theme__c(Name = tmpTheme, Subject__c = tmpSubjectObject.Id);
			insert preCreatedTheme;

			tmpTheme = '';

			subjects = [
				SELECT Name,
				(
					SELECT Name, Questions_Number__c
					FROM Themes__r
					LIMIT 50000
				)
				FROM Subject__c
				LIMIT 50000
			];
		}
	}

	public void deleteSubject() {
		Subject__c tmpSubjectObject = [
			SELECT Id
			FROM Subject__c
			WHERE Name = :ApexPages.currentPage().getParameters().get('deleteParam')
			LIMIT 1
		];
		delete tmpSubjectObject;

		subjects = [
			SELECT Name,
			(
				SELECT Name, Questions_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
			LIMIT 50000
		];
	}

	public void deleteTheme() {
		Theme__c tmpThemeObject = [
			SELECT Id
			FROM Theme__c
			WHERE Name = :ApexPages.currentPage().getParameters().get('deleteParam')
			LIMIT 1
		];
		delete tmpThemeObject;

		subjects = [
			SELECT Name,
			(
				SELECT Name, Questions_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
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