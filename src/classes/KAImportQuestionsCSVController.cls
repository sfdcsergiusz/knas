public with sharing class KAImportQuestionsCSVController {

	public Blob csvFileBody { get; set; }
	public String csvAsString{ get; set; }
	public String[] csvFileLines { get; set; }
	public List<Question__c> quelist { get; set; }
	public List<List<Answer__c>> rightAnswers { get; set; }
	public List<List<Answer__c>> wrongAnswers { get; set; }
	public String themeId { get; set; }
	public Boolean isFileChosen { get; set; }
	public String errorMessage { get; private set; }
	public String infoMessage { get; private set; }

	private PageReference currentPage;

	public KAImportQuestionsCSVController() {
		csvFileLines = new String[]{};
		quelist = new List<Question__c>();
		rightAnswers = new List<List<Answer__c>>();
		wrongAnswers = new List<List<Answer__c>>();
		currentPage = ApexPages.currentPage();
		themeId = currentPage.getParameters().get('themeId');
	}

	public void importCSVFile() {
		try {
			infoMessage = null;
			errorMessage = null;
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
		   	}
		   	else {
		   		errorMessage = 'File is Empty, please, choose file';
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
	  	catch (Exception exc) {
	  		errorMessage = 'Invalid file';
	  		csvAsString = null;
	  	}
	  	finally {
	  		if (errorMessage == null) {
	  			infoMessage = 'Import successed';
	  		}
	  	}
	}
  	
}