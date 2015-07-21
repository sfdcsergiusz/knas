public with sharing class KACommonSubjectsController {

	public List<Subject__c> subjects { get; set; }

	public String tmpSubject { get; set; }
	public String tmpTheme { get; set; }

	public KANotificationMapWrapper notificMap { get; private set; }

	public KACommonSubjectsController() {
		tmpSubject = '';
		notificMap = new KANotificationMapWrapper();

		selectAllSubjects();
	}

	public void typeSubject() {
		String searchSubject = '%' + tmpSubject + '%';
		subjects = [
			SELECT Name, Themes_Number__c,
			(
				SELECT Name, Questions_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
			WHERE Name LIKE :searchSubject
			ORDER BY Name ASC
			LIMIT 50000
		];
	}

	public void createSubject() {
		if (tmpSubject != null && tmpSubject != '') {
			List<Subject__c> checkSubjectsList = [
				SELECT Id
				FROM Subject__c
				WHERE Name = :tmpSubject
			];
			if (checkSubjectsList.size() == 0) {
				Subject__c preCreatedSubject = new Subject__c(Name = tmpSubject);
				notificMap.addSuccess('Subject "' + preCreatedSubject.Name + '" was created.');
				insert preCreatedSubject;

				typeSubject();
			}
			else {
				notificMap.addDanger('Subject already exists.');
			}
		}
		else {
			notificMap.addDanger('Subject name is empty.');
		}
	}

	public void createTheme() {
		if (tmpTheme != null && tmpTheme != '') {
			Subject__c tmpSubjectObject = [
				SELECT Name, Themes_Number__c,
					(
						SELECT Name
						FROM Themes__r
						WHERE Name = :tmpTheme
					)
				FROM Subject__c
				WHERE Name = :ApexPages.currentPage().getParameters().get('subjectName')
				LIMIT 1
			];
			if (tmpSubjectObject.Themes__r.size() == 0) {
				Theme__c preCreatedTheme = new Theme__c(Name = tmpTheme, Subject__c = tmpSubjectObject.Id);
				notificMap.addSuccess('Topic "' + preCreatedTheme.Name + '" was created.');
				insert preCreatedTheme;

				tmpTheme = '';
				if (tmpSubject != '') {
					typeSubject();
				}
				else {
					selectAllSubjects();
				}
			}
			else {
				notificMap.addDanger('Topic already exists.');
			}
		}
		else {
			notificMap.addDanger('Topic name is empty.');
		}
	}

	public void deleteSubject() {
		Subject__c tmpSubjectObject = [
			SELECT Id, Name
			FROM Subject__c
			WHERE Name = :ApexPages.currentPage().getParameters().get('deleteParam')
			LIMIT 1
		];
		notificMap.addInfo('Subject "' + tmpSubjectObject.Name + '" was deleted.');
		delete tmpSubjectObject;

		if (tmpSubject != '') {
			typeSubject();
		}
		else {
			selectAllSubjects();
		}
	}

	public void deleteTheme() {
		Theme__c tmpThemeObject = [
			SELECT Id, Name
			FROM Theme__c
			WHERE Name = :ApexPages.currentPage().getParameters().get('deleteParam')
			LIMIT 1
		];
		notificMap.addSuccess('Topic "' + tmpThemeObject.Name + '" was deleted.');
		delete tmpThemeObject;

		if (tmpSubject != '') {
			typeSubject();
		}
		else {
			selectAllSubjects();
		}
	}

	public void resetSearch() {
		tmpSubject = '';
		selectAllSubjects();
		notificMap.addInfo('All subjects are selected.');
	}

	public PageReference goToThemeList() {
		return new PageReference('/apex/KASubjectQuestionsList?themeId=' + ApexPages.currentPage().getParameters().get('listParam'));
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
				SELECT Name, Questions_Number__c
				FROM Themes__r
				LIMIT 50000
			)
			FROM Subject__c
			ORDER BY Name ASC
			LIMIT 50000
		];
	}

}