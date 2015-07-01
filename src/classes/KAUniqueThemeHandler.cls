public with sharing class KAUniqueThemeHandler {
	public static Boolean enablesTrigger = false;
	public static void addNewTheme (List<Theme__c> p_theme) {
		List<Theme__c> themes = [
			SELECT Name
			FROM Theme__c
			WHERE Name = :p_theme.get(0).Name
				AND Subject__c = :p_theme.get(0).Subject__c
			LIMIT 1 
		];

		if (themes.size() > 0) {
			 p_theme.get(0).addError('error');
		}
	}
}