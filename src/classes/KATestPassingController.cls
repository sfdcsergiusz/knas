public with sharing class KATestPassingController {

	public List<String> multipleAnswers { get; set; }
	public String singleAnswer { get; set; }

	public Test__c currentTest { get; private set; }
	public List<Question__c> questions { get; private set; }
	public Map<String, Boolean> variants { get; private set; }
	public Integer currentQuestion { get; private set; }
	public Integer totalQuestionsNum { get; private set; }
	public Integer currRightAnswers { get; private set; }
	public String questionType { get; private set; }

	public Boolean isEnableBlock1 { get; private set; }
	public Boolean isEnableBlock2 { get; private set; }

	public List<List<String>> appliedAnswers { get; private set; }

	private List<String> subAppliedAnswer { private get; private set; }
	private String userId { private get; private set; }
	private String testId { private get; private set; }
	private PageReference currentPage;


	public KATestPassingController() {
		currentQuestion = 0;

		questions = new List<Question__c>();
		multipleAnswers = new List<String>();
		variants = new Map<String, Boolean>();

		currentPage = ApexPages.currentPage();
		testId = currentPage.getParameters().get('test');

		Cookie tmpCookie = currentPage.getCookies().get('Identifier');

		if (testId != null && tmpCookie != null) {
			List<Browser__c> tmpBrowsers = [
				SELECT Employee__r.Id
				FROM Browser__c
				WHERE Identifier__c = :tmpCookie.getValue()
				LIMIT 1
			];
			if ( ! tmpBrowsers.isEmpty()) {
				userId = tmpBrowsers.get(0).Employee__r.Id;

				List<TestTheme__c> correspThemes = [
					SELECT Theme__r.Id, Questions_Captured__c
					FROM TestTheme__c
					WHERE Test__r.Id = :testId
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
					List<Integer> questionsMixKeyList = new List<Integer>(questionsMix.keySet());
					for (Integer i = 0; i < questionsMix.keySet().size(); i++) {
						questions.add(
							acceptableQuestions.get(
								questionsMix.get(
									questionsMixKeyList.get(i)
								)
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
		}
		currentTest = [
			SELECT Id, Duration__c
			FROM Test__c
			WHERE Id = :testId
			LIMIT 1
		];

		this.isEnableBlock1 = true;
		this.isEnableBlock2 = false;
	}

	public PageReference goHome() {
		return new PageReference('/apex/KARegularUserHome');
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
		this.isEnableBlock1 = false;
		this.isEnableBlock2 = true;

	}

	public void goToQuestions() {
		this.isEnableBlock1 = true;
		this.isEnableBlock2 = false;

		String newCurrQuest = ApexPages.currentPage().getParameters().get('questOnEdit');
		currentQuestion = Integer.valueOf(newCurrQuest);
		variants = getVariants(currentQuestion);
	}

	public PageReference finishTest() {
		Employee__c currentEmployee = [
			SELECT Id
			FROM Employee__c
			WHERE Id = :userId
			LIMIT 1
		];
		List<Pass_History__c> oldHistory = [
			SELECT Id
			FROM Pass_History__c
			WHERE Test__r.Id = :testId AND Employee__r.Id = :userId
		];
		delete oldHistory;

		Pass_History__c newestResult = new Pass_History__c(Employee__c = currentEmployee.Id, Test__c = currentTest.Id, Result__c = getResults());
		insert newestResult;

		Task__c currentTask = [
				SELECT Status__c
				FROM Task__c
				WHERE Test__r.Id = :testId
			];
		currentTask.Status__c = 'Passed';
		update currentTask;

		return new PageReference('/apex/KARegularUserHome');
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
		List<Integer> variantsMixKeyList = new List<Integer>(variantsMix.keySet());
		for (Integer i = 0; i < variantsMix.keySet().size(); i++) {
			tmpVariants.add(
				tmpInitialVariants.get(
					variantsMix.get(
						variantsMixKeyList.get(i)
					)
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