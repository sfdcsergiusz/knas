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
	@isTest static void testImportRightCsv() {
		init();
		csvImportController.csvFileBody = Blob.valueOf(testCsvFile);
		csvImportController.csvAsString = testCsvFile;
		csvImportController.csvFileLines = testCsvFile.split('\n');
		csvImportController.importCsvFile();
		String testmessage = csvImportController.infoMessage;
		System.assertEquals('Import successed', testmessage);
	}

	@isTest static void testImportInvalidCsv() {
		init();
		csvImportController.csvFileBody = Blob.valueOf(testInvalidCsvFile);
		csvImportController.csvAsString = testInvalidCsvFile;
		csvImportController.csvFileLines = testInvalidCsvFile.split('\n');
		csvImportController.importCsvFile();
		csvImportController.importCsvFile();
		String testmessage = csvImportController.errorMessage;
		System.assertEquals('Invalid file', testmessage);
	}

	@isTest static void testImportEmptyCsv() {
		init();
		csvImportController.csvFileBody = Blob.valueOf(testEmptyCsvFile);
		csvImportController.csvAsString = testEmptyCsvFile;
		csvImportController.csvFileLines = testEmptyCsvFile.split('\n');
		csvImportController.importCsvFile();
		String testmessage = csvImportController.errorMessage;
		System.assertEquals('File is Empty, please, choose file', testmessage);
	}
}