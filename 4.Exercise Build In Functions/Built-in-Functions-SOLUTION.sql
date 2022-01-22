--1.Find Names of All Employees by First Name
SELECT [FirstName],
	   [LastName]
FROM [Employees]
WHERE [FirstName] LIKE 'Sa%'

--2.Find Names of All Employees by Last Name
SELECT [FirstName],
	   [LastName]
FROM [Employees]
WHERE [LastName] LIKE '%ei%'

--3.Find First Names of All Employess
SELECT [FirstName]
FROM [Employees]
WHERE [DepartmentID] IN (3, 10) AND YEAR([HireDate]) BETWEEN 1995 AND 2005

--4.Find All Employees Except Engineers
SELECT [FirstName],
       [LastName]
FROM [Employees]
WHERE [JobTitle] NOT LIKE '%engineer%'

--5.Find Towns with Name Length
SELECT [Name]
FROM [Towns]
WHERE LEN([Name]) IN (5, 6)
ORDER BY [Name]

--6.Find Towns Starting With
SELECT [TownID],
       [Name]
FROM [Towns]
WHERE [Name] LIKE '[MKBE]%'
ORDER BY [Name]

--7.Find Towns Not Starting With
SELECT [TownID],
       [Name]
FROM [Towns]
WHERE [Name] NOT LIKE '[RBD]%'
ORDER BY [Name]

--8.Create View Employees Hired After
CREATE VIEW [V_EmployeesHiredAfter2000] AS
SELECT [FirstName],
	   [LastName]
FROM [Employees]
WHERE YEAR([HireDate]) > 2000

--9.Length of Last Name
SELECT [FirstName],
	   [LastName]
FROM [Employees]
WHERE LEN([LastName]) = 5

--10.Rank Employees by Salary
SELECT [EmployeeID],
	   [FirstName],
	   [LastName],
	   [Salary],
	   DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
FROM [Employees]
WHERE [Salary] BETWEEN 10000 AND 50000
ORDER BY [Salary] DESC

--11.Find All Employees with Rank 2
SELECT [EmployeeID],
	   [FirstName],
	   [LastName],
	   [Salary],
	   [Rank]
FROM (SELECT [EmployeeID],
	   [FirstName],
	   [LastName],
	   [Salary],
	   DENSE_RANK() OVER(PARTITION BY [Salary] ORDER BY [EmployeeID]) AS [Rank]
	   FROM [Employees]
	   WHERE [Salary] BETWEEN 10000 AND 50000)
	   AS [RankedEmployees]
WHERE [Rank] = 2
ORDER BY [Salary] DESC

--12.Countries Holding 'A'
SELECT [CountryName] AS [Country Name],
	   [IsoCode] AS [ISO Code]
FROM [Countries]
WHERE [CountryName] LIKE '%a%a%a%'
ORDER BY [ISO Code]

--13.Mix of Peak and River Names
SELECT [PeakName],
	   [RiverName],
	   LOWER(CONCAT([PeakName], RIGHT([RiverName], LEN([RiverName]) - 1))) AS [Mix]
FROM [Peaks], [Rivers]
WHERE RIGHT([PeakName], 1) = LEFT([RiverName], 1)
ORDER BY [Mix]

--14.Games From 2011 and 2012 Year
SELECT TOP 50 [Name],
			  CONVERT(CHAR(10), [Start], 126) AS [Start]
FROM [Games]
WHERE YEAR([Start]) BETWEEN 2011 AND 2012
ORDER BY [Start], [Name]

--15.User Email Providers
SELECT [Username],
	   SUBSTRING([Email], CHARINDEX('@', [Email]) + 1, LEN([Email])) AS [Email Provider]
FROM [Users]
ORDER BY [Email Provider], [Username]

--16.Get Users with IPAddress Like Pattern
SELECT [Username],
	   [IpAddress]
FROM [Users]
WHERE [IpAddress] LIKE '___.1%.%.___'
ORDER BY [Username]

--17.Show All Games with Duration
SELECT [Name] AS [Game],
	   CASE
	   WHEN DATEPART(HOUR, [Start]) BETWEEN 0 AND 11 THEN 'Morning'
	   WHEN DATEPART(HOUR, [Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	   WHEN DATEPART(HOUR, [Start]) BETWEEN 18 AND 23 THEN 'Evening'
	   END AS [Part of the Day],
	   CASE
	   WHEN [Duration] <= 3 THEN 'Extra Short'
	   WHEN [Duration] BETWEEN 4 AND 6 THEN 'Short'
	   WHEN [Duration] > 6 THEN 'Long'
	   WHEN [Duration] IS NULL THEN 'Extra Long'
	   END AS [Duration]
FROM [Games]
ORDER BY [Name], [Duration], [Part of the Day]

--18.Orders Table
SELECT [ProductName],
	   [OrderDate],
	   DATEADD(DAY, 3, [OrderDate]) AS [Pay Due],
	   DATEADD(MONTH, 1, [OrderDate]) AS [Deliver Due]
FROM [Orders]