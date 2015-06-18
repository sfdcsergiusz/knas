public with sharing class KASubjectQuestionsListController {

	public List<Subject__c> subjects { get; set; }
	public List<Theme__c> themes { get; set; }

	public String tmpSubject { get; set; }
	public String tmpTheme { get; set; }

	public Id chosenSubject { get; set; }
	public Id chosenTheme { get; set; }

	public List<Question__c> questions { get; set; }
	public String subjectName { get; set; }
	public String themeName { get; set; }

	public Question__c preCreatedQuestion { get; set; }
	public List<Answer__c> preCreatedAnswers { get; set; }

	private PageReference currentPage;

	public KASubjectQuestionsListController() {
		subjects = new List<Subject__c>();
		themes = new List<Theme__c>();
		preCreatedQuestion = new Question__c();
		preCreatedAnswers = new List<Answer__c>();
		for (Integer i = 0; i < 3; i++) {
			preCreatedAnswers.add(new Answer__c());
		}

		currentPage = ApexPages.currentPage();
		themeName = currentPage.getParameters().get('themeName');
		subjectName = currentPage.getParameters().get('subjectName');
		if (themeName != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate, Theme__r.Name, Theme__r.Subject__r.Name
				FROM Question__c
				WHERE Theme__r.Name = :themeName
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			if (questions.size() > 0) {
				subjectName = questions[0].Theme__r.Subject__r.Name;
			}
			else {
				subjectName = [
					SELECT Subject__r.Name
					FROM Theme__c
					WHERE Name = :themeName
					LIMIT 1
					].Subject__r.Name;
			}

			tmpSubject = subjectName;
			tmpTheme = themeName;
		}
		else if (subjectName != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate,  Theme__r.Name, Theme__r.Subject__r.Name
				FROM Question__c
				WHERE Theme__r.Subject__r.Name = :subjectName
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			tmpSubject = subjectName;
		}
	}

	public PageReference goHome() {
		return new PageReference('/apex/KAAdminUserHomePage');
	}

	public void typeSubject() {
		String searchSubject = '%' + tmpSubject + '%';
		subjects = [
			SELECT Name
			FROM Subject__c
			WHERE Name LIKE :searchSubject
		];
	}

	public void typeTheme() {
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
		Theme__c varTheme = [
			SELECT Name
			FROM Theme__c
			WHERE Name LIKE :tmpTheme AND Subject__r.Name LIKE :tmpSubject
		];
		preCreatedQuestion.Theme__c = varTheme.Id;
		insert preCreatedQuestion;

		List<Answer__c> preInsertedAnswers = new List<Answer__c>();
		for (Integer i = 0; i < preCreatedAnswers.size(); i++) {
			if (preCreatedAnswers[i].Variant__c != null && preCreatedAnswers[i].Variant__c != '') {
				preCreatedAnswers[i].Question__c = preCreatedQuestion.Id;

				preInsertedAnswers.add(preCreatedAnswers[i]);
			}
		}
		insert preInsertedAnswers;

		preCreatedQuestion = new Question__c();
		preCreatedAnswers.clear();
		for (Integer i = 0; i < 3; i++) {
			preCreatedAnswers.add(new Answer__c());
		}

		if (themeName != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate, Theme__r.Name, Theme__r.Subject__r.Name
				FROM Question__c
				WHERE Theme__r.Name = :themeName
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			if (questions.size() > 0) {
				subjectName = questions[0].Theme__r.Subject__r.Name;
			}
			else {
				subjectName = [
					SELECT Subject__r.Name
					FROM Theme__c
					WHERE Name = :themeName
					LIMIT 1
					].Subject__r.Name;
			}

			tmpSubject = subjectName;
			tmpTheme = themeName;
		}
		else if (subjectName != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate,  Theme__r.Name, Theme__r.Subject__r.Name
				FROM Question__c
				WHERE Theme__r.Subject__r.Name = :subjectName
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			tmpSubject = subjectName;
		}
		if (themeName != null) {
			PageReference updatingPage = new PageReference('/apex/KASubjectQuestionsListPage?themeName='+themeName);
			updatingPage.setRedirect(true);
			return updatingPage;
		}
		else {
			PageReference updatingPage = new PageReference('/apex/KASubjectQuestionsListPage?subjectName='+subjectName);
			updatingPage.setRedirect(true);
			return updatingPage;
		}
	}

	public void deleteQuestion() {
		Question__c deletingQuestion = [
			SELECT Id
			FROM Question__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('chosenQuestion')
		];
		delete deletingQuestion;

		if (themeName != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate, Theme__r.Name, Theme__r.Subject__r.Name
				FROM Question__c
				WHERE Theme__r.Name = :themeName
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			if (questions.size() > 0) {
				subjectName = questions[0].Theme__r.Subject__r.Name;
			}
			else {
				subjectName = [
					SELECT Subject__r.Name
					FROM Theme__c
					WHERE Name = :themeName
					LIMIT 1
					].Subject__r.Name;
			}

			tmpSubject = subjectName;
			tmpTheme = themeName;
		}
		else if (subjectName != null) {
			questions = [
				SELECT Name, Level__c, Statement__c, CreatedDate,  Theme__r.Name, Theme__r.Subject__r.Name
				FROM Question__c
				WHERE Theme__r.Subject__r.Name = :subjectName
				ORDER BY CreatedDate DESC
				LIMIT 50000
			];
			tmpSubject = subjectName;
		}
	}

}