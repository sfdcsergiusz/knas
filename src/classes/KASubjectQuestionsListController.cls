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

	public KASubjectQuestionsListController() {
		notificMap = new KANotificationMapWrapper();
		subjects = new List<Subject__c>();
		themes = new List<Theme__c>();
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

		refreshQuestions();
	}

	public void refreshQuestions() {
		if (themeId != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate, Theme__r.Name, Theme__r.Subject__r.Name, Theme__r.Subject__r.Id
				FROM Question__c
				WHERE Theme__r.Id = :themeId
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
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
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate,  Theme__r.Name, Theme__r.Subject__r.Name, Theme__r.Subject__r.Id
				FROM Question__c
				WHERE Theme__r.Subject__r.Id = :subjectId
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			tmpSubject = subjectName;
		}
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

		if (checkThemeExistenceList.size() == 0 || preCreatedQuestion.Statement__c == '' || hasAnswersEmpties || ( ! hasAnswersRights) ||
			preCreatedQuestion.Level__c == null) {
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
			insert preCreatedQuestion;

			preCreatedQuestionDropbox = preCreatedQuestion;
			List<Answer__c> preInsertedAnswers = new List<Answer__c>();
			for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
					preCreatedAnswers[i].Question__c = preCreatedQuestion.Id;
					preInsertedAnswers.add(preCreatedAnswers[i]);
			}
			insert preInsertedAnswers;

			notificMap.addSuccess('Question was created.');

			preCreatedQuestion = new Question__c();
			preCreatedAnswers.clear();
			for (Integer i = 0; i < 3; i++) {
				preCreatedAnswers.add(new Answer__c());
			}

			refreshQuestions();
		}
		return null;
	}

	public void createQuestionOnDropbox() {
		Question__c dropBoxQuestion = [
			SELECT Statement__c, Level__c, 
			(
				SELECT Variant__c, Right__c 
				FROM Answers__r
			)
			FROM Question__c
			WHERE Id = :preCreatedQuestionDropbox.Id
			LIMIT 1
		];
		HttpRequest getReq = new HttpRequest();
		getReq.setEndpoint('https://api-content.dropbox.com/1/files/auto/' + topicDropboxId);
		getReq.setMethod('GET');
		getReq.setHeader('Authorization', 'Bearer NAVL3W_WUewAAAAAAAAAHJ3pnbVRoHy1oak2WOoF4GoBZ0V3sJ9Mufq_d38DK4uk');
		getReq.setHeader('Content-Type', 'application/json');
		HTTPResponse getRes = new Http().send(getReq);
		String getResBody = getRes.getBody();
		List<Question__c> questionsDeserialized = new List<Question__c>();
		try {
			questionsDeserialized = (List<Question__c>) JSON.deserialize(getResBody, List<Question__c>.class);
		}
		catch (Exception exc) {
    	  	
    	}
		questionsDeserialized.add(dropBoxQuestion);

		String questionsJSON = JSON.serializePretty(questionsDeserialized);

		HttpRequest postReq = new HttpRequest();
		postReq.setEndpoint('https://api-content.dropbox.com/1/files_put/auto/' + topicDropboxId);
		postReq.setMethod('POST');
		postReq.setHeader('Authorization', 'Bearer NAVL3W_WUewAAAAAAAAAHJ3pnbVRoHy1oak2WOoF4GoBZ0V3sJ9Mufq_d38DK4uk');
		postReq.setHeader('Content-Type', 'application/json');
		postReq.setBody (questionsJSON);
		HTTPResponse postRes = new Http().send(postReq);

	}

	public void prepareQuestionToDelete() {
		deletingQuestion = [
			SELECT Statement__c, Theme__c, Level__c,
			(
				SELECT Variant__c, Right__c 
				FROM Answers__r
			)
			FROM Question__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('deleteQuestionId')
		];
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
		delete deletingQuestion;

		deletingQuestion = new Question__c(Statement__c = 'Loading...');	
	}

	public void deleteQuestionOnDropbox() {
		HttpRequest getReq = new HttpRequest();
		getReq.setEndpoint('https://api-content.dropbox.com/1/files/auto/' + topicDropboxId);
		getReq.setMethod('GET');
		getReq.setHeader('Authorization', 'Bearer NAVL3W_WUewAAAAAAAAAHJ3pnbVRoHy1oak2WOoF4GoBZ0V3sJ9Mufq_d38DK4uk');
		getReq.setHeader('Content-Type', 'application/json');
		HTTPResponse getRes = new Http().send(getReq);
		String getResBody = getRes.getBody();
		List<Question__c> questionsDeserialized = new List<Question__c>();
		try {
			questionsDeserialized = (List<Question__c>) JSON.deserialize(getResBody, List<Question__c>.class);
		}
		catch (Exception exc) {
    	  	
    	}

    	for (Integer i = 0; i < questionsDeserialized.size(); i++) {
    		if (questionsDeserialized[i].Id == preDeletedQuestionDropbox.Id) {
    			questionsDeserialized.remove(i);
    			break;
    		}
    	}

		String questionsJSON = JSON.serializePretty(questionsDeserialized);

		HttpRequest postReq = new HttpRequest();
		postReq.setEndpoint('https://api-content.dropbox.com/1/files_put/auto/' + topicDropboxId);
		postReq.setMethod('POST');
		postReq.setHeader('Authorization', 'Bearer NAVL3W_WUewAAAAAAAAAHJ3pnbVRoHy1oak2WOoF4GoBZ0V3sJ9Mufq_d38DK4uk');
		postReq.setHeader('Content-Type', 'application/json');
		postReq.setBody (questionsJSON);
		HTTPResponse postRes = new Http().send(postReq);

	}

	public void prepareQuestionToUpdate() {
		preCreatedQuestion = [
			SELECT Statement__c, Theme__r.Name, Theme__r.Subject__r.Name, Level__c,
				(
					SELECT Variant__c, Right__c 
					FROM Answers__r
				)
			FROM Question__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('updateQuestionId')
			LIMIT 1
		];
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

		if (checkThemeExistenceList.size() == 0 || preCreatedQuestion.Statement__c == '' || hasAnswersEmpties || ( ! hasAnswersRights) ||
			preCreatedQuestion.Level__c == null) {
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
			update preCreatedQuestion;

			preUpdatedQuestionDropbox = preCreatedQuestion;
			List<Answer__c> preInsertedAnswers = new List<Answer__c>();
			for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
					preCreatedAnswers[i].Question__c = preCreatedQuestion.Id;
					preInsertedAnswers.add(preCreatedAnswers[i]);
			}
			update preInsertedAnswers;

			notificMap.addSuccess('Question was updated.');

			preCreatedQuestion = new Question__c();
			preCreatedAnswers.clear();
			for (Integer i = 0; i < 3; i++) {
				preCreatedAnswers.add(new Answer__c());
			}

			refreshQuestions();

			preCreatedQuestion = new Question__c();
			preCreatedAnswers = new List<Answer__c>();
			tmpSubject = null;
			tmpTheme = null;
		}
	}

	public void updateQuestionOnDropbox() {
		Question__c dropBoxQuestion = [
			SELECT Statement__c, Level__c, 
			(
				SELECT Variant__c, Right__c 
				FROM Answers__r
			)
			FROM Question__c
			WHERE Id = :preUpdatedQuestionDropbox.Id
			LIMIT 1
		];
		HttpRequest getReq = new HttpRequest();
		getReq.setEndpoint('https://api-content.dropbox.com/1/files/auto/' + topicDropboxId);
		getReq.setMethod('GET');
		getReq.setHeader('Authorization', 'Bearer NAVL3W_WUewAAAAAAAAAHJ3pnbVRoHy1oak2WOoF4GoBZ0V3sJ9Mufq_d38DK4uk');
		getReq.setHeader('Content-Type', 'application/json');
		HTTPResponse getRes = new Http().send(getReq);
		String getResBody = getRes.getBody();
		List<Question__c> questionsDeserialized = new List<Question__c>();
		try {
			questionsDeserialized = (List<Question__c>) JSON.deserialize(getResBody, List<Question__c>.class);
		}
		catch (Exception exc) {
    	  	
    	}

    	for (Integer i = 0; i < questionsDeserialized.size(); i++) {
    		if (questionsDeserialized[i].Id == dropBoxQuestion.Id) {
    			questionsDeserialized.set(i, dropBoxQuestion);
    			break;
    		}
    	}

		String questionsJSON = JSON.serializePretty(questionsDeserialized);

		HttpRequest postReq = new HttpRequest();
		postReq.setEndpoint('https://api-content.dropbox.com/1/files_put/auto/' + topicDropboxId);
		postReq.setMethod('POST');
		postReq.setHeader('Authorization', 'Bearer NAVL3W_WUewAAAAAAAAAHJ3pnbVRoHy1oak2WOoF4GoBZ0V3sJ9Mufq_d38DK4uk');
		postReq.setHeader('Content-Type', 'application/json');
		postReq.setBody (questionsJSON);
		HTTPResponse postRes = new Http().send(postReq);

	}

	public void deleteQuestionFromDatabase() {
		delete preCreatedQuestion;


	}

}