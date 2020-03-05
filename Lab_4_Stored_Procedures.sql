--1. ������ �������� ��������� ��� ����������.
--������� ��������� ��� �������� ������ ���������� ���������
CREATE PROCEDURE Count_Students AS
	SELECT COUNT(*) FROM Students

-- EXEC Count_Students;

--2. ������ �������� ��������� c ������� ����������. 
--������� ��������� ��� �������� ���������, ������� 
--���� �� ���� ������� � �������� ��������
CREATE PROCEDURE Count_Students_Sem @Count_sem AS INT
AS
	SELECT COUNT(Distinct NumSt) FROM Balls AS b
		JOIN Uplans AS u ON u.IdDisc = b.IdDisc 
		WHERE Semestr >= @Count_sem;
--��������� ��������� ��� ��������� ������ � ���������� 
--��������� ������� �������� � ������ ��������. 
-- EXEC Count_Students_Sem 1

--��� � �������������� ����������
-- DECLARE @kol int;
-- SET @kol=1;
-- EXEC Count_Students_Sem @kol;


--3. ������ �������� ��������� c �����������  �������� �����������. 
--3.1. ������� ��������� ��� ��������� ������ ��������� ����������
-- �����������, ������� ������� ��  ��������� ����������
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

-- EXEC List_Students_Dir 230100, '������'
--��� � �������������� ����������
-- DECLARE @dir int, @title varchar(30);
-- SET @dir=230100;
-- SET @title = '������';
-- EXEC List_Students_Dir @dir,@title;

--3.2. ������� ��������� ��� ����� ���������� � ����� ��������
CREATE PROCEDURE Enter_Students (@Fio AS VARCHAR(30), @Group AS VARCHAR(10))  AS
	INSERT INTO Students (FIO, NumGr) VALUES (@Fio, @Group);

-- ALTER TABLE Students NOCHECK CONSTRAINT FK__Students__NumGr__3C69FB99;
-- DECLARE @Stud VARCHAR(30), @Group varchar(10);
-- SET @Stud='����� �������';
-- SET @Group ='53504/3';
-- EXEC Enter_Students  @Stud, @Group;
-- ALTER TABLE Students CHECK CONSTRAINT FK__Students__NumGr__3C69FB99;

-- SELECT * FROM Students 
	-- WHERE FIO = '����� �������';

--4. ������ �������� ��������� � �������� ����������� � ���������� 
--�� ���������. ������� ��������� ��� �������� ��������� ���������
--������ �� ��������� ����
CREATE PROCEDURE Next_Course (@Group AS VARCHAR(10)='13504/1')
AS
UPDATE Students SET NumGr=CONVERT(char(1),
								  CONVERT(int, LEFT(NumGr,1))+1)+
								  SUBSTRING(NumGr,2,LEN(NumGr)-1)
	WHERE NumGr=@Group;
--GO
--��� ��������� � ��������� ����� ������������ �������:
-- DECLARE @Group VARCHAR(10);
-- SET @Group='53504/3';
-- EXEC Next_Course @Group;
-- GO
--��� ������������� �������� �� ���������:
-- EXEC Next_Course;
-- GO

--�������� ���������, ������� ����� ���������� ������ ������ ����� �������
CREATE PROCEDURE Previous_Course (@Group AS VARCHAR(10)='13504/1')
AS
UPDATE Students SET NumGr = CONVERT(char(1),
								  CONVERT(int, LEFT(NumGr,1))-1)+
								  SUBSTRING(NumGr,2,LEN(NumGr)-1)
	WHERE NumGr = @Group;
-- GO

--5. ������ �������� ��������� � �������� � ��������� �����������. 
--������� ��������� ��� ����������� ���������� ����� �� ���������� �����������.
CREATE PROCEDURE Number_Groups (@Dir AS int, @Number AS int OUTPUT)
AS
	SELECT @Number = COUNT(NumGr) FROM Groups 
	WHERE NumDir=@Dir;
--GO
--�������� � ���������� ��������� ����� ��������� �������:
-- DECLARE @Group int;
-- EXEC Number_Groups 230100, @Group OUTPUT;
-- SELECT @Group;
-- GO