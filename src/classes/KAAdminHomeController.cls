public with sharing class KAAdminHomeController {

	public List<Employee_Task__c> recentTasks { get; set; }
	public List<Pass_History__c> recentResults { get; set; }
	public List<Question__c> questionRequests { get; set; }

	public List<Employee__c> employees { get; set; }
	public List<Test__c> tests { get; set ;}
	
	public String tmpEmployee { get; set; }
	public String tmpTest { get; set; }

	public Id chosenEmployee { get; set; }
	public Id chosenTest { get; set; }

	public Task__c preCreatedTask { get; set; }
	public Employee_Task__c preCreatedEmployeeTask { get; set; }

	public List<CronJobDetail> scheduledJobs { get; private set; }

	public KAAdminHomeController() {
		refreshRecentTasks();
		refreshRecentResults();

		employees = new List<Employee__c>();
		tests = new List<Test__c>();
		preCreatedTask = new Task__c();
		preCreatedEmployeeTask = new Employee_Task__c();
		scheduledJobs = [
			SELECT Id 
			FROM CronJobDetail
		];
	}

	public PageReference goHome() {
		return null;
	}

	public PageReference makeLogout() {
		ApexPages.currentPage().setCookies(
			new Cookie[] {
				new Cookie('KALogin', '', null, 0, false)
			}
		);
		return new PageReference('/apex/KALogin');
	}

	public void refreshRecentTasks() {
		recentTasks = [
			SELECT Employee__r.First_Name__c, Employee__r.Last_Name__c, Task__r.Status__c, Task__r.AssignTime__c, Task__r.CreatedDate, Task__r.Test__r.Name
			FROM Employee_Task__c
			ORDER BY CreatedDate DESC
			LIMIT 50000
		];
	}

	public void refreshRecentResults() {
		recentResults = [
			SELECT Employee__r.First_Name__c, Employee__r.Last_Name__c, CreatedDate, Result__c, Test__r.Subject__r.Name, Test__r.Name
			FROM Pass_History__c
			ORDER BY CreatedDate DESC
			LIMIT 50000
		];
	}

	public PageReference createNewTask() {
		if (preCreatedTask.AssignTime__c != null) {
			List<Test__c> suitableTests = [
				SELECT Id
				FROM Test__c
				WHERE Id = :chosenTest
				LIMIT 1
			];
			if (suitableTests.size() > 0) {
				preCreatedTask.Test__c = suitableTests.get(0).Id;

				List<Employee_Task__c> existingEmploTasks = [
					SELECT Task__r.Id
					FROM Employee_Task__c
					WHERE Task__r.Test__c = :preCreatedTask.Test__c AND Employee__c =:chosenEmployee
				];
				if ( ! existingEmploTasks.isEmpty()) {
					List<Task__c> deletingTasks = new List<Task__c>();
					for (Employee_Task__c tmpEmploTask : existingEmploTasks) {
						deletingTasks.add(tmpEmploTask.Task__r);
					}
					delete deletingTasks;
				}

				insert preCreatedTask;

				List<Task__c> suitableTasks = [
					SELECT Id
					FROM Task__c
					WHERE Id = :preCreatedTask.Id
					LIMIT 1
				];
				List<Employee__c> suitableEmployees = [
					SELECT Id
					FROM Employee__c
					WHERE Id = :chosenEmployee
					LIMIT 1
				];
				if (suitableTasks.size() > 0 && suitableEmployees.size() > 0) {
					preCreatedEmployeeTask.Task__c = suitableTasks.get(0).Id;
					preCreatedEmployeeTask.Employee__c = suitableEmployees.get(0).Id;
					preCreatedEmployeeTask.IsEmailQueue__c = true;
					insert preCreatedEmployeeTask;
				}	
			}
		}
		PageReference updatingPage = new PageReference('/apex/KAAdminUserHome');
		updatingPage.setRedirect(true);
		return updatingPage;
	}

	public void typeEmployee() {
		String searchEmployee = '%' + tmpEmployee + '%';
		employees = [
			SELECT First_Name__c, Last_Name__c
			FROM Employee__c
			WHERE First_Name__c LIKE :searchEmployee OR Last_Name__c LIKE :searchEmployee
		];
	}

	public void typeTest() {
		String searchTest = '%' + tmpTest + '%';
		tests = [
			SELECT Name, Subject__r.Name
			FROM Test__c
			WHERE Name LIKE :searchTest OR Subject__r.Name LIKE :searchTest
		];
	}

	public void chooseEmployee() {
		chosenEmployee = (Id) ApexPages.currentPage().getParameters().get('chosenEmployee');
		Employee__c varEmployee = [
			SELECT First_Name__c, Last_Name__c
			FROM Employee__c
			WHERE Id = :chosenEmployee
			LIMIT 1
		];
		tmpEmployee = varEmployee.First_Name__c + ' ' + varEmployee.Last_Name__c;
		employees.clear();
	}

	public void chooseTest() {
		chosenTest = (Id) ApexPages.currentPage().getParameters().get('chosenTest');
		Test__c varTest = [
			SELECT Name, Subject__r.Name
			FROM Test__c
			WHERE Id = :chosenTest
			LIMIT 1
		];
		tmpTest = varTest.Name + ' ' + varTest.Subject__r.Name;
		tests.clear();
	}

	public void switchOnEmailing () {
		System.schedule('Daily emails', '0 0 9,10,11,12,13,14,15,16,17,18 * * ?', new KAEmailHandler());
	}

}