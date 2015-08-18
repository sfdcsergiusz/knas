public with sharing class KASubjectQuestionsListController {

	public static JSON tmpJSON { get; set; }

	public List<Subject__c> subjects { get; set; }
	public List<Theme__c> themes { get; set; }

	public String tmpSubject { get; set; }
	public String tmpTheme { get; set; }
	public String topicDropboxId { get; set; }

	public Id chosenSubject { get; set; }
	public Id chosenTheme { get; set; }

	public List<Question__c> questions { get; set; }
	public String subjectId { get; set; }
	public String themeId { get; set; }
	public String subjectName { get; set; }
	public String themeName { get; set; }

	public Question__c deletingQuestion { get; set; }
	public Question__c preCreatedQuestion { get; set; }
	public Question__c preCreatedQuestionDropbox { get; set; }
	public Question__c preUpdatedQuestionDropbox { get; set; }
	public Question__c preDeletedQuestionDropbox { get; set; }
	public List<Answer__c> preCreatedAnswers { get; set; }

	public KANotificationMapWrapper notificMap { get; private set; }
	public String backLink {
		get {
			return 'apex/' + KAPageConstants.packagePrefix + 'KACommonSubjects';
		}
		private set;
	}

	private PageReference currentPage;

	private void init() {
		notificMap = new KANotificationMapWrapper();
		subjects = new List<Subject__c>();
		themes = new List<Theme__c>();
		questions = new List<Question__c>();
		deletingQuestion = new Question__c(Statement__c = 'Loading...');
		preCreatedQuestion = new Question__c();
		preCreatedAnswers = new List<Answer__c>();
		for (Integer i = 0; i < 3; i++) {
			preCreatedAnswers.add(new Answer__c());
		}

		currentPage = ApexPages.currentPage();
		themeId = currentPage.getParameters().get('themeId');
		subjectId = currentPage.getParameters().get('subjectId');

		if (themeId != null) {
			themeName = [
				SELECT Name
				FROM Theme__c
				WHERE Id = :themeId
			].get(0).Name;
			subjectName = [
				SELECT Name, Subject__r.Name
				FROM Theme__c
				WHERE Id = :themeId
			].get(0).Subject__r.Name;
		}
		if (subjectId != null) {
			subjectName = [
				SELECT Name
				FROM Subject__c
				WHERE Id = :subjectId
			].get(0).Name;
		}

		refreshQuestions(false);
	}

	public KASubjectQuestionsListController() {
		init();
	}

	public void refreshQuestions(Boolean ifDelete) {
		questions.clear();
		if (themeId != null) {
			questions = KADropBoxUtil.getQuestionsByTopic(themeId);

			if (questions.size() > 0) {
				subjectId = questions[0].Theme__r.Subject__r.Id;
			}
			else {
				subjectId = [
					SELECT Subject__r.Id
					FROM Theme__c
					WHERE Id = :themeId
					LIMIT 1
					].Subject__r.Id;
			}

			tmpSubject = subjectName;
			tmpTheme = themeName;
		}
		else if (subjectId != null) {
			List<Subject__c> currSubject = [
				SELECT Name, (
					SELECT Name
					FROM Themes__r
				)
				FROM Subject__c
				WHERE Id = :subjectId
			];
			if (currSubject.size() > 0) {
				for (Theme__c varTheme : currSubject.get(0).Themes__r) {
					questions.addAll(KADropBoxUtil.getQuestionsByTopic(varTheme.Id));
				}
				tmpSubject = subjectName;
			}
			else {
				notificMap.addDanger('Something goes wrong...');
			}
		}

		if (ifDelete) {
			List<Question__c> quests = [
				SELECT Id
				FROM Question__c
			];
			delete quests;
		}
	}

	public void refreshQuestionsManually() {
		refreshQuestions(true);
	}

	public void typeSubject() {
		chosenSubject = null;
		String searchSubject = '%' + tmpSubject + '%';
		subjects = [
			SELECT Name
			FROM Subject__c
			WHERE Name LIKE :searchSubject
		];
	}

	public void typeTheme() {
		chosenTheme = null;
		String searchSubject = '%' + tmpSubject + '%';
		String searchTheme = '%' + tmpTheme + '%';
		themes = [
			SELECT Name
			FROM Theme__c
			WHERE Name LIKE :searchTheme AND Subject__r.Name LIKE :searchSubject
		];
	}

	public void chooseSubject() {
		chosenSubject = (Id) ApexPages.currentPage().getParameters().get('chosenSubject');
		Subject__c varSubject = [
			SELECT Name
			FROM Subject__c
			WHERE Id = :chosenSubject
			LIMIT 1
		];
		tmpSubject = varSubject.Name;
		tmpTheme = '';
		subjects.clear();
	}

	public void chooseTheme() {
		chosenTheme = (Id) ApexPages.currentPage().getParameters().get('chosenTheme');
		Theme__c varTheme = [
			SELECT Name, Subject__r.Name
			FROM Theme__c
			WHERE Id = :chosenTheme
			LIMIT 1
		];
		tmpTheme = varTheme.Name;
		tmpSubject = varTheme.Subject__r.Name;
		themes.clear();
	}

	public void	addAnswer() {
		preCreatedAnswers.add(new Answer__c());
	}

	public void reduceAnswer() {
		preCreatedAnswers.remove(Integer.valueOf(ApexPages.currentPage().getParameters().get('answerIndex')));
	}

	public PageReference createQuestion() {
		List<Theme__c> checkThemeExistenceList = [
			SELECT Name
			FROM Theme__c
			WHERE Name LIKE :tmpTheme AND Subject__r.Name LIKE :tmpSubject
		];
		Boolean hasAnswersEmpties = false;
		Boolean hasAnswersRights = false;
		for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
			if (preCreatedAnswers[i].Variant__c == null || preCreatedAnswers[i].Variant__c == '') {
				hasAnswersEmpties = true;
				break;
			}
			if (preCreatedAnswers[i].Right__c == true) {
				hasAnswersRights = true;
			}
		}

		if (preCreatedQuestion == null || checkThemeExistenceList.size() == 0 ||
				preCreatedQuestion.Statement__c == '' || hasAnswersEmpties ||
				( ! hasAnswersRights) || preCreatedQuestion.Level__c == null) {
			if (preCreatedQuestion == null) {
				notificMap.addInfo('Please, wait a second for sending creation request.');
			}
			else if (checkThemeExistenceList.size() == 0) {
				notificMap.addDanger('Please, check question\'s subject and topic');
			}
			else if (preCreatedQuestion.Statement__c == '' || preCreatedQuestion.Statement__c == null) {
				notificMap.addDanger('Please, enter the statement.');
			}
			else if (hasAnswersEmpties) {
				notificMap.addDanger('Please, fill all the answers you requested.');
			}
			else if ( ! hasAnswersRights) {
				notificMap.addDanger('Please, add at least one right variant');
			}
			else if (preCreatedQuestion.Level__c == null) {
				notificMap.addDanger('Please, choose the difficulty level.');
			}
		}
		else {
			preCreatedQuestion.Theme__c = checkThemeExistenceList.get(0).Id;
			topicDropboxId = checkThemeExistenceList.get(0).Id;
			insert preCreatedQuestion;

			preCreatedQuestionDropbox = preCreatedQuestion;
			List<Answer__c> preInsertedAnswers = new List<Answer__c>();
			for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
					preCreatedAnswers[i].Question__c = preCreatedQuestion.Id;
					preInsertedAnswers.add(preCreatedAnswers[i]);
			}
			insert preInsertedAnswers;

			notificMap.addSuccess('Question was created.');

			preCreatedQuestion = null;
			preCreatedAnswers.clear();
			for (Integer i = 0; i < 3; i++) {
				preCreatedAnswers.add(new Answer__c());
			}
		}
		return null;
	}

	public void createQuestionOnDropbox() {
		if (preCreatedQuestion == null) {
			preCreatedQuestion = new Question__c();

			List<Question__c> dropBoxQuestion = [
				SELECT Name, Level__c, Statement__c, CreatedDate,
					Theme__r.Name, Theme__r.Subject__r.Name, Theme__r.Subject__r.Id,
				(
					SELECT Variant__c, Right__c
					FROM Answers__r
				)
				FROM Question__c
				WHERE Id = :preCreatedQuestionDropbox.Id
				LIMIT 1
			];
			if (dropBoxQuestion.size() > 0) {
				KADropBoxUtil.addQuestionToTopic(topicDropboxId, dropBoxQuestion.get(0));
				refreshQuestions(true);
			}
		}
	}

	public void prepareQuestionToDelete() {
		for (Question__c varQuest : questions) {
			if (String.valueOf(varQuest.Id) == ApexPages.currentPage().getParameters().get('deleteQuestionId')) {
				deletingQuestion = varQuest;
				break;
			}
		}
	}

	public void deleteQuestion() {
		topicDropboxId = deletingQuestion.Theme__c;
		for (Integer i = 0; i < questions.size(); i++) {
			if (questions[i].Id == deletingQuestion.Id) {
				questions.remove(i);
				break;
			}
		}

		notificMap.addInfo('Question was successfully deleted.');
		preDeletedQuestionDropbox = deletingQuestion;
		deletingQuestion = new Question__c(Statement__c = 'Loading...');
	}

	public void deleteQuestionOnDropbox() {
		KADropBoxUtil.deleteQuestionFromTopic(topicDropboxId, preDeletedQuestionDropbox);
	}

	public void prepareQuestionToUpdate() {
		for (Question__c varQuest : questions) {
			if (String.valueOf(varQuest.Id) == ApexPages.currentPage().getParameters().get('updateQuestionId')) {
				preCreatedQuestion = varQuest;
				break;
			}
		}
		preCreatedAnswers = preCreatedQuestion.Answers__r;
		tmpSubject = preCreatedQuestion.Theme__r.Subject__r.Name;
		tmpTheme = preCreatedQuestion.Theme__r.Name;
		chosenSubject = preCreatedQuestion.Theme__r.Subject__r.Id;
		chosenTheme = preCreatedQuestion.Theme__r.Id;
	}

	public void updateQuestion() {
		List<Theme__c> checkThemeExistenceList = [
			SELECT Name
			FROM Theme__c
			WHERE Name LIKE :tmpTheme AND Subject__r.Name LIKE :tmpSubject
		];
		Boolean hasAnswersEmpties = false;
		Boolean hasAnswersRights = false;

		for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
			if (preCreatedAnswers[i].Variant__c == null || preCreatedAnswers[i].Variant__c == '') {
				hasAnswersEmpties = true;
				break;
			}
			if (preCreatedAnswers[i].Right__c == true) {
				hasAnswersRights = true;
			}
		}

		if (checkThemeExistenceList.size() == 0 || preCreatedQuestion.Statement__c == '' || hasAnswersEmpties ||
			( ! hasAnswersRights) || preCreatedQuestion.Level__c == null) {
			if (checkThemeExistenceList.size() == 0) {
				notificMap.addDanger('Please, check question\'s subject and topic');
			}
			else if (preCreatedQuestion.Statement__c == '' || preCreatedQuestion.Statement__c == null) {
				notificMap.addDanger('Please, enter the statement.');
			}
			else if (hasAnswersEmpties) {
				notificMap.addDanger('Please, fill all the answers you requested.');
			}
			else if ( ! hasAnswersRights) {
				notificMap.addDanger('Please, add at least one right variant');
			}
			else if (preCreatedQuestion.Level__c == null) {
				notificMap.addDanger('Please, choose the difficulty level.');
			}
		}
		else {
			preCreatedQuestion.Theme__c = checkThemeExistenceList.get(0).Id;
			topicDropboxId = checkThemeExistenceList.get(0).Id;

			preUpdatedQuestionDropbox = preCreatedQuestion;
			List<Answer__c> preInsertedAnswers = new List<Answer__c>();
			for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
					preCreatedAnswers[i].Question__c = preCreatedQuestion.Id;
					preInsertedAnswers.add(preCreatedAnswers[i]);
			}

			notificMap.addSuccess('Question was updated.');

			preCreatedQuestion = new Question__c();
			preCreatedAnswers.clear();
			for (Integer i = 0; i < 3; i++) {
				preCreatedAnswers.add(new Answer__c());
			}

			tmpSubject = null;
			tmpTheme = null;
		}
	}

	public void updateQuestionOnDropbox() {
		KADropBoxUtil.updateQuestionOnTopic(topicDropboxId, preUpdatedQuestionDropbox);
		refreshQuestions(true);
	}

}