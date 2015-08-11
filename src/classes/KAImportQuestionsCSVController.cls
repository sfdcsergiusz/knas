public with sharing class KAImportQuestionsCSVController {

	public Blob csvFileBody { get; set; }
	public String csvAsString{ get; set; }
	public String[] csvFileLines { get; set; }
	public List<Question__c> quelist { get; set; }
	public List<List<Answer__c>> rightAnswers { get; set; }
	public List<List<Answer__c>> wrongAnswers { get; set; }
	public String themeId { get; set; }
	public String backLink {
		get {
			return 'apex/' + KAPageConstants.packagePrefix + 'KACommonSubjects';
		}
		private set;
	}
	public KANotificationMapWrapper notificMap { get; private set; }

	private PageReference currentPage;

	public KAImportQuestionsCSVController() {
		csvFileLines = new String[]{};
		quelist = new List<Question__c>();
		rightAnswers = new List<List<Answer__c>>();
		wrongAnswers = new List<List<Answer__c>>();
		currentPage = ApexPages.currentPage();
		themeId = currentPage.getParameters().get('themeId');
		notificMap = new KANotificationMapWrapper();
	}

	public void importCsvFile() {
		try {
			quelist.clear();
			if ( ! String.isEmpty(csvAsString)) {
				csvAsString = csvFileBody.toString();
				csvFileLines = csvAsString.split('\n');

				List<Theme__c> tmpList = [
					SELECT Id
					FROM Theme__c
					WHERE Id = :themeId
					LIMIT 1
				];

				for (Integer i = 1; i < csvFileLines.size(); i++) {
					Question__c question = new Question__c();
					String[] csvRecordData = csvFileLines[i].split(';');
					if (csvRecordData.size() == 4) {
						question.Statement__c = csvRecordData[0];
						question.Level__c = csvRecordData[1];

						List<Answer__c> tmpRightAnswerList = new List<Answer__c>();
						if ( ! String.isEmpty(csvRecordData[2])) {
							for (String answerName : csvRecordData[2].split('~')) {
								tmpRightAnswerList.add(new Answer__c(Variant__c = answerName, Right__c = true));
							}
							rightAnswers.add(tmpRightAnswerList);
						}

						List<Answer__c> tmpWrongAnswerList = new List<Answer__c>();
						if ( ! String.isEmpty(csvRecordData[3])) {
							for (String answerName : csvRecordData[3].split('~')) {
								tmpWrongAnswerList.add(new Answer__c(Variant__c = answerName));
							}
							wrongAnswers.add(tmpWrongAnswerList);
						}

						if (tmpList.size () > 0) {
							question.Theme__c = tmpList.get(0).Id;
							quelist.add(question);
						}

					}
				}

				if ( ! quelist.isEmpty()) {
					insert quelist;
				}

				for (Integer i = 0; i < quelist.size(); i++) {
					for (Integer j = 0; j < rightAnswers[i].size(); j++) {
						rightAnswers[i][j].Question__c = quelist[i].Id;
					}
					for (Integer j = 0; j < wrongAnswers[i].size(); j++) {
						wrongAnswers[i][j].Question__c = quelist[i].Id;
					}
				}
				List<Answer__c> insertAnswers = new List<Answer__c>();
				for (List<Answer__c> answer : rightAnswers) {
					insertAnswers.addAll(answer);
				}
				for (List<Answer__c> answer : wrongAnswers) {
					insertAnswers.addAll(answer);
				}
				insert insertAnswers;

			}
		   	else {
		   		notificMap.addDanger('File is Empty, please, choose file');
		   	}

	  	}
	  	catch (Exception exc) {
	  		notificMap.addDanger('Invalid file');
	  	}
	  	finally {
	  		if (notificMap.isEmpty) {
	  			notificMap.addSuccess('Import successed');
	  		}
	  		csvAsString = null;
	  	}
	}

	public void importCsvToDropbox() {
		List<Question__c> dBQuestions = [
			SELECT Name, Level__c, Statement__c, CreatedDate, Theme__r.Name, Theme__r.Subject__r.Name, Theme__r.Subject__r.Id, (
				SELECT Variant__c, Right__c
				FROM Answers__r
			)
			FROM Question__c
		];
		if (dBQuestions.size() > 0) {
			KADropBoxUtil.putQuestionsByTopic(themeId, dBQuestions);
		}

		delete dBQuestions;
	}

}