public with sharing class KATestPassingController {

	public List<String> multipleAnswers { get; set; }
	public String singleAnswer { get; set; }

	public List<TestQuestion__c> questions { get; private set; }
	public Map<String, Boolean> variants { get; private set; }
	public Integer currentQuestion { get; private set; }
	public Integer totalQuestionsNum { get; private set; }
	public String questionType { get; private set; }

	private List<List<String>> appliedAnswers { private get; private set; }
	private List<String> subAppliedAnswer { private get; private set; }
	private String username { private get; private set; }
	private String testId { private get; private set; }
	private PageReference currentPage;

	public KATestPassingController() {
		currentQuestion = 0;

		multipleAnswers = new List<String>();
		variants = new Map<String, Boolean>();

		currentPage = ApexPages.currentPage();
		testId = currentPage.getParameters().get('test');

		Cookie tmpCookie = currentPage.getCookies().get('KALogin');

		if (testId != null && tmpCookie != null) {
			username = tmpCookie.getValue();
			questions = [
				SELECT Question__r.Id, Question__r.Statement__c, Question__r.Theme__r.Subject__r.Name, Question__r.Theme__r.Name
				FROM TestQuestion__c
				WHERE Test__r.Id = :testId
				LIMIT 50000
			];
			totalQuestionsNum = questions.size();

			appliedAnswers = new List<List<String>>();
			for (Integer i = 0; i < totalQuestionsNum; i++) {
				appliedAnswers.add(new List<String>());
			}

			subAppliedAnswer = new String[1];
			variants = getVariants(currentQuestion);
		}
	}

	public PageReference onLoad() {
		if (username != null) {
			return null;
		}
		else if (username != null && testId == null) {
			return new PageReference('/apex/KARegularUserHomePage');
		}
		else {
			return new PageReference('/apex/KALoginPage');
		}
	}

	public PageReference goHome() {
		return new PageReference('/apex/KARegularUserHomePage');
	}

	public List<SelectOption> getVariantOptions() {
		List<SelectOption> resultVariants = new List<SelectOption>();
		for (String variantKey : variants.keySet()) {
			resultVariants.add(new SelectOption(variantKey, variantKey));
		}
		return resultVariants;
	}

	public void goToPrev() {
		doSingleTransfer(false);
	}

	public void goToNext() {
		doSingleTransfer(true);
	}

	public PageReference goToFinish() {
		doSingleTransfer(null);
		Employee__c currentEmployee = [
			SELECT Id
			FROM Employee__c
			WHERE Name = :username
			LIMIT 1
		];
		Test__c currentTest = [
			SELECT Id
			FROM Test__c
			WHERE Id = :testId
			LIMIT 1
		];
		Pass_History__c newestResult = new Pass_History__c(Employee__c = currentEmployee.Id, Test__c = currentTest.Id, Result__c = getResults());
		insert newestResult;

		return new PageReference('/apex/KARegularUserHomePage');
	}

	private Map<String, Boolean> getVariants(Integer questionPosition) {
		List<Answer__c> tmpVariants = [
			SELECT Variant__c, Right__c
			FROM Answer__c
			WHERE Question__r.Id = :questions[questionPosition].Question__r.Id
		];
		Map<String, Boolean> resultVariants = new Map<String, Boolean>();
		{
			Integer rights = 0;
			for (Answer__c answer : tmpVariants) {
				resultVariants.put(answer.Variant__c, answer.Right__c);
				if (answer.Right__c == true) {
					rights++;
				}
			}
			if (rights > 1) {
				questionType = 'multiple';
				multipleAnswers = appliedAnswers.get(questionPosition);
			}
			else {
				questionType = 'single';
				if (appliedAnswers.get(questionPosition).size() == 1) {
					singleAnswer = appliedAnswers.get(questionPosition).get(0);
				}
			}
		}
		return resultVariants;
	}

	private Map<String, Boolean> getRightVariants(Integer questionPosition) {
		List<Answer__c> tmpVariants = [
			SELECT Variant__c, Right__c
			FROM Answer__c
			WHERE Question__r.Id = :questions[questionPosition].Question__r.Id AND Right__c = true
		];
		Map<String, Boolean> resultVariants = new Map<String, Boolean>();
		{
			for (Answer__c answer : tmpVariants) {
				resultVariants.put(answer.Variant__c, answer.Right__c);
			}
		}
		return resultVariants;
	}

	private void doSingleTransfer(Boolean direction) {
		if (questionType == 'multiple') {
			appliedAnswers.set(currentQuestion, new List<String>(multipleAnswers));
			multipleAnswers.clear();
		}
		else if (questionType == 'single') {
			subAppliedAnswer[0] = singleAnswer;
			appliedAnswers.set(currentQuestion, new List<String>(subAppliedAnswer));
			singleAnswer = '';
		}
		if (direction != null) {
			if (direction) {
				currentQuestion++;
			}
			else {
				currentQuestion--;
			}
			variants = getVariants(currentQuestion);
		}
		else {

		}
	}

	private Double getResults() {
		Map<String, Boolean> resultVariants = new Map<String, Boolean>();
		List<String> resultAppliedAnswers = new List<String>();
		Integer rightAnswers = 0;
		for (Integer i = 0; i < totalQuestionsNum; i++) {
			resultVariants = getRightVariants(i);
			resultAppliedAnswers = appliedAnswers.get(i);

			Boolean isRight = true;
			if (resultVariants.size() == resultAppliedAnswers.size()) {
				for (String resultAnswer : resultAppliedAnswers) {
					if (resultVariants.get(resultAnswer) == null || ! resultVariants.get(resultAnswer)) {
						isRight = false;
						break;
					}
				}
				if (isRight) {
					rightAnswers++;
				}
			}
		}
		return 100 * rightAnswers / totalQuestionsNum;
	}

}