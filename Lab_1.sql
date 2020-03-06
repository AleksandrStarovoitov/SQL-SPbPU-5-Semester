use MySession;

--3. Составьте следующие простейшие запросы на выборку данных:
--	3.1. Выберите все направления подготовки, по которым обучаются студенты
SELECT Title FROM Directions;

--	3.2. Выберите все номера групп по всем направлениям подготовки
SELECT NumGr FROM Groups;

--	3.3. Выберите ФИО всех студентов
SELECT FIO FROM Students;

--	3.4. Выберите идентификаторы всех студентов, которые получили оценки
SELECT NumSt FROM Balls;

--	3.5. Выберите номера направлений подготовки специалистов, которые включены в учебный план. Напишите два варианта запроса: без DISTINCT и с использованием DISTINCT
SELECT NumDir FROM Uplans;
SELECT DISTINCT NumDir FROM Uplans;

--	3.6. Выберите номера семестров из таблицы Uplans, удалив дубликаты строк.
SELECT DISTINCT Semestr FROM Uplans;

--	3.7. Выберите всех студентов группы 13504/1
SELECT FIO FROM Students
	WHERE NumGr = '13504/1';

--	3.8. Выберите дисциплины первого семестра для направления 230100
SELECT d.[Name] FROM Uplans as u
	JOIN Disciplines as d ON d.NumDisc = u.NumDisc
	WHERE u.NumDir = '230100' AND u.Semestr = 1;

--	3.9. Выведите номера групп с указанием количества студентов в каждой группе
SELECT NumGr, Quantity FROM Groups;

--	3.10. Выведите для каждой группы количество студентов, сдававших хотя бы один экзамен
SELECT s.NumGr, COUNT(DISTINCT b.NumSt) as 'Passed' FROM Students as s
	JOIN Balls as b ON s.NumSt = b.NumSt
	WHERE b.Ball > 2
	GROUP BY s.NumGr;

--	3.11. Выведите для каждой группы количество студентов, сдавших более одного экзамена
SELECT i.num as GroupNumber, COUNT(i.num) as 'PassedMoreThanOne' FROM (SELECT s.NumGr as num, s.FIO, COUNT(s.FIO) as 'Passed' FROM Students as s
		JOIN Balls as b ON s.NumSt = b.NumSt
		WHERE b.Ball > 2
		GROUP BY s.NumGr, s.FIO 
		HAVING COUNT(s.FIO) > 1) as i
	GROUP BY i.num;


--4. Составьте многотабличные запросы:
--	4.1. Выберите ФИО студентов, которые сдали экзамены
SELECT DISTINCT s.FIO FROM Balls as b
	JOIN Students as s ON b.NumSt = s.NumSt
	WHERE Ball > 2;

--	4.2. Выберите названия дисциплин, по которым студенты сдавали экзамены
SELECT DISTINCT d.Name FROM Balls as b
	JOIN Disciplines as d ON b.IdDisc = d.NumDisc;

--	4.3. Выведите названия дисциплин по направлению 230100
SELECT DISTINCT d.Name FROM Uplans as u
	JOIN Disciplines as d ON u.NumDisc = d.NumDisc
	WHERE NumDir = '230100';

--	4.4. Выведите ФИО студентов, которые сдали более одного экзамена
SELECT s.FIO as 'Passed' FROM Students as s
		JOIN Balls as b ON s.NumSt = b.NumSt
		WHERE b.Ball > 2
		GROUP BY s.NumGr, s.FIO 
		HAVING COUNT(s.FIO) > 1;

--4.5. Выведите ФИО студентов, получивших минимальный балл
SELECT s.FIO FROM Balls as b
	JOIN Students as s ON b.NumSt = s.NumSt
	WHERE Ball = (SELECT MIN(Ball) FROM Balls);

--4.6. Выведите ФИО студентов, получивших максимальный балл
SELECT DISTINCT s.FIO FROM Balls as b
	JOIN Students as s ON b.NumSt = s.NumSt
	WHERE Ball = (SELECT MAX(Ball) FROM Balls);

--4.7. Выведите номера групп, в которые есть более одного студента, сдавшего экзамен по Физике в 1 семестре
SELECT s.NumGr FROM Balls as b
	JOIN Students as s ON s.NumSt = b.NumSt
	WHERE b.IdDisc IN (SELECT u.IdDisc FROM Uplans as u
					JOIN Disciplines as d ON u.NumDisc = d.NumDisc
					WHERE d.[Name] = 'Физика' AND u.Semestr = 1)
		AND b.Ball > 2
	GROUP BY s.NumGr
	HAVING COUNT(s.NumGr) > 1;

--4.8. Выведите ФИО студентов, получивших за время обучения общее количество баллов по всем предметам более 9.
SELECT s.FIO, SUM(Ball) FROM Balls as b
	JOIN Students as s ON s.NumSt = b.NumSt
	GROUP BY s.FIO
	HAVING SUM(Ball) > 9;
	
--4.9. Выведите семестры, по которым количество сдавших студентов более одного
SELECT u.Semestr FROM Balls AS b
	JOIN Uplans AS u ON b.IdDisc = u.IdDisc
	WHERE b.Ball > 2
	GROUP BY u.Semestr
	HAVING COUNT(b.IdBall) > 1;

--4.10. Выведите студентов, сдавших более одного предмета.
SELECT s.FIO as 'Passed' FROM Students as s
		JOIN Balls as b ON s.NumSt = b.NumSt
		WHERE b.Ball > 2
		GROUP BY s.NumGr, s.FIO 
		HAVING COUNT(s.FIO) > 1;