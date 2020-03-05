--1. Пример создания процедуры без параметров.
--Создаем процедуру для подсчета общего количества студентов
CREATE PROCEDURE Count_Students AS
	SELECT COUNT(*) FROM Students

-- EXEC Count_Students;

--2. Пример создания процедуры c входным параметром. 
--Создаем процедуру для подсчета студентов, сдавших 
--хотя бы один экзамен в заданном семестре
CREATE PROCEDURE Count_Students_Sem @Count_sem AS INT
AS
	SELECT COUNT(Distinct NumSt) FROM Balls AS b
		JOIN Uplans AS u ON u.IdDisc = b.IdDisc 
		WHERE Semestr >= @Count_sem;
--Запустите процедуру для получения данных о количестве 
--студентов сдавших экзамены в первом семестре. 
-- EXEC Count_Students_Sem 1

--или с использованием переменной
-- DECLARE @kol int;
-- SET @kol=1;
-- EXEC Count_Students_Sem @kol;


--3. Пример создания процедуры c несколькими  входными параметрами. 
--3.1. Создаем процедуру для получения списка студентов указанного
-- направления, сдавших экзамен по  указанной дисциплине
CREATE PROCEDURE List_Students_Dir (@Dir AS INT, @Disc AS VARCHAR(30))
AS
	SELECT Distinct Students.FIO FROM Groups 
		JOIN Students ON Groups.NumGr = Students.NumGr 
		JOIN Balls ON Students.NumSt = Balls.NumSt 
		JOIN Uplans ON Uplans.IdDisc = Balls.IdDisc 
		WHERE Groups.NumDir=@Dir AND NumDisc = (
			SELECT NumDisc FROM Disciplines 
			WHERE Name=@Disc
		);
--GO

-- EXEC List_Students_Dir 230100, 'Физика'
--или с использованием переменной
-- DECLARE @dir int, @title varchar(30);
-- SET @dir=230100;
-- SET @title = 'Физика';
-- EXEC List_Students_Dir @dir,@title;

--3.2. Создаем процедуру для ввода информации о новом студенте
CREATE PROCEDURE Enter_Students (@Fio AS VARCHAR(30), @Group AS VARCHAR(10))  AS
	INSERT INTO Students (FIO, NumGr) VALUES (@Fio, @Group);

-- ALTER TABLE Students NOCHECK CONSTRAINT FK__Students__NumGr__3C69FB99;
-- DECLARE @Stud VARCHAR(30), @Group varchar(10);
-- SET @Stud='Новая Наталья';
-- SET @Group ='53504/3';
-- EXEC Enter_Students  @Stud, @Group;
-- ALTER TABLE Students CHECK CONSTRAINT FK__Students__NumGr__3C69FB99;

-- SELECT * FROM Students 
	-- WHERE FIO = 'Новая Наталья';

--4. Пример создания процедуры с входными параметрами и значениями 
--по умолчанию. Создать процедуру для перевода студентов указанной
--группы на следующий курс
CREATE PROCEDURE Next_Course (@Group AS VARCHAR(10)='13504/1')
AS
UPDATE Students SET NumGr=CONVERT(char(1),
								  CONVERT(int, LEFT(NumGr,1))+1)+
								  SUBSTRING(NumGr,2,LEN(NumGr)-1)
	WHERE NumGr=@Group;
--GO
--Для обращения к процедуре можно использовать команды:
-- DECLARE @Group VARCHAR(10);
-- SET @Group='53504/3';
-- EXEC Next_Course @Group;
-- GO
--Для использования значений по умолчанию:
-- EXEC Next_Course;
-- GO

--Напишите процедуру, которая будет возвращать старые номера групп обратно
CREATE PROCEDURE Previous_Course (@Group AS VARCHAR(10)='13504/1')
AS
UPDATE Students SET NumGr = CONVERT(char(1),
								  CONVERT(int, LEFT(NumGr,1))-1)+
								  SUBSTRING(NumGr,2,LEN(NumGr)-1)
	WHERE NumGr = @Group;
-- GO

--5. Пример создания процедуры с входными и выходными параметрами. 
--Создать процедуру для определения количества групп по указанному направлению.
CREATE PROCEDURE Number_Groups (@Dir AS int, @Number AS int OUTPUT)
AS
	SELECT @Number = COUNT(NumGr) FROM Groups 
	WHERE NumDir=@Dir;
--GO
--Получить и посмотреть результат можно следующим образом:
-- DECLARE @Group int;
-- EXEC Number_Groups 230100, @Group OUTPUT;
-- SELECT @Group;
-- GO