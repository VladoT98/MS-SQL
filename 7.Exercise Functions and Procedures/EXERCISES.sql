USE SoftUni
GO
--1.Employees with Salary Above 35000
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
BEGIN
	SELECT FirstName AS [First Name],
	       LastName  AS [Last Name]
	FROM Employees
	WHERE Salary > 35000
END
EXEC usp_GetEmployeesSalaryAbove35000
GO

--2.Employees with Salary Above Number
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber(@salary DECIMAL(18,4))
AS
BEGIN
	SELECT *
	FROM Employees
	WHERE Salary >= @salary
END
EXEC usp_GetEmployeesSalaryAboveNumber 48100
GO

--3.Town Names Starting With
CREATE PROCEDURE usp_GetTownsStartingWith(@startsWith CHAR)
AS
BEGIN
	SELECT [Name] AS Town
	FROM Towns
	WHERE [Name] LIKE @startsWith + '%'
END
EXEC usp_GetTownsStartingWith 'b'
GO

--4.Employees from Town
CREATE PROCEDURE usp_GetEmployeesFromTown(@townName VARCHAR(50))
AS
BEGIN
	SELECT e.FirstName AS [First Name],
		   e.LastName  AS [Last Name]
	FROM Employees e
	JOIN Addresses a ON e.AddressID = a.AddressID
	JOIN Towns     t ON a.TownID = t.TownID
	WHERE t.[Name] = @townName
END
EXEC usp_GetEmployeesFromTown  'Sofia'
GO

--5.Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(7)
AS
BEGIN
	DECLARE @result VARCHAR(7)

	IF (@salary < 30000)                      SET @result = 'Low'
	ELSE IF (@salary BETWEEN 30000 AND 50000) SET @result = 'Average'
	ELSE IF (@salary > 50000)                 SET @result = 'High'
	
	RETURN @result
END
GO
SELECT Salary, 
       dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
FROM Employees
GO

--6.Employees by Salary Level
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@salaryLevel VARCHAR(7))
AS
BEGIN
	SELECT FirstName AS [First Name],
		   LastName  AS [Last Name]
	FROM Employees
	WHERE dbo.ufn_GetSalaryLevel(Salary) = @salaryLevel
END
EXEC usp_EmployeesBySalaryLevel 'High'
GO

--7.Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(MAX), @word VARCHAR(MAX)) 
RETURNS BIT
AS
BEGIN
	DECLARE @result BIT = 1
	DECLARE @wordCurrentIndex INT = 1
	DECLARE @wordCurrentLetter CHAR = LEFT(@word, 1)

	WHILE(@wordCurrentIndex <= LEN(@word))
	BEGIN
		IF(CHARINDEX(@setOfLetters, @wordCurrentLetter) = 0) 
		BEGIN
			SET @result = 0
			BREAK
		END

		SET @wordCurrentIndex += 1
		SET @wordCurrentLetter = LEFT(@word, @wordCurrentIndex)
	END

	RETURN @result
END
GO

--8.Delete Employees and Departments
CREATE PROCEDURE usp_DeleteEmployeesFromDepartment(@departmentId INT)
AS
BEGIN
	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (SELECT EmployeeID
						 FROM Employees
						 WHERE DepartmentID = @departmentId)

    UPDATE [Employees]
	SET [ManagerID] = NULL
	WHERE [ManagerID] IN (SELECT [EmployeeID]
						  FROM [Employees]
						  WHERE [DepartmentID] = @departmentId)

    ALTER TABLE Departments
	ALTER COLUMN ManagerId INT NULL

	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (SELECT ManagerID
						FROM Employees
						WHERE DepartmentID = @departmentId)

	DELETE FROM Employees
	WHERE DepartmentID = @departmentId

	DELETE FROM Departments
	WHERE DepartmentID = @departmentId

	SELECT COUNT(*) AS EmployeesInGivenDepartment
	FROM Employees
	WHERE DepartmentID = @departmentId
END
EXEC usp_DeleteEmployeesFromDepartment 1
GO

USE Diablo
GO
--9.Scalar Function: Cash in User Games Odd Rows
CREATE FUNCTION ufn_CashInUsersGames(@gameName VARCHAR(MAX))
RETURNS TABLE
AS
RETURN
SELECT SUM(Cash) AS SumCash
FROM (SELECT ROW_NUMBER() OVER(ORDER BY ug.Cash DESC) AS RowNumber,
		     ug.Cash
	  FROM UsersGames ug
	  JOIN Games g ON ug.GameId = g.Id
	  WHERE g.Name = @gameName) RowNumberSubQuery
WHERE RowNumber % 2 != 0
SELECT * FROM dbo.ufn_CashInUsersGames('Love in a mist')