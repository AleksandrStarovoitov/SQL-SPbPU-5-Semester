use MySession;

--3. Составьте следующие запросы на выборку данных с использованием операций JOIN, UNION, EXCEPT, INTERSECT:
--	3.1. Выберите направления, в которых есть студенты, которые сдали экзамены 
SELECT DISTINCT u.NumDir FROM Balls AS b
	JOIN Uplans AS u ON u.IdDisc= b.IdDisc
	WHERE Ball > 2;

--	3.2. Выберите наименования дисциплин первого семестра
SELECT DISTINCT d.[Name] FROM Uplans AS u
	JOIN Disciplines AS d ON u.NumDisc = d.NumDisc 
	WHERE Semestr = 1;

--	3.3. Выберите номера групп, в которых есть студенты, сдавшие хотя бы один экзамен
SELECT s.NumGr FROM Students as s
	JOIN Balls as b ON s.NumSt = b.NumSt
	WHERE b.Ball > 2
	GROUP BY s.NumGr;

--	3.4. Выведите наименование дисциплин с указанием идентификатора студента, если он сдал экзамен
SELECT DISTINCT s.NumSt, d.[Name] FROM Students AS s
	LEFT JOIN Balls AS b ON b.NumSt = s.NumSt
	JOIN Disciplines AS d ON b.IdDisc = d.NumDisc
	WHERE b.Ball > 2;

--	3.5. Выберите номера групп, в которых есть свободные места.
SELECT g.NumGr, COUNT(s.FIO) as 'StudentsCount', g.Quantity as 'Capacity', g.Quantity - COUNT(s.FIO) as 'Vacant' FROM Students AS s
	JOIN Groups AS g ON s.NumGr = g.NumGr
	GROUP BY g.NumGr, g.Quantity
	HAVING COUNT(s.FIO) < g.Quantity

--	3.6. Выберите номера групп, в которых есть студенты, сдавшие больше одного экзамена, добавив к ним номера групп, в которых есть студенты, которые ничего не сдали. 
----SELECT s.NumGr, s.FIO, COUNT(b.Ball) FROM Balls AS b
----	JOIN Students AS s ON b.NumSt = s.NumSt
----	GROUP BY s.FIO, s.NumGr
----	HAVING COUNT(b.Ball) > 1;

(SELECT s.NumGr FROM Balls AS b
	JOIN Students AS s ON b.NumSt = s.NumSt
	GROUP BY s.NumGr
	HAVING COUNT(b.Ball) > 1)
UNION
(SELECT s.NumGr FROM Balls AS b
	RIGHT JOIN Students AS s ON b.NumSt = s.NumSt
	WHERE b.Ball IS NULL
	GROUP BY s.NumGr)

--	3.7. Выберите дисциплины, которые есть и в первом и во втором семестре
(SELECT d.[Name] FROM Uplans AS u
	JOIN Disciplines AS d ON u.NumDisc = d.NumDisc
	WHERE u.Semestr = 1)
INTERSECT
(SELECT d.[Name] FROM Uplans AS u
	JOIN Disciplines AS d ON u.NumDisc = d.NumDisc
	WHERE u.Semestr = 2);

--	3.8. Придумайте запрос, который использует операцию соединения по неравенству
SELECT s1.FIO, s1.NumGr, s2.FIO, s2.NumGr FROM Students AS s1
	JOIN Students AS s2 ON s1.NumSt != s2.NumSt AND s1.NumGr != s2.NumGr;

--	3.9. Придумайте запрос, который использует операцию внешнего соединения справа, предварительно подготовив тестовые данные.
--	3.10. Придумайте запрос с группировкой и соединением нескольких таблиц.
SELECT s.NumGr, b.Ball FROM Balls AS b
	RIGHT JOIN Students AS s ON b.NumSt = s.NumSt
	GROUP BY s.NumGr, b.Ball

--4. Составьте запросы с использованием подзапросов, в том числе с предикатами EXISTS и  NOT EXISTS
--	4.1. Выберите студентов, которые сдали только одну дисциплину
SELECT s.FIO FROM Balls AS b
	JOIN Students AS s ON b.NumSt = s.NumSt
	GROUP BY s.FIO
	HAVING COUNT(b.Ball) = 1;

--	4.2. Выбрать студентов, которые не сдали ни одного экзамена
SELECT DISTINCT s.FIO FROM Students AS s
	LEFT JOIN Balls AS b ON s.NumSt = b.NumSt
	WHERE Ball IS NULL;

--	4.3. Выберите группы, в которых есть студенты, сдавшие все экзамены 1 семестра
SELECT s.NumGr FROM Balls AS b
	JOIN Uplans AS u ON b.IdDisc = u.IdDisc
	JOIN Students AS s ON s.NumSt = b.NumSt
	WHERE u.Semestr = 1  GROUP BY s.NumGr, b.NumSt, u.NumDir 
	HAVING Count(Ball) = 
		(SELECT COUNT(*) FROM Uplans AS u1 
			WHERE u.NumDir=u1.NumDir and u1.Semestr = 1)

--	4.4. Выберите группы, в которых есть студенты, которые не сдали ни одной дисциплины
SELECT DISTINCT s.NumGr FROM Students AS s
	LEFT JOIN Balls AS b ON s.NumSt = b.NumSt
	WHERE b.Ball IS NULL;

--	4.5. Выбрать дисциплины, которые не попали в учебный план направления 231000
SELECT d.[Name], u.Semestr FROM Disciplines AS d
	JOIN Uplans AS u ON d.NumDisc = u.NumDisc
	WHERE u.NumDir != '231000'

--	4.6. Выбрать дисциплины, которые не сдали все студенты направления 231000
SELECT d.[Name] FROM Balls AS b
	JOIN Disciplines AS d ON b.IdDisc = d.NumDisc
	WHERE NOT EXISTS (SELECT s.NumSt FROM Students AS s
	LEFT JOIN Groups AS g ON g.NumGr = s.NumGr
	LEFT JOIN Directions AS dir ON g.NumDir = dir.NumDir
	WHERE dir.NumDir = '231000');

--	4.7. Выбрать группы, в которых все студенты сдали физику
SELECT g.NumGr, COUNT(g.NumGr) FROM Balls AS b
	LEFT JOIN Students AS s ON b.NumSt = s.NumSt
	JOIN Groups AS g ON g.NumGr = s.NumGr
	WHERE b.IdDisc IN
	(SELECT IdDisc FROM Uplans AS u
		JOIN Disciplines AS dis ON dis.NumDisc = u.NumDisc
		WHERE dis.[Name] = 'Физика')
	GROUP BY g.NumGr
	HAVING COUNT(g.NumGr) =
		(SELECT COUNT(ins.NumGr) FROM Students AS ins
		WHERE ins.NumGr = g.NumGr	
		GROUP BY ins.NumGr);

--	4.8. Выбрать группы, в которых все студенты сдали все дисциплины 1 семестра
SELECT g.NumGr, COUNT(g.NumGr) FROM Balls AS b
	LEFT JOIN Students AS s ON b.NumSt = s.NumSt
	JOIN Uplans AS u ON b.IdDisc = u.IdDisc
	JOIN Groups AS g ON g.NumGr = s.NumGr
	GROUP BY g.NumGr, u.NumDir 
	-- Count = Group Size
	HAVING COUNT(g.NumGr) = 
		(SELECT COUNT(ins.NumGr) FROM Students AS ins
		WHERE ins.NumGr = g.NumGr	
		GROUP BY ins.NumGr)
	AND 
	-- Count = First Semester size
		Count(b.Ball) = 
		(SELECT COUNT(*) FROM Uplans AS u1 
			WHERE u.NumDir=u1.NumDir and u1.Semestr = 1);

--	4.9. Выбрать студентов, которые сдали все экзамены на хорошо и отлично.
SELECT DISTINCT s.FIO FROM Balls AS b
	JOIN Students AS s ON s.NumSt = b.NumSt
	WHERE Ball > 3;

--	4.9. Выбрать студентов, которые сдали наибольшее количество экзаменов
SELECT s.FIO, COUNT(b.Ball) FROM Balls AS b
	JOIN Students AS s ON b.NumSt = s.NumSt
	GROUP BY s.Fio
	HAVING COUNT(b.Ball) = (
		SELECT MAX(inn.maxv) FROM 
			(SELECT COUNT(binn.Ball) AS maxv FROM Balls AS binn
				GROUP BY binn.NumSt) inn
	);