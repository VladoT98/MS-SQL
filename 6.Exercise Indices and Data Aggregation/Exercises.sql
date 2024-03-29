--1.Records� Count
SELECT COUNT(*) AS [Count]
FROM [WizzardDeposits]

--2.Longest Magic Wand
SELECT MAX([MagicWandSize]) AS [LongestMagicWand]
FROM [WizzardDeposits]

--3.Longest Magic Wand Per Deposit Groups
SELECT [DepositGroup],
	   MAX([MagicWandSize]) AS [LongestMagicWand]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--4.Smallest Deposit Group per Magic Wand Size
SELECT TOP 2 [DepositGroup]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]
ORDER BY AVG(MagicWandSize)

--5.Deposits Sum
SELECT [DepositGroup],
	   SUM(DepositAmount) AS [TotalAmoutByGroup]
FROM [WizzardDeposits]
GROUP BY [DepositGroup]

--6.Deposits Sum for Ollivander Family
SELECT [DepositGroup],
	   SUM(DepositAmount) AS [TotalAmoutByGroup]
FROM [WizzardDeposits]
WHERE [MagicWandCreator] = 'Ollivander family'
GROUP BY [DepositGroup]

--7.Deposits Filter
SELECT * 
FROM (SELECT [DepositGroup],
			 SUM(DepositAmount) AS [TotalAmoutByGroup]
	  FROM [WizzardDeposits]
	  WHERE [MagicWandCreator] = 'Ollivander family'
	  GROUP BY [DepositGroup]) AS [SubQuery]
WHERE [TotalAmoutByGroup] < 150000
ORDER BY [TotalAmoutByGroup] DESC

--8.Deposit Charge
SELECT [DepositGroup],
	   [MagicWandCreator],
	   MIN([DepositCharge]) AS [MinDepositCharge]
FROM [WizzardDeposits]
GROUP BY [DepositGroup], [MagicWandCreator]
ORDER BY [MagicWandCreator], [DepositGroup]

--9.Age Groups
SELECT [AgeGroup],
	   SUM([Ages]) AS [WizardCount]
FROM (SELECT CASE
		     WHEN [Age] BETWEEN 0 AND 10 THEN '[0-10]'
			 WHEN [Age] BETWEEN 11 AND 20 THEN '[11-20]'
			 WHEN [Age] BETWEEN 21 AND 30 THEN '[21-30]'
			 WHEN [Age] BETWEEN 31 AND 40 THEN '[31-40]'
			 WHEN [Age] BETWEEN 41 AND 50 THEN '[41-50]'
			 WHEN [Age] BETWEEN 51 AND 60 THEN '[51-60]'
			 WHEN [Age] > 60 THEN '[61+]'
			 END AS [AgeGroup],
			 COUNT([DepositGroup]) AS [Ages]
	 FROM [WizzardDeposits]
	 GROUP BY [Age]) AS [AgesSubQuery]
GROUP BY [AgeGroup]

--10.First Letter
SELECT *
FROM (SELECT SUBSTRING([FirstName], 1, 1) AS [FirstLetter]
	  FROM [WizzardDeposits]
	  WHERE [DepositGroup] = 'Troll chest') AS [FirstLettersSubQUery]
GROUP BY [FirstLetter]
ORDER BY [FirstLetter]

--11.Average Interest
SELECT [DepositGroup],
	   [IsDepositExpired] AS [IsDepositExpired],
	   AVG([DepositInterest]) AS [AverageInterest]
FROM [WizzardDeposits]
WHERE [DepositStartDate] > '1.1.1985'
GROUP BY [DepositGroup], [IsDepositExpired]
ORDER BY [DepositGroup] DESC, [IsDepositExpired]

--12.Rich Wizard, Poor Wizard
SELECT SUM([Difference]) AS [SumDifference]
FROM (SELECT [DepositAmount] AS [Host Wizzard Deposit],
			 LEAD([DepositAmount]) OVER(ORDER BY [Id]) AS [Guest Wizard Deposit],
			 [DepositAmount] - LEAD([DepositAmount]) OVER(ORDER BY [Id]) AS [Difference]
	  FROM [WizzardDeposits]) AS [SubQuery]

--13.Departments Total Salaries
SELECT d.[DepartmentID],
	   SUM(Salary) AS [TotalSalary]
FROM [Employees] AS e
JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
GROUP BY d.[DepartmentID]

--14.Employees Minimum Salaries
SELECT e.[DepartmentID],
	   MIN(Salary) AS [MinimumSalary]
FROM [Employees] AS e
JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE d.[DepartmentID] IN (2, 5, 7) AND e.[HireDate] > '1.1.2000'
GROUP BY e.[DepartmentID]

--15.Employees Average Salaries
SELECT * INTO [SoftUni].dbo.[NewTable]
FROM SoftUni.dbo.[Employees]
WHERE [Salary] > 30000

DELETE FROM [NewTable]
WHERE [ManagerID] = 42

UPDATE [NewTable]
SET [Salary] += 5000
WHERE [DepartmentID] = 1

SELECT [DepartmentID],
	   AVG(Salary) AS [AverageSalary]
FROM [NewTable]
GROUP BY [DepartmentID]

--16.Employees Maximum Salaries
SELECT *
FROM (SELECT [DepartmentID],
			 MAX([Salary]) AS [MaxSalary]
	  FROM [Employees]
	  GROUP BY [DepartmentID]) AS [MaxSalarySubQuery]
WHERE [MaxSalary] NOT BETWEEN 30000 AND 70000

--17.Employees Count Salaries
SELECT COUNT(*) AS [Count]
FROM [Employees]
WHERE [ManagerID] IS NULL

--18.3rd Highest Salary
SELECT [DepartmentID],
	   [Salary]
FROM (SELECT [DepartmentID],
			 [Salary],
		     DENSE_RANK() OVER(PARTITION BY [DepartmentID] ORDER BY [Salary] DESC) AS [RankedSalaries]
	  FROM [Employees]) AS [RankedSalariesSubQuery]
WHERE [RankedSalaries] = 3

--19.Salary Challenge
SELECT TOP 10 [FirstName],
			  [LastName],
			  [DepartmentID]
FROM [Employees] AS e
WHERE [Salary] > (SELECT AVG(esub.[Salary]) AS [AverageSalary]
				  FROM [Employees] AS esub
				  WHERE esub.[DepartmentID] = e.[DepartmentID]
				  GROUP BY esub.[DepartmentID])