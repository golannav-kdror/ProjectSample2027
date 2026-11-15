-- =============================================
-- 1. הזנת נתונים לטבלאות העזר (Lookup Tables)
-- =============================================

-- ערים (CityTBL - IDENTITY)
INSERT INTO [dbo].[CityTBL] ([CityName]) VALUES 
(N'תל אביב - יפו'),
(N'ירושלים'),
(N'חיפה'),
(N'ראשון לציון'),
(N'באר שבע');
GO

-- שנים אקדמיות (AcademicYearTBL - IDENTITY)
INSERT INTO [dbo].[AcademicYearTBL] ([AcademicYear]) VALUES 
(N'2020-2021'),
(N'2021-2022'),
(N'2022-2023'),
(N'2023-2024'),
(N'2024-2025'),
(N'2025-2026'),
(N'2026-2027');
GO

-- סמסטרים (SemesterTBL - ללא IDENTITY, הזנת ID ידנית)
INSERT INTO [dbo].[SemesterTBL] ([Id], [SemesterName]) VALUES 
(1, N'Fall Semester (סמסטר סתיו)'),
(2, N'Winter Semester (סמסטר חורף)'),
(3, N'Summer Semester (סמסטר קיץ)');
GO

-- סמסטרים בשנה אקדמית (SemesterInAYearTBL - IDENTITY)
-- לדוגמה: שנת 2026-2027 (YearId = 7)
INSERT INTO [dbo].[SemesterInAYearTBL] ([SemesterId], [YearId]) VALUES 
(1, 7), -- סתיו 2026-2027 (Id = 1)
(2, 7), -- חורף 2026-2027 (Id = 2)
(3, 7); -- קיץ 2026-2027 (Id = 3)
GO

-- תפקידים במערכת (RoleTBL - ללא IDENTITY, הזנת ID ידנית)
INSERT INTO [dbo].[RoleTBL] ([Id], [RoleName]) VALUES 
(1, N'Admin'),
(2, N'Teacher'),
(3, N'Student');
GO

-- תארים אקדמיים (DegreeTBL - IDENTITY)
INSERT INTO [dbo].[DegreeTBL] ([DegreeName]) VALUES 
(N'B.A. (Bachelor of Arts)'),
(N'B.Sc. (Bachelor of Science)'),
(N'M.A. (Master of Arts)'),
(N'M.Sc. (Master of Science)'),
(N'Ph.D. (Doctor of Philosophy)');
GO

-- דרגות אקדמיות (AcademicRankTBL - IDENTITY)
INSERT INTO [dbo].[AcademicRankTBL] ([RankName]) VALUES 
(N'Lecturer'),
(N'Senior Lecturer'),
(N'Associate Professor'),
(N'Professor'),
(N'Emeritus Professor');
GO

-- סטטוס סטודנט (StudentStatusTBL - ללא IDENTITY, הזנת ID ידנית)
INSERT INTO [dbo].[StudentStatusTBL] ([Id], [StatusName]) VALUES 
(1, N'Candidate'),
(2, N'Active'),
(3, N'Graduate'),
(4, N'Suspended');
GO

-- קורסים (CourseTBL - IDENTITY)
INSERT INTO [dbo].[CourseTBL] ([CourseName], [Description], [Credits]) VALUES 
(N'מבוא למדעי המחשב', N'יסודות התכנות, אלגוריתמים ומבני נתונים בסיסיים.', 5),
(N'מסדי נתונים רלציוניים', N'תכנון מסדי נתונים, נרמול ושפת SQL.', 4),
(N'פיתוח צד שרת (Web API)', N'בניית שירותי REST מאובטחים ומחוברים למסד נתונים.', 4);
GO

-- =============================================
-- 2. הזנת אנשים, מרצים, סטודנטים ומשתמשים
-- =============================================

-- אנשים (PersonTBL - IDENTITY)
-- Id 1: מנהל מערכת
-- Id 2: מרצה
-- Id 3: סטודנט מן המניין
-- Id 4: סטודנט מועמד (ללא מיקוד - לבדיקת NULL)
INSERT INTO [dbo].[PersonTBL] ([FirstName], [LastName], [CityId], [Phone], [Birthday], [Street], [HouseNumber], [ZipCode]) VALUES 
(N'אבי', N'כהן', 1, N'050-1111111', '1980-05-15', N'הרצל', 10, '6511101'),
(N'דנה', N'לוי', 2, N'052-2222222', '1978-11-20', N'יפו', 45, '9414201'),
(N'עומר', N'מזרחי', 3, N'054-3333333', '2001-03-10', N'הנשיא', 12, '3464201'),
(N'נועה', N'גולן', 4, N'053-4444444', '2002-08-25', N'רוטשילד', 8, NULL);
GO

-- מרצים (TeacherTBL - מקושר ל-PersonId = 2)
INSERT INTO [dbo].[TeacherTBL] ([Id], [HireDate], [AcademicRankId]) VALUES 
(2, '2018-09-01', 3); -- דנה לוי, Associate Professor
GO

-- סטודנטים (StudentTBL - מקושר ל-PersonId = 3 ו-4)
INSERT INTO [dbo].[StudentTBL] ([Id], [LearnToDegreeId], [StudentStatusId]) VALUES 
(3, 2, 2), -- עומר מזרחי, B.Sc., סטטוס 2 (Active - מן המניין)
(4, 1, 1); -- נועה גולן, B.A., סטטוס 1 (Candidate - מועמדת)
GO

-- משתמשי התחברות למערכת (UserTBL - IDENTITY)
-- הערה: PasswordHash מכיל כאן מחרוזת דמה לצורך תרגול ראשוני
INSERT INTO [dbo].[UserTBL] ([Username], [PasswordHash], [Role], [PersonId], [IsActive]) VALUES 
(N'admin_avi', N'hashed_pass_123', 1, 1, 1),   -- מנהל (אבי כהן)
(N'prof_dana', N'hashed_pass_456', 2, 2, 1),   -- מרצה (דנה לוי)
(N'stud_omer', N'hashed_pass_789', 3, 3, 1),   -- סטודנט (עומר מזרחי)
(N'stud_noa',  N'hashed_pass_000', 3, 4, 1);   -- סטודנטית מועמדת (נועה גולן)
GO

-- =============================================
-- 3. רישום לשיעורים וציונים (LessonTBL)
-- =============================================

-- רישום עומר מזרחי (StudentId = 3) לקורסים אצל דנה לוי (TeacherId = 2)
INSERT INTO [dbo].[LessonTBL] ([StudentId], [TeacherId], [CourseId], [Grade], [SemesterInAYearId]) VALUES 
(3, 2, 1, 92, 1),   -- קורס 1 בסמסטר סתיו (Id = 1) עם ציון סופי 92
(3, 2, 2, NULL, 2); -- קורס 2 בסמסטר חורף (Id = 2) - נרשם עכשיו, עדיין ללא ציון (NULL)
GO
