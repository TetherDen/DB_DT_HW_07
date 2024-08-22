use Academy;

--1. Вивести назви аудиторій, де читає лекції викладач “Edward
--Hopper”.

SELECT LectureRooms.Name FROM LectureRooms
JOIN Schedules ON Schedules.LectureRoomId = LectureRooms.Id
JOIN Lectures ON Lectures.Id = Schedules.LectureId
JOIN Teachers ON Lectures.TeacherId = Teachers.Id
WHERE Teachers.Name = 'Mary' AND Teachers.Surname = 'Shelley';
GO

--2. Вивести прізвища асистентів, які читають лекції у групі
--“F505”.

SELECT DISTINCT Teachers.Surname FROM Teachers
JOIN Assistants ON Assistants.TeacherId = Teachers.Id
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN Groups ON Groups.Id = GroupsLectures.GroupId
WHERE Groups.Name = 'F505'
GO

--3. Вивести дисципліни, які читає викладач “Alex Carmack”
--для груп 5 курсу

SELECT DISTINCT Subjects.Name FROM Subjects
JOIN Lectures ON Lectures.SubjectId = Subjects.Id
JOIN Teachers ON Teachers.Id = Lectures.TeacherId
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN Groups ON Groups.Id = GroupsLectures.GroupId
WHERE Teachers.Name = 'Alex' AND Teachers.Surname ='Carmack' AND Groups.Year = 5;
GO

--4. Вивести прізвища викладачів, які не читають лекції у понеділок.

SELECT DISTINCT Teachers.Surname FROM Teachers
WHERE Teachers.Id NOT IN (
    SELECT DISTINCT Lectures.TeacherId FROM Lectures
    JOIN Schedules ON Schedules.LectureId = Lectures.Id
    WHERE Schedules.DayOfWeek=1
);
GO

--5. Вивести назви аудиторій, із зазначенням їх корпусів, у яких
--немає лекцій у середу другого тижня на третій парі.

SELECT DISTINCT LectureRooms.Name, LectureRooms.Building FROM LectureRooms
WHERE LectureRooms.Id NOT IN (
SELECT DISTINCT LectureRooms.Id FROM LectureRooms
JOIN Schedules ON Schedules.LectureRoomId = LectureRooms.Id
WHERE Schedules.DayOfWeek = 3 AND Schedules.Week = 2
);
GO

--6. Вивести повні імена викладачів факультету “Computer Science”,
--які не курирують групи кафедри “Software Development”.

SELECT Teachers.Name,Teachers.Surname FROM Teachers
JOIN Lectures ON Lectures.TeacherId = Teachers.Id
JOIN GroupsLectures ON GroupsLectures.LectureId = Lectures.Id
JOIN Groups ON Groups.Id = GroupsLectures.GroupId
JOIN Departments ON Groups.DepartmentId = Departments.Id
JOIN Faculties ON Departments.FacultyId = Faculties.Id
WHERE Faculties.Name = 'Computer Science' 
AND Departments.Id NOT IN (
	SELECT Departments.Id From Departments
	JOIN Heads ON Departments.HeadId = Heads.Id
	WHERE Departments.Name = 'Software Development'
);
GO


--7. Вивести список номерів усіх корпусів, які є у таблицях
--факультетів, кафедр та аудиторій.

SELECT Faculties.Building FROM Faculties 
UNION
SELECT Departments.Building FROM Departments
UNION
SELECT LectureRooms.Building FROM LectureRooms;
Go

--8. Вивести повні імена викладачів у такому порядку: декани факультетів, завідувачі кафедр, викладачі, куратори,
--асистенти.

SELECT Teachers.Name, Teachers.Surname FROM Teachers
JOIN Deans ON Deans.TeacherId = Teachers.Id
UNION
SELECT Teachers.Name, Teachers.Surname FROM Teachers
JOIN Heads ON Heads.TeacherId = Teachers.Id
JOIN Departments ON Departments.HeadId = Heads.Id
UNION
SELECT Teachers.Name, Teachers.Surname FROM Teachers
UNION 
SELECT Teachers.Name, Teachers.Surname FROM Teachers
JOIN Curators ON Curators.TeacherId = Teachers.Id


--9. Вивести дні тижня (без повторень), в які є заняття в аудиторіях «A311» та «A104» корпусу.

SELECT Schedules.DayOfWeek
FROM Schedules
JOIN LectureRooms ON Schedules.LectureRoomId = LectureRooms.Id
WHERE LectureRooms.Name IN ('A311', 'A104')
GROUP BY Schedules.DayOfWeek
HAVING COUNT(DISTINCT LectureRooms.Name) = 2;
GO
