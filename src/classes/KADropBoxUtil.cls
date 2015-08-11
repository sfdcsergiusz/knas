public with sharing class KADropBoxUtil {

	private static DropBox__c dropboxSetting;

	static {
		dropboxSetting = DropBox__c.getValues('Token');
	}

	public static List<Question__c> getQuestionsByTopic(String topicDropboxId) {
		HttpRequest requestGet = new HttpRequest();
		requestGet.setEndpoint('https://api-content.dropbox.com/1/files/auto/' + String.valueOf(topicDropboxId).toUpperCase());
		requestGet.setMethod('GET');
		requestGet.setHeader('Authorization', 'Bearer ' + dropboxSetting.Token__c);
		requestGet.setHeader('Content-Type', 'application/json');
		HTTPResponse responseGet = new Http().send(requestGet);
		String responseGetBody = responseGet.getBody();

		List<Question__c> questionsDeserialized = new List<Question__c>();
		try {
			questionsDeserialized = (List<Question__c>) JSON.deserialize(responseGetBody, List<Question__c>.class);
		}
		catch (Exception exc) {
			return new List<Question__c>();
		}
		return questionsDeserialized;
	}

	public static void putQuestionsByTopic(String topicDropboxId, List<Question__c> dropBoxQuestions) {
		String questionsJSON = JSON.serializePretty(dropBoxQuestions);

		HttpRequest requestPost = new HttpRequest();
		requestPost.setEndpoint('https://api-content.dropbox.com/1/files_put/auto/' + String.valueOf(topicDropboxId).toUpperCase());
		requestPost.setMethod('POST');
		requestPost.setHeader('Authorization', 'Bearer ' + dropboxSetting.Token__c);
		requestPost.setHeader('Content-Type', 'application/json');
		requestPost.setBody (questionsJSON);
		HTTPResponse responsePost = new Http().send(requestPost);
	}

	public static void createTopic(String topicDropboxId) {
		List<Question__c> questionsDeserialized = new List<Question__c>();
		putQuestionsByTopic(topicDropboxId, questionsDeserialized);
	}

	public static void deleteTopic(String topicDropboxId) {
		HttpRequest requestPost = new HttpRequest();
		requestPost.setEndpoint('https://api.dropbox.com/1/fileops/delete?root=dropbox&path=' + String.valueOf(topicDropboxId).toUpperCase());
		requestPost.setMethod('POST');
		requestPost.setHeader('Authorization', 'Bearer ' + dropboxSetting.Token__c);
		HTTPResponse responsePost = new Http().send(requestPost);
	}

	public static List<Question__c> addQuestionToTopic(String topicDropboxId, Question__c dropBoxQuestion) {
		List<Question__c> questionsDeserialized = getQuestionsByTopic(topicDropboxId);
		questionsDeserialized.add(dropBoxQuestion);
		putQuestionsByTopic(topicDropboxId, questionsDeserialized);
		return questionsDeserialized;
	}

	public static List<Question__c> deleteQuestionFromTopic(String topicDropboxId, Question__c dropBoxQuestion) {
		List<Question__c> questionsDeserialized = getQuestionsByTopic(topicDropboxId);
		for (Integer i = 0; i < questionsDeserialized.size(); i++) {
			if (questionsDeserialized[i].Id == dropBoxQuestion.Id) {
				questionsDeserialized.remove(i);
				break;
			}
		}
		putQuestionsByTopic(topicDropboxId, questionsDeserialized);
		return questionsDeserialized;
	}

	public static List<Question__c> updateQuestionOnTopic(String topicDropboxId, Question__c dropBoxQuestion) {
		List<Question__c> questionsDeserialized = getQuestionsByTopic(topicDropboxId);
		for (Integer i = 0; i < questionsDeserialized.size(); i++) {
			if (questionsDeserialized[i].Id == dropBoxQuestion.Id) {
				questionsDeserialized.set(i, dropBoxQuestion);
				break;
			}
		}
		putQuestionsByTopic(topicDropboxId, questionsDeserialized);
		return questionsDeserialized;
	}

}