public with sharing class KACommonSubjectsController {

	public List<Subject__c> subjects { get; set; }
	public List<Theme__c> topics { get; set; }

	public String tmpSubject { get; set; }
	public String tmpTheme { get; set; }
	public String topicDropboxId { get; set; }

	public Subject__c deletingSubject { get; set; }
	public Subject__c updatingSubject { get; set; }
	public Theme__c deletingTopic { get; set; }
	public Theme__c updatingTopic { get; set; }

	public KANotificationMapWrapper notificMap { get; private set; }
	public String backLink {
		get {
			return 'apex/' + KAPageConstants.packagePrefix + 'KAAdminUserHome';
		}
		private set;
	}

	public void onLoad() {
		List<Theme__c> updTopics = [
			SELECT Id
			FROM Theme__c
		];
		for (Integer i = 0; i < updTopics.size(); i++) {
			updTopics[i].Questions_Number__c = KADropBoxUtil.getQuestionsByTopic(updTopics[i].Id).size();
		}
		update updTopics;

		selectAllSubjects();
	}

	private void init() {
		tmpSubject = '';
		notificMap = new KANotificationMapWrapper();
		deletingSubject = new Subject__c(Name = Label.LoadingDtDtDt);
		deletingTopic = new Theme__c(Name = Label.LoadingDtDtDt);
		updatingSubject = new Subject__c();
		updatingTopic = new Theme__c();
	}

	public KACommonSubjectsController() {
		init();
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
				notificMap.addSuccess(Label.SubjectSpc + '"' + preCreatedSubject.Name + '"' + Label.Spc_Was_Created_Dt);
				insert preCreatedSubject;

				typeSubject();
			}
			else {
				notificMap.addDanger(Label.Msg_Subject_Exists);
			}
		}
		else {
			notificMap.addDanger(Label.Msg_Empty_Subject);
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
				notificMap.addSuccess(Label.Topic_Spc + '"' + preCreatedTheme.Name + '"' + Label.Spc_Was_Created_Dt);
				insert preCreatedTheme;

				topicDropboxId = preCreatedTheme.Id;
				tmpTheme = '';
				if (tmpSubject != '') {
					typeSubject();
				}
				else {
					selectAllSubjects();
				}
			}
			else {
				notificMap.addDanger(Label.Msg_Topic_Exists);
			}
		}
		else {
			notificMap.addDanger(Label.Msg_Empty_Topic);
		}
	}

	public void createFileOnDropbox() {
		KADropBoxUtil.createTopic(topicDropboxId);
	}

	public void resetSearch() {
		tmpSubject = '';
		selectAllSubjects();
		notificMap.addInfo(Label.Msg_Reset_Search);
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

	public void prepareSubjectToDelete() {
		deletingSubject = [
			SELECT Id, Name
			FROM Subject__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('deleteSubjectId')
			LIMIT 1
		];
	}

	public void deleteSubject() {
		for (Integer i = 0; i < subjects.size(); i++) {
			if (subjects[i].Id == deletingSubject.Id) {
				subjects.remove(i);
				break;
			}
		}

		notificMap.addSuccess(Label.Msg_Subject_Deleted);
		if (deletingSubject.Id != null) {
			delete deletingSubject;
		}

		if (tmpSubject != '') {
			typeSubject();
		}
		else {
			selectAllSubjects();
		}
		deletingSubject = new Subject__c(Name = Label.LoadingDtDtDt);

		List<Test__c> checkingTests = [
			SELECT Id, (
				SELECT Id
				FROM TestThemes__r
			)
			FROM Test__c
		];
		for (Test__c checkingTest : checkingTests) {
			if (checkingTest.TestThemes__r.size() == 0) {
				delete checkingTest;
			}
		}
	}

	public void prepareTopicToDelete() {
		deletingTopic = [
			SELECT Id, Name
			FROM Theme__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('deleteTopicId')
			LIMIT 1
		];
	}

	public void deleteTopic() {
		topics = [
			SELECT Id
			FROM Theme__c
			LIMIT 50000
		];
		for (Integer i = 0; i < topics.size(); i++) {
			if (topics[i].Id == deletingTopic.Id) {
				topics.remove(i);
				break;
			}
		}

		KADropBoxUtil.deleteTopic(deletingTopic.Id);

		notificMap.addSuccess(Label.Msg_Topic_Deleted);
		delete deletingTopic;

		if (tmpSubject != '') {
			typeSubject();
		}
		else {
			selectAllSubjects();
		}
		deletingTopic = new Theme__c(Name = Label.LoadingDtDtDt);

		List<Test__c> checkingTests = [
			SELECT Id, (
				SELECT Id
				FROM TestThemes__r
			)
			FROM Test__c
		];
		for (Test__c checkingTest : checkingTests) {
			if (checkingTest.TestThemes__r.size() == 0) {
				delete checkingTest;
			}
		}
	}

	public void prepareSubjectToUpdate() {
		updatingSubject = [
			SELECT Id, Name
			FROM Subject__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('updateSubjectId')
			LIMIT 1
		];
		String filterValue = '';
		if ( ! String.isEmpty(tmpSubject)) {
			filterValue = tmpSubject;
		}
		tmpSubject = updatingSubject.Name;
		updatingSubject.Name = filterValue + 'filtertrue';
	}

	public void updateSubject() {
		if (tmpSubject != null && tmpSubject != '') {
			List<Subject__c> checkSubjectsList = [
				SELECT Id
				FROM Subject__c
				WHERE Name = :tmpSubject
			];
			if (checkSubjectsList.size() == 0) {
				String filterValue = '';
				if (updatingSubject.Name.contains('filtertrue') && updatingSubject.Name != 'filtertrue') {
					filterValue = updatingSubject.Name.split('filtertrue')[0];
				}
				updatingSubject.Name = tmpSubject;
				notificMap.addSuccess(Label.SubjectSpc + '"' + updatingSubject.Name + '"' + Label.Spc_Was_Updated_Dt);
				update updatingSubject;

				updatingSubject = new Subject__c();
				if ( ! String.isEmpty(filterValue)) {
					tmpSubject = filterValue;
					typeSubject();
				}
				else {
					selectAllSubjects();
				}
				tmpSubject = '';
			}
			else {
				notificMap.addDanger(Label.Msg_Subject_Exists);
			}
		}
		else {
			notificMap.addDanger(Label.Msg_Empty_Subject);
		}
	}

	public void prepareTopicToUpdate() {
		updatingTopic = [
			SELECT Id, Name, Subject__r.Name
			FROM Theme__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('updateTopicId')
			LIMIT 1
		];
		tmpTheme = updatingTopic.Name;
	}

	public void updateTopic() {
		if (tmpTheme != null && tmpTheme != '') {
			Subject__c tmpSubjectObject = [
				SELECT Name, Themes_Number__c,
					(
						SELECT Name
						FROM Themes__r
						WHERE Name = :tmpTheme
					)
				FROM Subject__c
				WHERE Name = :updatingTopic.Subject__r.Name
				LIMIT 1
			];
			if (tmpSubjectObject.Themes__r.size() == 0) {
				updatingTopic.Name = tmpTheme;
				notificMap.addSuccess('Topic "' + updatingTopic.Name + '" was updated.');
				update updatingTopic;

				updatingTopic = new Theme__c();
				tmpTheme = '';
				if (tmpSubject != '') {
					typeSubject();
				}
				else {
					selectAllSubjects();
				}
			}
			else {
				notificMap.addDanger(Label.Msg_Topic_Exists);
			}
		}
		else {
			notificMap.addDanger(Label.Msg_Empty_Topic);
		}
	}

}