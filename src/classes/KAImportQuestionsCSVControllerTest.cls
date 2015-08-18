@isTest
private class KAImportQuestionsCSVControllerTest {
	private static KAImportQuestionsCSVController csvImportController;
	private static String testCsvFile;
	private static String testInvalidCsvFile;
	private static String testEmptyCsvFile;
	private static Theme__c testTheme;
	private static Subject__c testSubject;

	private static void init(){
		testCsvFile = 'statement; level; riqht1~riqht2; wrong1~wrong2 \n statement; level; riqht1~riqht2; wrong1~wrong2';
		testInvalidCsvFile = 'statement; level; riqht1~riqht2; wrong1;wrong2 \n statement; level; riqht1~riqht2; wrong1~wrong2';
		testEmptyCsvFile = '';
		testSubject = new Subject__c();
		insert testSubject;

		testTheme = new Theme__c(Subject__c = testSubject.Id);
		insert testTheme;

		csvImportController = new KAImportQuestionsCSVController();
		csvImportController.themeId = testTheme.Id;
	}

}