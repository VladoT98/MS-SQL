--1.Employee Address
SELECT TOP 5 e.[EmployeeID],
	   e.[JobTitle],
	   e.[AddressID],
	   a.[AddressText]
FROM [Employees] AS e
JOIN [Addresses] AS a ON e.[AddressID] = a.[AddressID]
ORDER BY e.[AddressID]

--2.Addresses with Towns
SELECT TOP 50 e.[FirstName],
			  e.[LastName],
			  t.[Name] AS [Town],
			  a.[AddressText]
FROM [Employees] AS e
JOIN [Addresses] AS a ON e.[AddressID] = a.[AddressID]
JOIN [Towns] AS t ON a.[TownID] = t.[TownID]
ORDER BY e.[FirstName], e.[LastName]

--3.Sales Employees
SELECT [EmployeeID],
	   [FirstName],
	   [LastName],
	   d.[Name] AS [DepartmentName]
FROM [Employees] AS e
JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE d.[Name] = 'Sales'
ORDER BY [EmployeeID]

--4.Employee Departments
SELECT TOP 5 [EmployeeID],
			 [FirstName],
		     [Salary],
			 d.[Name] AS [DepartmentName]
FROM [Employees] AS e
JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE [Salary] > 15000
ORDER BY e.[DepartmentID]

--5.Employees Without Projects
SELECT TOP 3 e.[EmployeeID],
		     [FirstName]
FROM [Employees] AS e
LEFT JOIN [EmployeesProjects] AS ep ON e.EmployeeID = ep.[EmployeeID]
WHERE ep.EmployeeID IS NULL
ORDER BY e.[EmployeeID]

--6.Employees Hired After
SELECT [FirstName],
	   [LastName],
	   [HireDate],
	   d.[Name] AS [DeptName]
FROM [Employees] AS e
JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
WHERE [HireDate] > '1.1.1999' AND d.[Name] IN ('Sales', 'Finance')
ORDER BY [HireDate]

--7.Employees With Project
SELECT TOP 5 e.[EmployeeID],
		     e.[FirstName],
			 p.[Name] AS [ProjectName]
FROM [Employees] AS e
JOIN [EmployeesProjects] AS ep ON e.[EmployeeID] = ep.[EmployeeID]
JOIN [Projects] AS p ON ep.[ProjectID] = p.[ProjectID]
WHERE p.[EndDate] IS NULL AND p.[StartDate] > '8.13.1999'
ORDER BY e.[EmployeeID]


--8.Employee 24
SELECT e.[EmployeeID],
	   e.[FirstName],
	   CASE
	   WHEN YEAR(p.[StartDate]) >= 2005 THEN NULL
	   ELSE p.[Name] 
	   END AS [ProjectName]
FROM [Employees] AS e
JOIN [EmployeesProjects] AS ep ON e.[EmployeeID] = ep.[EmployeeID]
JOIN [Projects] AS p ON ep.[ProjectID] = p.[ProjectID]
WHERE ep.[EmployeeID] = 24

--9.Employee Manager
SELECT e.[EmployeeID],
	   e.[FirstName],
	   e.[ManagerID],
	   m.[FirstName] AS [ManagerName]
FROM [Employees] AS e
JOIN [Employees] AS m ON e.[ManagerID] = m.[EmployeeID]
WHERE e.[ManagerID] IN (3, 7)
ORDER BY e.[EmployeeID]

--10.Employees Summary
SELECT TOP 50 e.[EmployeeID],
			  CONCAT(e.[FirstName], ' ', e.[LastName]) AS [EmployeeName],
			  CONCAT(m.[FirstName], ' ', m.[LastName]) AS [ManagerName],
			  d.[Name] AS [DepartmentName]
FROM [Employees] AS e
JOIN [Employees] AS m ON e.[ManagerID] = m.[EmployeeID]
JOIN [Departments] AS d ON e.[DepartmentID] = d.[DepartmentID]
ORDER BY e.[EmployeeID]

--11.Min Average Salary
SELECT MIN([AvgSalary]) AS [MinAverageSalary]
FROM (SELECT AVG([Salary]) AS [AvgSalary]
	  FROM [Employees]
	  GROUP BY [DepartmentID]) AS [AvgSalarySubQuery]

--12.Highest Peaks in Bulgaria
SELECT c.[CountryCode],
	   m.[MountainRange],
	   p.[PeakName],
	   p.[Elevation]
FROM [Countries] AS c
JOIN [MountainsCountries] AS mc ON c.[CountryCode] = mc.CountryCode
JOIN [Mountains] AS m ON mc.[MountainId] = m.[Id]
JOIN [Peaks] AS p ON m.[Id] = p.[MountainId]
WHERE mc.[CountryCode] = 'BG' AND p.[Elevation] > 2835
ORDER BY p.[Elevation] DESC

--13.Count Mountain Ranges
SELECT c.[CountryCode],
	   COUNT(m.[Id])
FROM [Countries] AS c
JOIN [MountainsCountries] AS mc ON c.[CountryCode] = mc.CountryCode
JOIN [Mountains] AS m ON mc.[MountainId] = m.[Id]
WHERE mc.[CountryCode] IN ('BG', 'RU', 'US')
GROUP BY c.CountryCode

--14.Countries with Rivers
SELECT TOP 5 c.[CountryName],
		     r.[RiverName]   
FROM [Countries] AS c
LEFT JOIN [CountriesRivers] AS cr ON c.[CountryCode] = cr.CountryCode
LEFT JOIN [Rivers] AS r ON cr.[RiverId] = r.[Id]
WHERE c.ContinentCode = 'AF'
ORDER BY c.[CountryName]

--15.Continents and Currencies
SELECT [ContinentCode],
	   [CurrencyCode],
	   [CurrencyCount] AS [CurrencyUsage]
FROM (SELECT *,
			 DENSE_RANK() OVER(PARTITION BY [ContinentCode] ORDER BY [CurrencyCount] DESC) AS [RankedCurrencies]
	  FROM (SELECT [ContinentCode],
				   [CurrencyCode],
				   COUNT(CurrencyCode) AS [CurrencyCount]
		    FROM [Countries]
			GROUP BY [CurrencyCode], [ContinentCode]) AS [CurrencyUsageSubQuery]
	  WHERE [CurrencyCount] > 1 ) AS [RankedCurrensiesSubQuery]
WHERE [RankedCurrencies] = 1
ORDER BY [ContinentCode]

--16.Highest Peak and Longest River by Country
SELECT TOP 5 c.[CountryName],
			 MAX(p.Elevation) AS [HighestPeakElevation],
			 MAX(r.[Length]) AS [LongestRiverLength]
FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS mc ON c.CountryCode = mc.[CountryCode]
LEFT JOIN [Mountains]          AS m  ON mc.[MountainId] = m.[Id]
LEFT JOIN [Peaks]              AS p  ON m.[Id] = p.[MountainId]
LEFT JOIN [CountriesRivers]    AS cr ON c.[CountryCode] = cr.[CountryCode]
LEFT JOIN [Rivers]             AS r  ON cr.[RiverId] = r.[Id]
GROUP BY c.[CountryName]
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, [CountryName]

--17.Highest Peak Name and Elevation by Country
SELECT TOP 5 c.[CountryName] AS [Country],
		     CASE WHEN p.[PeakName] IS NULL THEN '(no highest peak)'
			 ELSE p.[PeakName] END AS [Highest Peak Name],
			 CASE WHEN MAX(p.Elevation) IS NULL THEN 0
			 ELSE MAX(p.Elevation) END AS [Highest Peak Elevation],
			 CASE WHEN m.[MountainRange] IS NULL THEN '(no mountain)'
			 ELSE m.[MountainRange] END AS [Mountain]
FROM [Countries] AS c
LEFT JOIN [MountainsCountries] AS mc ON c.CountryCode = mc.[CountryCode]
LEFT JOIN [Mountains] AS m ON mc.[MountainId] = m.[Id]
LEFT JOIN [Peaks] AS p ON m.[Id] = p.[MountainId]
GROUP BY c.[CountryName], p.[PeakName], m.[MountainRange]
ORDER BY c.[CountryName], [Highest Peak Name]