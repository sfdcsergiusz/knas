public with sharing class KAAdminHomeController {

	public List<Employee_Task__c> recentTasks { get; set; }
	public List<Pass_History__c> recentResults { get; set; }
	//public List<Question__c> questionRequests { get; set; } Future feature

	public List<Employee__c> employees { get; set; }
	public List<Test__c> tests { get; set ;}

	public String tmpEmployee { get; set; }
	public String tmpTest { get; set; }

	public Id chosenEmployee { get; set; }
	public Id chosenTest { get; set; }

	public Task__c deletingTask { get; set; }

	public Task__c preCreatedTask { get; set; }
	public Employee_Task__c preCreatedEmployeeTask { get; set; }

	public String dropBoxToken { get; set; }

	public List<CronTrigger> scheduledTriggers { get; private set; }
	public KANotificationMapWrapper notificMap { get; private set; }

	public KAAdminHomeController() {
		refreshRecentTasks();
		refreshRecentResults();

		notificMap = new KANotificationMapWrapper();
		employees = new List<Employee__c>();
		tests = new List<Test__c>();
		preCreatedTask = new Task__c();
		preCreatedEmployeeTask = new Employee_Task__c();
		scheduledTriggers = [
			SELECT Id
			FROM CronTrigger
		];
		dropBoxToken = DropBox__c.getValues('Token').Token__c;
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
			SELECT Employee__r.First_Name__c, Employee__r.Last_Name__c, CreatedDate, Result__c, Test__r.Subject__r.Name, Test__r.Name, Test__r.Difficulty__c, Test__r.Passing_Threshold__c
			FROM Pass_History__c
			ORDER BY CreatedDate DESC
			LIMIT 50000
		];
	}

	public PageReference createNewTask() {
		List<Employee__c> suitableEmployees = [
			SELECT Id
			FROM Employee__c
			WHERE Id = :chosenEmployee
			LIMIT 1
		];
		List<Test__c> suitableTests = [
			SELECT Id
			FROM Test__c
			WHERE Id = :chosenTest
			LIMIT 1
		];

		if (suitableEmployees.size() == 0 || suitableTests.size() == 0 ||
			preCreatedTask.AssignTime__c == null || preCreatedTask.AssignTime__c < Datetime.now()) {
			if (suitableEmployees.size() == 0) {
				notificMap.addDanger('User doesn\'t exist.');
			}
			else if (suitableTests.size() == 0) {
				notificMap.addDanger('Test doesn\'t exist.');
			}
			else if (preCreatedTask.AssignTime__c == null) {
				notificMap.addDanger('Date shouldn\'t be empty.');
			}
			else if (preCreatedTask.AssignTime__c < Datetime.now()) {
				notificMap.addDanger('Date shouldn\'t be less than present time.');
			}
		}
		else {
			preCreatedTask.Test__c = suitableTests.get(0).Id;

			List<Employee_Task__c> existingEmploTasks = [
				SELECT Task__r.Id
				FROM Employee_Task__c
				WHERE Task__r.Test__c = :preCreatedTask.Test__c AND Employee__c = :chosenEmployee
			];
			if ( ! existingEmploTasks.isEmpty()) {
				List<Task__c> deletingTasks = new List<Task__c>();
				for (Employee_Task__c tmpEmploTask : existingEmploTasks) {
					deletingTasks.add(tmpEmploTask.Task__r);
				}
				delete deletingTasks;
			}

			try {
				insert preCreatedTask;
			}
			catch (DmlException exc) {
				ApexPages.addMessages(exc);
			}

			List<Task__c> suitableTasks = [
				SELECT Id
				FROM Task__c
				WHERE Id = :preCreatedTask.Id
				LIMIT 1
			];

			if (suitableTasks.size() > 0) {
				preCreatedEmployeeTask.Task__c = suitableTasks.get(0).Id;
				preCreatedEmployeeTask.Employee__c = suitableEmployees.get(0).Id;
				preCreatedEmployeeTask.IsEmailQueue__c = true;
				insert preCreatedEmployeeTask;

				notificMap.addSuccess('Task was created for ' + String.valueOf(preCreatedTask.AssignTime__c) + '.');

				refreshRecentTasks();
				preCreatedTask = new Task__c();
				preCreatedEmployeeTask = new Employee_Task__c();
				tmpTest = null;
				tmpEmployee = null;
				//PageReference updatingPage = new PageReference('/apex/KAAdminUserHome');
				//updatingPage.setRedirect(true);
				//return updatingPage;
			}
		}
		return null;
	}

	public void typeEmployee() {
		chosenEmployee = null;
		String searchEmployee = '%' + tmpEmployee + '%';
		employees = [
			SELECT First_Name__c, Last_Name__c
			FROM Employee__c
			WHERE IsAdmin__c != true AND (First_Name__c LIKE :searchEmployee OR Last_Name__c LIKE :searchEmployee)
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
		chosenTest = null;
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

	public void switchEmailing () {
		if (scheduledTriggers.size() > 0) {
			for (CronTrigger scheduledTrigger : scheduledTriggers) {
				System.abortJob(scheduledTrigger.Id);
			}

			notificMap.addInfo('Email distribution was switched off.');
		}
		else {
			System.schedule('Daily emails', '0 0 9,10,11,12,13,14,15,16,17,18 * * ?', new KAEmailHandler());

			notificMap.addInfo('Email distribution was switched on.');
		}
		scheduledTriggers = [
			SELECT Id
			FROM CronTrigger
		];
	}

	public void applyDbToken() {
		List<DropBox__c> dropToken = [
			SELECT Token__c
			FROM DropBox__c
			LIMIT 1
		];
		if ( ! dropToken.isEmpty()) {
			dropToken.get(0).Token__c = dropBoxToken;
			update dropToken.get(0);

			notificMap.addSuccess('DropBox Token was changed.');
		}
	}

	public void prepareTaskToDelete() {
		deletingTask = [
			SELECT Id, Test__r.Name, AssignTime__c
			FROM Task__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('deleteTaskId')
		];
	}

	public void deleteTask() {
		for (Integer i = 0; i < recentTasks.size(); i++) {
			if (recentTasks[i].Task__r.Id == deletingTask.Id) {
				recentTasks.remove(i);
				break;
			}
		}

		notificMap.addSuccess('Task was successfully deleted.');
		delete deletingTask;
	}

	public void prepareTaskToUpdate() {
		preCreatedEmployeeTask = [
			SELECT Employee__r.First_Name__c, Employee__r.Last_Name__c, Employee__r.Id, Task__r.Status__c,
				Task__r.AssignTime__c, Task__r.CreatedDate, Task__r.Test__r.Name,
				Task__r.Test__r.Subject__r.Name, Task__r.Test__r.Id
			FROM Employee_Task__c
			WHERE Id = :ApexPages.currentPage().getParameters().get('updateTaskId')
			LIMIT 1
		];
		preCreatedTask = [
			SELECT Id
			FROM Task__c
			WHERE Id = :preCreatedEmployeeTask.Task__r.Id
			LIMIT 1
		];
		tmpTest = preCreatedEmployeeTask.Task__r.Test__r.Name + ' ' + preCreatedEmployeeTask.Task__r.Test__r.Subject__r.Name;
		tmpEmployee = preCreatedEmployeeTask.Employee__r.First_Name__c + ' ' + preCreatedEmployeeTask.Employee__r.Last_Name__c;

		chosenTest = preCreatedEmployeeTask.Task__r.Test__r.Id;
		chosenEmployee = preCreatedEmployeeTask.Employee__r.Id;

		preCreatedTask.AssignTime__c = preCreatedEmployeeTask.Task__r.AssignTime__c;
	}

	public void updateTask() {
		List<Employee__c> suitableEmployees = [
			SELECT Id
			FROM Employee__c
			WHERE Id = :chosenEmployee
			LIMIT 1
		];
		List<Test__c> suitableTests = [
			SELECT Id
			FROM Test__c
			WHERE Id = :chosenTest
			LIMIT 1
		];

		if (suitableEmployees.size() == 0 || suitableTests.size() == 0 ||
			preCreatedTask.AssignTime__c == null || preCreatedTask.AssignTime__c < Datetime.now()) {
			if (suitableEmployees.size() == 0) {
				notificMap.addDanger('User doesn\'t exist.');
			}
			else if (suitableTests.size() == 0) {
				notificMap.addDanger('Test doesn\'t exist.');
			}
			else if (preCreatedTask.AssignTime__c == null) {
				notificMap.addDanger('Date shouldn\'t be empty.');
			}
			else if (preCreatedTask.AssignTime__c < Datetime.now()) {
				notificMap.addDanger('Date shouldn\'t be less than present time.');
			}
		}
		else {
			preCreatedTask.Test__c = suitableTests.get(0).Id;

			try {
				preCreatedTask.Status__c = 'Scheduled';
				update preCreatedTask;
			}
			catch (DmlException exc) {
				ApexPages.addMessages(exc);
			}

			List<Task__c> suitableTasks = [
				SELECT Id
				FROM Task__c
				WHERE Id = :preCreatedTask.Id
				LIMIT 1
			];

			if (suitableTasks.size() > 0) {
				preCreatedEmployeeTask.Task__c = suitableTasks.get(0).Id;
				preCreatedEmployeeTask.Employee__c = suitableEmployees.get(0).Id;
				preCreatedEmployeeTask.IsEmailQueue__c = true;
				notificMap.addSuccess('Task was successfully updated.');
				update preCreatedEmployeeTask;

				refreshRecentTasks();
				preCreatedTask = new Task__c();
				preCreatedEmployeeTask = new Employee_Task__c();
				tmpTest = null;
				tmpEmployee = null;
			}
		}
	}

}