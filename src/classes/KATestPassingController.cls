public with sharing class KATestPassingController {

	public List<String> multipleAnswers { get; set; }
	public String singleAnswer { get; set; }

	public Test__c currentTest { get; private set; }
	public Employee__c currentUser { get; private set; }

	public List<Question__c> questions { get; private set; }
	public Map<String, Boolean> variants { get; private set; }
	public Integer currentQuestion { get; private set; }
	public Integer totalQuestionsNum { get; private set; }
	public Integer currRightAnswers { get; private set; }
	public String questionType { get; private set; }

	public Boolean isGreetingBlockEnabled { get; private set; }
	public Boolean isTestBlockEnabled { get; private set; }
	public Boolean isFinishBlockEnabled { get; private set; }
	public Boolean isRestrictingBlockEnabled { get; private set; }

	public List<List<String>> appliedAnswers { get; private set; }

	private List<String> subAppliedAnswer { private get; private set; }
	private PageReference currentPage;


	public KATestPassingController() {
		currentPage = ApexPages.currentPage();

		this.isFinishBlockEnabled = false;
		this.isTestBlockEnabled = false;

		if (checkTestExistence()) {
			this.isGreetingBlockEnabled = true;
			this.isRestrictingBlockEnabled = false;
		}
		else {
			this.isGreetingBlockEnabled = false;
			this.isRestrictingBlockEnabled = true;
		}
	}

	public PageReference goBack() {
		PageReference returningPage = new PageReference('/apex/KARegularUserHome');
		returningPage.setRedirect(true);
		return returningPage;
	}

	public void startTest() {
		if (checkTestExistence() && checkUserAvailability() && checkTaskStatusSuitable()) {
			questions = new List<Question__c>();
			currentQuestion = 0;

			multipleAnswers = new List<String>();
			variants = new Map<String, Boolean>();

			List<TestTheme__c> correspThemes = [
				SELECT Theme__r.Id, Questions_Captured__c
				FROM TestTheme__c
				WHERE Test__r.Id = :currentTest.Id
			];

			if ( ! correspThemes.isEmpty()) {
				totalQuestionsNum = Integer.valueOf(correspThemes.get(0).Questions_Captured__c);

				List<Question__c> acceptableQuestions = [
					SELECT Id, Statement__c, Theme__r.Subject__r.Name, Theme__r.Name,
					(
						SELECT Variant__c, Right__c
						FROM Answers__r
					)
					FROM Question__c
					WHERE Theme__r.Id = :correspThemes.get(0).Theme__r.Id
					LIMIT 50000
				];
				Map<Integer, Integer> questionsMix = returnRandoms(totalQuestionsNum, totalQuestionsNum);
				for (Integer randomQuestion : questionsMix.keySet()) {
					questions.add(
						acceptableQuestions.get(
							randomQuestion
						)
					);
				}

				appliedAnswers = new List<List<String>>();
				for (Integer i = 0; i < totalQuestionsNum; i++) {
					appliedAnswers.add(new List<String>());
				}

				subAppliedAnswer = new String[1];
				variants = getVariants(currentQuestion);
				updateCurrentRightAnswers();


			}
		}

		this.isGreetingBlockEnabled = false;
		if (totalQuestionsNum != null) {
			this.isTestBlockEnabled = true;
			this.isRestrictingBlockEnabled = false;
		}
		else {
			this.isTestBlockEnabled = false;
			this.isRestrictingBlockEnabled = true;
		}
	}

	private Boolean checkTestExistence() {
		if (currentTest != null) {
			return true;
		}
		else {
			List<Test__c> checkTestExistenceList = [
				SELECT Id, Duration__c, Subject__r.Name
				FROM Test__c
				WHERE Id = :currentPage.getParameters().get('test')
				LIMIT 1
			];
			if ( ! checkTestExistenceList.isEmpty()) {
				currentTest = checkTestExistenceList.get(0);
				return true;
			}
		}
		return false;
	}

	private Boolean checkUserAvailability() {
		Cookie tmpCookie = currentPage.getCookies().get('Identifier');
		if (currentTest.Id != null && tmpCookie != null) {
			List<Browser__c> tmpBrowsers = [
				SELECT Employee__r.Id
				FROM Browser__c
				WHERE Identifier__c = :tmpCookie.getValue()
				LIMIT 1
			];
			if ( ! tmpBrowsers.isEmpty()) {
				currentUser = [
					SELECT Id, First_Name__c
					FROM Employee__c
					WHERE Id = :tmpBrowsers.get(0).Employee__r.Id
					LIMIT 1
				];
				return true;
			}
		}
		return false;
	}

	private Boolean checkTaskStatusSuitable() {
		List<Employee_Task__c> checkTaskStatusList = [
			SELECT Task__r.Status__c
			FROM Employee_Task__c
			WHERE Employee__r.Id = :currentUser.Id AND Task__r.Test__r.Id = :currentTest.Id
			LIMIT 1
		];
		if ( ! checkTaskStatusList.isEmpty()) {
			if (checkTaskStatusList.get(0).Task__r.Status__c == 'Scheduled') {
				Task__c currentTask = [
					SELECT Id
					FROM Task__c
					WHERE Id = :checkTaskStatusList.get(0).Task__r.Id
					LIMIT 1
				];
				currentTask.Status__c = 'Failed';
				update currentTask;

				return true;
			}
		}
		return false;
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

	public void goToFinish() {
		doSingleTransfer(null);
		this.isTestBlockEnabled = false;
		this.isFinishBlockEnabled = true;

	}

	public void goToQuestions() {
		this.isTestBlockEnabled = true;
		this.isFinishBlockEnabled = false;

		String newCurrQuest = ApexPages.currentPage().getParameters().get('questOnEdit');
		currentQuestion = Integer.valueOf(newCurrQuest);
		variants = getVariants(currentQuestion);
	}

	public PageReference finishTest() {
		List<Pass_History__c> oldHistory = [
			SELECT Id
			FROM Pass_History__c
			WHERE Test__r.Id = :currentTest.Id AND Employee__r.Id = :currentUser.Id
		];
		delete oldHistory;

		Pass_History__c newestResult = new Pass_History__c(Employee__c = currentUser.Id, Test__c = currentTest.Id, Result__c = getResults());
		insert newestResult;

		Employee_Task__c currentEmpTask = [
			SELECT Task__r.Status__c
			FROM Employee_Task__c
			WHERE Task__r.Test__r.Id = :currentTest.Id AND Employee__r.Id = :currentUser.Id
		];

		Task__c currentTask = [
			SELECT Id
			FROM Task__c
			WHERE Id = :currentEmpTask.Task__r.Id
			LIMIT 1
		];
		currentTask.Status__c = 'Passed';
		update currentTask;

		PageReference returningPage = new PageReference('/apex/KARegularUserHome');
		returningPage.setRedirect(true);
		return returningPage;
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
		updateCurrentRightAnswers();
	}

	private Map<String, Boolean> getVariants(Integer questionPosition) {
		List<Answer__c> tmpVariants = new List<Answer__c>();

		List<Answer__c> tmpInitialVariants = [
			SELECT Variant__c, Right__c
			FROM Answer__c
			WHERE Question__r.Id = :questions[questionPosition].Id
		];

		Map<Integer, Integer> variantsMix = returnRandoms(tmpInitialVariants.size(), tmpInitialVariants.size());
		for (Integer randomVariant : variantsMix.keySet()) {
			tmpVariants.add(
				tmpInitialVariants.get(
					randomVariant
				)
			);
		}

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
		List<Answer__c> tmpVariants = questions.get(questionPosition).Answers__r;
		for (Integer i = 0; i < tmpVariants.size(); i++) {
			if ( ! tmpVariants.get(i).Right__c) {
				tmpVariants.remove(i);
				i--;
			}
		}
		Map<String, Boolean> resultVariants = new Map<String, Boolean>();
		{
			for (Answer__c answer : tmpVariants) {
				resultVariants.put(answer.Variant__c, answer.Right__c);
			}
		}
		return resultVariants;
	}

	private void updateCurrentRightAnswers() {
		List<Answer__c> currRightAnswersList = questions.get(currentQuestion).Answers__r;
		for (Integer i = 0; i < currRightAnswersList.size(); i++) {
			if ( ! currRightAnswersList.get(i).Right__c) {
				currRightAnswersList.remove(i);
				i--;
			}
		}
		currRightAnswers = currRightAnswersList.size();
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

	private Map<Integer, Integer> returnRandoms(Integer upperLimit, Integer numberOfRands) {
		Map<Integer, Integer> randomResultMap = new Map<Integer, Integer>();
		for (Integer i = 0; i < numberOfRands; i++) {
			Integer rand;
			do {
				rand = Math.mod(Math.round(Math.random()*1000), upperLimit);
			}
			while (randomResultMap.get(rand) != null);
			randomResultMap.put(rand, rand);
		}
		return randomResultMap;
	}

}