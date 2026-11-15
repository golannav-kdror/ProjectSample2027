-- Create Table Query for CityTBL
CREATE TABLE [dbo].[CityTBL] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [CityName] NVARCHAR (50) NULL,
    CONSTRAINT [PK_CityTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for [AcademicYearTBL]
-- 1 - 2020-2021
-- 2 - 2021-2022
-- 3 - 2022-2023
-- 4 - 2023-2024
-- 5 - 2024-2025
-- 6 - 2025-2026
-- 7 - 2026-2027
CREATE TABLE [dbo].[AcademicYearTBL] (
    [Id]           INT        IDENTITY (1, 1) NOT NULL,
    [AcademicYear] NVARCHAR(10) NOT NULL,
    CONSTRAINT [PK_AcademicYearTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for [SemesterTBL]
-- 1 - Fall Semester (סמסטר סתיו)
-- 2 - Winter Semester (סמסטר חורף)
-- 3 - Summer Semester (סמסטר קיץ)
CREATE TABLE [dbo].[SemesterTBL] (
    [Id]           INT           NOT NULL,
    [SemesterName] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_SemesterTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for [SemesterInAYearTBL]
CREATE TABLE [dbo].[SemesterInAYearTBL] (
    [Id]         INT IDENTITY (1, 1) NOT NULL,
    [SemesterId] INT NOT NULL,
    [YearId]     INT NOT NULL,
    CONSTRAINT [PK_SemesterInAYearTBL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_SemesterInAYearTBL] UNIQUE NONCLUSTERED ([SemesterId] ASC, [YearId] ASC),
    CONSTRAINT [FK_SemesterInAYearTBL_SemesterId] FOREIGN KEY ([SemesterId]) REFERENCES [dbo].[SemesterTBL] ([Id]),
    CONSTRAINT [FK_SemesterInAYearTBL_YearId] FOREIGN KEY ([YearId]) REFERENCES [dbo].[AcademicYearTBL] ([Id])
);
GO

-- Create Table Query for [[CourseTBL]]
CREATE TABLE [dbo].[CourseTBL] (
    [Id] INT IDENTITY (1, 1) NOT NULL,
    [CourseName]  NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (MAX) NOT NULL,
    [Credits]     INT            NOT NULL,
    CONSTRAINT [PK_CourseTBL] PRIMARY KEY CLUSTERED ([Id] ASC)  
);
GO

-- Create Table Query for [RoleTBL]
-- 1- Admin (Administrator)
-- 2- Teacher (Teacher)
-- 3- Student (Student)
CREATE TABLE [dbo].[RoleTBL] (
    [Id]       INT        NOT NULL,
    [RoleName] NVARCHAR (13) NULL,
    CONSTRAINT [PK_RoleTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for [DegreeTBL]
-- 1 - B.A. (Bachelor of Arts)
-- 2 - B.Sc. (Bachelor of Science)
-- 3 - M.A. (Master of Arts)
-- 4 - M.Sc. (Master of Science)
-- 5 - Ph.D. (Doctor of Philosophy)
-- 6 - M.B.A. (Master of Business Administration)
-- 7 - LL.B. (Bachelor of Laws)
-- 8 - LL.M. (Master of Laws)
-- 9 - M.D. (Doctor of Medicine)
-- 10 - Professional Degree (e.g., J.D., D.D.S., D.V.M.)
CREATE TABLE [dbo].[DegreeTBL] (
    [Id]  INT  IDENTITY (1, 1) NOT NULL,
    [DegreeName] NVARCHAR (50) NOT NULL,
    CONSTRAINT [PK_DegreeTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for [AcademicRankTBL]
-- 1 - Lecturer
-- 2 - Senior Lecturer
-- 3 - Associate Professor
-- 4 - Professor
-- 5 - Emeritus Professor
CREATE TABLE [dbo].[AcademicRankTBL] (
    [Id]       INT           IDENTITY (1, 1) NOT NULL,
    [RankName] NVARCHAR (50) NOT NULL,    
    CONSTRAINT [PK_AcademicRankTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for [StudentStatusTBL]
-- 1 - Candidate (מועמד)
-- 2 - Active / Enrolled (מן המניין)
-- 3 - Graduate (בוגר)
-- 4 - Suspended / Dropped (הפסקת לימודים)
CREATE TABLE [dbo].[StudentStatusTBL] (
    [Id]         INT           NOT NULL,
    [StatusName] NVARCHAR (30) NOT NULL,
    CONSTRAINT [PK_StudentStatusTBL] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO

-- Create Table Query for PersonTBL
CREATE TABLE [dbo].[PersonTBL] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [FirstName]     NVARCHAR (50)  NOT NULL,
    [LastName]      NVARCHAR (50)  NOT NULL,
    [CityId]        INT            NOT NULL,
    [Phone]         NVARCHAR (255) NOT NULL,
    [Birthday]      DATE           NOT NULL,
    [CreateAt]      DATETIME       DEFAULT (sysdatetime()) NOT NULL,
    [PhotoFileName] NVARCHAR (255) DEFAULT ('DefaultImg.png') NOT NULL,
    [Street]        NVARCHAR (50)  NOT NULL, 
    [HouseNumber]   INT            NOT NULL, 
    [ZipCode]       NVARCHAR (7)   NULL, 
    CONSTRAINT [PK_PersonTBL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_PersonTBL_CityTBL] FOREIGN KEY ([CityId]) REFERENCES [dbo].[CityTBL] ([Id]),
    CONSTRAINT [CK_PersonTBL_ZipCode] CHECK ([ZipCode] IS NULL OR (LEN([ZipCode]) = 7 AND [ZipCode] NOT LIKE '%[^0-9]%'))
);
GO

-- Create Table Query for StudentTBL
CREATE TABLE [dbo].[StudentTBL] (
    [Id] INT NOT NULL,
    [LearnToDegreeId]  INT  NOT NULL,
    [StudentStatusId] INT  DEFAULT (1) NOT NULL, -- Default value is 1 (Candidate),
    [RegistrationDate] DATE DEFAULT (GETDATE()) NOT NULL,
    CONSTRAINT [PK_StudentTBL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_StudentTBL_PersonTBL] FOREIGN KEY ([Id]) REFERENCES [dbo].[PersonTBL] ([Id]),
    CONSTRAINT [FK_StudentTBL_DegreeTBL] FOREIGN KEY ([LearnToDegreeId]) REFERENCES [dbo].[DegreeTBL] ([Id]),
    CONSTRAINT [FK_StudentTBL_StudentStatusTBL] FOREIGN KEY ([StudentStatusId]) REFERENCES [dbo].[StudentStatusTBL] ([Id])
);
GO

-- Create Table Query for TeacherTBL
CREATE TABLE [dbo].[TeacherTBL] (
    
    [Id] INT NOT NULL,
    [HireDate] DATE DEFAULT (GETDATE()) NOT NULL,
    [AcademicRankId] INT NOT NULL,
    CONSTRAINT [PK_TeacherTBL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_TeacherTBL_PersonTBL] FOREIGN KEY ([Id]) REFERENCES [dbo].[PersonTBL] ([Id]),
    CONSTRAINT [FK_TeacherTBL_AcademicRankTBL] FOREIGN KEY ([AcademicRankId]) REFERENCES [dbo].[AcademicRankTBL] ([Id])
);
GO

--Create Table Query for UserTBL
CREATE TABLE [dbo].[UserTBL] (
    [Id]           INT            IDENTITY (1, 1) NOT NULL,
    [Username]     NVARCHAR (50)  NOT NULL,
    [PasswordHash] NVARCHAR (255) NOT NULL,
    [Role]         INT            NOT NULL,
    [PersonId]     INT            NOT NULL,
    [IsActive]     BIT            DEFAULT ((1)) NOT NULL, -- Default value is 1 (Active)
    CONSTRAINT [PK_UserTBL] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [UQ_UserTBL_PersonId] UNIQUE NONCLUSTERED ([PersonId] ASC),
    CONSTRAINT [UQ_UserTBL_Username] UNIQUE NONCLUSTERED ([Username] ASC),
    CONSTRAINT [FK_UserTBL_RoleTBL] FOREIGN KEY ([Role]) REFERENCES [dbo].[RoleTBL] ([Id]),
    CONSTRAINT [FK_UserTBL_PersonTBL] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[PersonTBL] ([Id])
);
GO

--Create Table Query for LessonTBL
CREATE TABLE [dbo].[LessonTBL] (
    [ID]      INT      IDENTITY (1, 1) NOT NULL,
    [StudentId] INT      NOT NULL,
    [TeacherId] INT      NOT NULL,
    [CourseId]  INT      NOT NULL,
    [Grade]   SMALLINT  NULL,
    [SemesterInAYearId] INT NOT NULL, 
	CONSTRAINT [PK_LessonTBL] PRIMARY KEY CLUSTERED ([ID] ASC),
    CONSTRAINT [CK_LessonTBL_Grade] CHECK ([Grade] IS NULL OR ([Grade] >= 0 AND [Grade] <= 100)),
    CONSTRAINT [UQ_LessonTBL_StudentRegistration] UNIQUE ([StudentId], [TeacherId], [CourseId], [SemesterInAYearId]),
    CONSTRAINT [FK_LessonTBL_StudentTBL] FOREIGN KEY ([StudentId]) REFERENCES [dbo].[StudentTBL] ([ID]),
    CONSTRAINT [FK_LessonTBL_TeacherTBL] FOREIGN KEY ([TeacherId]) REFERENCES [dbo].[TeacherTBL] ([ID]),
    CONSTRAINT [FK_LessonTBL_CourseTBL] FOREIGN KEY ([CourseId]) REFERENCES [dbo].[CourseTBL] ([ID]),
    CONSTRAINT [FK_LessonTBL_SemesterInAYearTBL] FOREIGN KEY ([SemesterInAYearId]) REFERENCES [dbo].[SemesterInAYearTBL] ([Id])
);
GO

