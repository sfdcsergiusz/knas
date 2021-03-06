@isTest
private class KACreateNewPasswordControllerTest {

	private static KACreateNewPasswordController testPasCntr; 
	
	private static void init() {
		testPasCntr = new KACreateNewPasswordController();
	}
	
	@isTest static void testOnloadRightHash() {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = 'testHash');
		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
  		Employee__c testUser = new Employee__c(Action_Hash__c = testEmployee.Action_Hash__c, Waiting_Reset__c = true, Password__c = 'testPassword');
		insert testUser;

		testPasCntr.user = testUser;
		testPasCntr.onLoad();
		Boolean testRightHash = testPasCntr.isRightLink;
		System.assertEquals(true, testRightHash);
	}
	
	@isTest static void testOnloadWrongHash() {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = 'testHash');
		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
  		Employee__c testUser = new Employee__c(Action_Hash__c = 'wrongHash', Waiting_Reset__c = true, Password__c = 'testPassword');
		insert testUser;

		testPasCntr.user = testUser;
		testPasCntr.onLoad();
		Boolean testRightHash = testPasCntr.isRightLink;
		System.assertEquals(false, testRightHash);
	}

	@isTest static void testOnloadEmptyHash() {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = '');
  		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
		testPasCntr.onLoad();
		Boolean testRightHash = testPasCntr.isRightLink;
		System.assertEquals(false, testRightHash);

	}

	@isTest static void testOnloadNullHash() {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = null);
  		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
		testPasCntr.onLoad();
		Boolean testRightHash = testPasCntr.isRightLink;
		System.assertEquals(false, testRightHash);

	}

	@isTest static void testSetNewPassword () {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = 'testHash', Waiting_Reset__c = true);
		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
		String testPassword = 'testPassword';		
		testPasCntr = new KACreateNewPasswordController();
		testPasCntr.newPassword = testPassword;
		testPasCntr.confirmPassword = testPassword;
		Employee__c testUser = new Employee__c(Action_Hash__c = testEmployee.Action_Hash__c, Waiting_Reset__c = true, Password__c = 'testPassword');
		insert testUser;

		testPasCntr.user = testUser;
		testPasCntr.setNewPassword();
		String testHash = testPasCntr.user.Action_Hash__c;
		System.assertEquals(null, testHash); 
	}

	@isTest static void testErrorHashNotUnique () {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = null, Waiting_Reset__c = true);
		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
		testPasCntr.setNewPassword();
		Boolean testReset = testPasCntr.user.Waiting_Reset__c;
		System.assertEquals(false, testReset); 
	}

	@isTest static void testErrorPasswordsNotEqual () {
		init();
		Employee__c testEmployee = new Employee__c(Action_Hash__c = 'testHash', Waiting_Reset__c = true);
		PageReference currPage = Page.KACreateNewPassword;
  		currPage.getParameters().put('hashLink', testEmployee.Action_Hash__c);
  		Test.setCurrentPage(currPage);
  				
		testPasCntr = new KACreateNewPasswordController();
		testPasCntr.newPassword = 'testPassword1';
		testPasCntr.confirmPassword = 'testPassword2';
		testPasCntr.setNewPassword(); 
		Boolean testReset = testPasCntr.user.Waiting_Reset__c;
		System.assertEquals(false, testReset); 
	}

}