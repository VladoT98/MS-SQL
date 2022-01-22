--1.One-To-One Relationship
CREATE DATABASE [Relations]

CREATE TABLE [Passports](
	[PassportID] INT PRIMARY KEY NOT NULL,
	[PassportNumber] CHAR(8) NOT NULL
)

CREATE TABLE [Persons](
	[PersonID] INT NOT NULL,
	[FirstName] VARCHAR(50) NOT NULL,
	[Salary] DECIMAL(8, 2),
	[PassportID] INT NOT NULL
)

INSERT INTO [Passports]([PassportID], [PassportNumber]) VALUES
(101, 'N34FG21B'),
(102, 'K65LO4R7'),
(103, 'ZE657QP2')

INSERT INTO [Persons]([PersonID], [FirstName], [Salary], [PassportID]) VALUES
(1, 'Roberto', 43300.00, 102),
(2, 'Tom', 56100.00, 103),
(3, 'Yana', 60200.00, 101)

ALTER TABLE [Persons]
ADD PRIMARY KEY ([PersonID])

ALTER TABLE [Persons]
ADD FOREIGN KEY ([PassportID]) REFERENCES [Passports]([PassportID])

--2.One-To-Many Relationship
CREATE TABLE [Manufacturers](
	[ManufacturerID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(5) NOT NULL,
	[EstablishedOn] DATE
)

CREATE TABLE [Models](
	[ModelID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
	[Name] VARCHAR(7) NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers]([ManufacturerID])
)

INSERT INTO [Manufacturers]([Name], [EstablishedOn]) VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01')

INSERT INTO [Models]([Name], [ManufacturerID]) VALUES
('X1', 1),
('i6', 1),
('Model S', 2),
('Model X', 2),
('Model 3', 2),
('Nova', 3)

--3.Many-To-Many Relationship
CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(4) NOT NULL
)

CREATE TABLE [Exams](
	[ExamID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(10) NOT NULL
)

CREATE TABLE [StudentsExams](
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]) NOT NULL,
	[ExamID] INT FOREIGN KEY REFERENCES [Exams]([ExamID]) NOT NULL
	PRIMARY KEY(StudentID, ExamID)
)

--4.Self-Referencing
CREATE TABLE [Teachers](
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1) NOT NULL,
	[Name] VARCHAR(6) NOT NULL,
	[ManagerID] INT FOREIGN KEY REFERENCES [Teachers]([TeacherID]) NOT NULL
)

--5.Online Store Database
CREATE DATABASE [Store]

CREATE TABLE [ItemTypes](
	[ItemTypeID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Items](
	[ItemID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes]([ItemTypeID])
)

CREATE TABLE [Cities](
	[CityID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
)

CREATE TABLE [Customers](
	[CustomerID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL,
	[Birthday] DATE,
	[CityID] INT FOREIGN KEY REFERENCES [Cities]([CityID])
)

CREATE TABLE [Orders](
	[OrderID] INT PRIMARY KEY IDENTITY NOT NULL,
	[CustomerID] INT FOREIGN KEY REFERENCES [Customers]([CustomerID])
)

CREATE TABLE [OrderItems](
	[OrderID] INT FOREIGN KEY REFERENCES [Orders]([OrderID]) NOT NULL,
	[ItemID] INT FOREIGN KEY REFERENCES [Items]([ItemID]) NOT NULL
	PRIMARY KEY([OrderID], [ItemID])
)

--6.University Database
CREATE DATABASE [University]

CREATE TABLE [Subjects](
	[SubjectID] INT PRIMARY KEY IDENTITY NOT NULL,
	[SubjectName] VARCHAR(50)
)

CREATE TABLE [Majors](
	[MajorID] INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students](
	[StudentID] INT PRIMARY KEY IDENTITY NOT NULL,
	[StudentNumber] VARCHAR(10) NOT NULL,
	[StudentName] VARCHAR(50) NOT NULL,
	[MajorID] INT FOREIGN KEY REFERENCES [Majors]([MajorID])
)

CREATE TABLE [Agenda](
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID]),
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects]([SubjectID]),
	PRIMARY KEY([StudentID], [SubjectID])
)

CREATE TABLE [Payments](
	[PaymentID] INT PRIMARY KEY IDENTITY NOT NULL,
	[PaymentDate] DATETIME2,
	[PaymentAmount] DECIMAL(8, 2),
	[StudentID] INT FOREIGN KEY REFERENCES [Students]([StudentID])
)

--9.Peaks in Rila   
SELECT [MountainRange],
	   [PeakName],
	   [Elevation]
FROM [Peaks]
JOIN [Mountains] ON [MountainId] = [Mountains].[Id]
WHERE [MountainRange] = 'Rila'
ORDER BY [Elevation] DESC
