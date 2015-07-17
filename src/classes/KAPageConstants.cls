public with sharing class KAPageConstants {

	public static List<String> userPages = new List<String> {
		'KARegularUserHome',
		'KATestPassing'
	};

	public static Map<String, String> pageNames = new MAP<String, String>();

	static {
		pageNames.put('KAADMINUSERHOME', 'Admin Panel');
		pageNames.put('KACOMMONSUBJECTS', 'Subjects Control');
		pageNames.put('KACOMMONTESTS', 'Tests Control');
		pageNames.put('KACOMMONUSERS', 'Users\' Statistics');
		pageNames.put('KACREATENEWPASSWORD', 'Change Your Password');
		pageNames.put('KAIMPORTQUESTIONSCSV', 'Import Your CSV');
		pageNames.put('KALOGIN', 'Authentification');
		pageNames.put('KAREGISTER', 'Registering');
		pageNames.put('KAREGULARUSERHOME', 'Your Passings');
		pageNames.put('KASUBJECTQUESTIONSLIST', 'Questions Control');
		pageNames.put('KATESTPASSING', 'Tsss, Just Do It');
	}

}