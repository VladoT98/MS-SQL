--1.Create Database
CREATE DATABASE [Minions]

--2.Create Tables
CREATE TABLE [Minions](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL ,
	[Name] NVARCHAR(50) NOT NULL,
	[Age] INT
)

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[NAME] NVARCHAR(50) NOT NULL
)

--3.Alter Minions Table
ALTER TABLE [Minions]
ADD [TownId] INT FOREIGN KEY REFERENCES [Towns](Id)

--4.Insert Records in Both Tables
INSERT INTO [Towns]([Name]) VALUES
('Sofia'),
('Plovdiv'),
('Varna')

INSERT INTO [Minions]([Name], [Age], [TownId]) VALUES
('Kevin', 22, 1),
('Bob', 15, 3),
('Steward', NULL, 2)

--5.Truncate Table Minions(Delete all data in Minions table)
TRUNCATE TABLE [Minions]

--6.Drop All Tables
DROP TABLE [Minions], [Towns]

--7.Create Table People And Insert Values
CREATE TABLE [People](
	[Id] INT PRIMARY KEY IDENTITY  NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	[Picture] VARBINARY(MAX),
	[Height] DECIMAL(5, 2),
	[Weight] DECIMAL(5, 2),
	[Gender] BIT NOT NULL,
	[Birthdate] DATETIME2 NOT NULL,
	[Biography] NVARCHAR(MAX),
	CHECK(DATALENGTH([Picture]) <= 2097152)
)

INSERT INTO [People]([Name], [Picture], [Height], [Weight], [Gender], [Birthdate], [Biography]) VALUES
('Vlado', NULL, 1.84, 77, 1, '1998-11-24', NULL),
('Kati', NULL, 1.75, 50, 0, '1998-11-23', NULL),
('Dani', NULL, 1.84, 77, 1, '2001-03-13', NULL),
('Pesho', NULL, 1.84, 90, 1, '1976-08-15', NULL),
('Krasa', NULL, 1.67, 60, 0, '1967-11-22', NULL)

--8.Create Table Users And Insert Values
CREATE TABLE [Users](
	[Id] BIGINT PRIMARY KEY IDENTITY NOT NULL,
	[Username] VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	[ProfilePicture] VARBINARY(MAX),
	[LastLoginTime] DATETIME2,
	[IsDeleted] BIT,
	CHECK(DATALENGTH([ProfilePicture]) <= 921600)
)

INSERT INTO [Users]([Username], [Password], [ProfilePicture], [LastLoginTime], [IsDeleted]) VALUES
('vladiking', '12345', NULL, NULL, 1),
('daniking', '54321', NULL, NULL, 1),
('katiqueen', '00434', NULL, NULL, 1),
('peshoking', '41441', NULL, NULL, 1),
('krasaqueen', '52253', NULL, NULL, 1)

--9.Change Primary Key
ALTER TABLE [Users]
DROP CONSTRAINT [PK__Users__3214EC07929A83E0] --Removes primary key

ALTER TABLE [Users]
ADD CONSTRAINT [PK_UsersCompositeIdUsername] PRIMARY KEY ([Id], [Username]) --Adds composite primary key

--10.Add Check Constraint
ALTER TABLE [Users]
ADD CHECK(LEN([Password]) >= 5)

--11.Set Default Value of Field
ALTER TABLE [Users]
ADD DEFAULT SYSDATETIME() FOR [LastLoginTime]

--12.Set Unique Field
ALTER TABLE [Users]
DROP CONSTRAINT [PK_UsersCompositeIdUsername]

ALTER TABLE [Users]
ADD PRIMARY KEY (Id)

ALTER TABLE [Users]
ADD UNIQUE (Username)

ALTER TABLE [Users]
ADD CHECK(LEN([Username]) >= 3)

--13.Movies Database
CREATE DATABASE [Movies]

CREATE TABLE [Directors](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[DirectorName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Genres](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[GenreName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Categories](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[CategoryName] NVARCHAR(50) NOT NULL,
	[Notes] NVARCHAR(MAX)
)

CREATE TABLE [Movies](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Title] NVARCHAR(50) NOT NULL,
	[DirectorId] INT FOREIGN KEY REFERENCES [Directors]([Id]),
	[CopyrightYear] DATETIME2,
	[Length] TIME NOT NULL,
	[GenreId] INT FOREIGN KEY REFERENCES [Genres]([Id]) NOT NULL,
	[CategoryId] INT FOREIGN KEY REFERENCES [Categories]([Id]) NOT NULL,
	[Rating] DECIMAL(2, 1),
	[Notes] NVARCHAR(MAX)
)

INSERT INTO [Directors]([DirectorName], [Notes]) VALUES
('Vlado', NULL),
('Kati', NULL),
('Dani', NULL),
('Pesho', NULL),
('Krasa', NULL)

INSERT INTO [Genres]([GenreName], [Notes]) VALUES
('Action', NULL),
('Comedy', NULL),
('Drama', NULL),
('Horror', NULL),
('Thriller', NULL)

INSERT INTO [Categories]([CategoryName], [Notes]) VALUES
('Neznam', NULL),
('Edi kvo si', NULL),
('Da be da', NULL),
('Abe znam li', NULL),
('Nema losho', NULL)

INSERT INTO [Movies]([Title], [DirectorId], [CopyrightYear], [Length], [GenreId], [CategoryId], [Rating], [Notes]) VALUES
('Spider-man', NULL, NULL, '02:35:59', 1, 1, 6.0, NULL),
('King Kong', NULL, NULL, '04:35:33', 2, 1, 5.0, NULL),
('Shang Chi', NULL, NULL, '02:22:00', 3, 2, 4.5, NULL),
('Man of Steel', NULL, NULL, '03:35:44', 1, 3, 5.6, NULL),
('Hulk', NULL, NULL, '02:25:49', 1, 3, 5.7, NULL)

--16.Create SoftUni Database
CREATE DATABASE SoftUniTEST

CREATE TABLE [Towns](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Addresses](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[AddressText] NVARCHAR(100),
	[TownId] INT FOREIGN KEY REFERENCES [Towns]([Id]),
)

CREATE TABLE [Departments](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
)

CREATE TABLE [Employees](
	[Id] INT PRIMARY KEY IDENTITY NOT NULL,
	[FirstName] NVARCHAR(50) NOT NULL,
	[MiddleName] NVARCHAR(50) NOT NULL,
	[LastName] NVARCHAR(50) NOT NULL,
	[JobTitle] NVARCHAR(50) NOT NULL,
	[DepartmentId] INT FOREIGN KEY REFERENCES [Departments]([Id]) NOT NULL,
	[HireDate] DATE,
	[Salary] DECIMAL(6, 2),
	[AddressId] INT FOREIGN KEY REFERENCES [Addresses]([Id])
)

--18.Basic Insert
INSERT INTO [Towns]([Name]) VALUES 
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas')

INSERT INTO [Departments]([Name]) VALUES 
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance')

INSERT INTO [Employees]([FirstName], [MiddleName], [LastName], [JobTitle], [DepartmentId], [HireDate], [Salary]) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-01-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Teziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88)

--19.Basic Select All Fields
SELECT * FROM [Towns]
SELECT * FROM [Departments]
SELECT * FROM [Employees]

--20.Basic Select All Fields and Order Them
SELECT * FROM [Towns]
ORDER BY [Name]

SELECT * FROM [Departments]
ORDER BY [Name]

SELECT * FROM [Employees]
ORDER BY [Salary] DESC

--21.Basic Select Some Fields
SELECT [Name] 
FROM Towns
ORDER BY [Name]

SELECT [Name]
FROM [Departments]
ORDER BY [Name]

SELECT [FirstName],
	   [LastName],
	   [JobTitle],
	   [Salary]
FROM [Employees]
ORDER BY [Salary] DESC

--22.Increase Employees Salary
UPDATE [Employees]
SET [Salary] = [Salary] * 1.1

SELECT [Salary]
FROM [Employees]