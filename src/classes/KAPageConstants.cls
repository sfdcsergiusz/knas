public with sharing class KAPageConstants {

	public static List<String> userPages = new List<String> {
		'KARegularUserHome',
		'KATestPassing'
	};

	public static String packagePrefix { get; private set; }

	static {
		List<ApexClass> classPrefixSample = [
			SELECT NamespacePrefix
			FROM ApexClass
			WHERE Name LIKE 'KA%'
			LIMIT 1
		];
		if (classPrefixSample.size() == 0 || String.isEmpty(classPrefixSample.get(0).NamespacePrefix)) {
			packagePrefix = '';
		}
		else {
			packagePrefix = classPrefixSample.get(0).NamespacePrefix + '__';
		}
	}

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

	public static final String TASK_STATUS_SCHEDULED = 'Scheduled';

}