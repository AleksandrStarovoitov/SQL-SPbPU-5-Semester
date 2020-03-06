USE MySession;
--GO
--1.	Пример создания и использования представления для выборки  названий дисциплин,
-- по которым хотя бы одним студентом была получена оценка 
CREATE VIEW Disciplines_with_balls AS 
	SELECT Distinct [Name] FROM Disciplines 
	INNER JOIN Uplans ON Disciplines.NumDisc = Uplans.NumDisc 
	INNER JOIN Balls ON Uplans.IdDisc = Balls.IdDisc;
--GO
-- SELECT * FROM Disciplines_with_balls;

--2.	Пример создания и использования представления c использованием 
--реляционных операций для выборки студентов, которые получили пятерки и которые
-- вообще ничего не сдали
--GO
CREATE VIEW Students_top_and_last (Fio, Complete) AS 
	(SELECT A.Stud, 'NO' FROM 
		(SELECT NumSt AS Stud FROM Students 
		EXCEPT 
		SELECT DISTINCT NumSt AS Stud FROM Balls) AS A
	)
	UNION
	(SELECT NumSt, 'Five' FROM Balls WHERE Ball=5);
--GO
-- SELECT * FROM Students_top_and_last;

-- 3.	Пример создания и использования представления с использованием агрегатных 
-- функций, группировки и подзапросов для вывода студентов, которые сдали все экзамены
-- первого семестра
--GO
CREATE VIEW Students_complete (Fio, Direction, Numer_of_balls) AS 
	SELECT NumSt, NumDir, COUNT(Ball) FROM Balls
	JOIN Uplans ON Balls.IdDisc = Uplans.IdDisc 
	WHERE Semestr = 1 
	GROUP BY NumSt, NumDir 
	HAVING Count(Ball) = (
		SELECT COUNT(*) FROM Uplans AS u 
		WHERE Uplans.NumDir = u.NumDir AND Semestr = 1
	);
--GO
-- SELECT * FROM Students_complete

--4.	Пример создания и использования представления с использованием  предиката 
--NOT EXISTS для вывода номеров студентов, которые сдали все экзамены своего курса 
--GO
CREATE VIEW Students_complete_2 AS 
	SELECT Students.NumSt FROM Students 
	JOIN Groups ON Groups.NumGr = Students.NumGr 
	WHERE NOT EXISTS (
		SELECT * FROM Uplans  
			WHERE (Semestr = CONVERT(int, LEFT(Students.NumGr,1))*2-1 OR 
			Semestr = CONVERT(int, LEFT(Students.NumGr,1))*2) AND 
			Groups.NumDir = Uplans.NumDir AND 
			NOT EXISTS (	
				SELECT * FROM Balls
					WHERE Balls.IdDisc=Uplans.IdDisc AND
					Students.NumSt=Balls.NumSt) 
	);
--GO
-- SELECT * FROM Students_complete_2;