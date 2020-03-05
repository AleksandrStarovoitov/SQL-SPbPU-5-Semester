use MySession;

--3. ��������� ��������� ���������� ������� �� ������� ������:
--	3.1. �������� ��� ����������� ����������, �� ������� ��������� ��������
SELECT Title FROM Directions;

--	3.2. �������� ��� ������ ����� �� ���� ������������ ����������
SELECT NumGr FROM Groups;

--	3.3. �������� ��� ���� ���������
SELECT FIO FROM Students;

--	3.4. �������� �������������� ���� ���������, ������� �������� ������
SELECT NumSt FROM Balls;

--	3.5. �������� ������ ����������� ���������� ������������, ������� �������� � ������� ����. �������� ��� �������� �������: ��� DISTINCT � � �������������� DISTINCT
SELECT NumDir FROM Uplans;
SELECT DISTINCT NumDir FROM Uplans;

--	3.6. �������� ������ ��������� �� ������� Uplans, ������ ��������� �����.
SELECT DISTINCT Semestr FROM Uplans;

--	3.7. �������� ���� ��������� ������ 13504/1
SELECT FIO FROM Students
	WHERE NumGr = '13504/1';

--	3.8. �������� ���������� ������� �������� ��� ����������� 230100
SELECT d.[Name] FROM Uplans as u
	JOIN Disciplines as d ON d.NumDisc = u.NumDisc
	WHERE u.NumDir = '230100' AND u.Semestr = 1;

--	3.9. �������� ������ ����� � ��������� ���������� ��������� � ������ ������
SELECT NumGr, Quantity FROM Groups;

--	3.10. �������� ��� ������ ������ ���������� ���������, ��������� ���� �� ���� �������
SELECT s.NumGr, COUNT(DISTINCT b.NumSt) as 'Passed' FROM Students as s
	JOIN Balls as b ON s.NumSt = b.NumSt
	WHERE b.Ball > 2
	GROUP BY s.NumGr;

--	3.11. �������� ��� ������ ������ ���������� ���������, ������� ����� ������ ��������
SELECT i.num as GroupNumber, COUNT(i.num) as 'PassedMoreThanOne' FROM (SELECT s.NumGr as num, s.FIO, COUNT(s.FIO) as 'Passed' FROM Students as s
		JOIN Balls as b ON s.NumSt = b.NumSt
		WHERE b.Ball > 2
		GROUP BY s.NumGr, s.FIO 
		HAVING COUNT(s.FIO) > 1) as i
	GROUP BY i.num;


--4. ��������� �������������� �������:
--	4.1. �������� ��� ���������, ������� ����� ��������
SELECT DISTINCT s.FIO FROM Balls as b
	JOIN Students as s ON b.NumSt = s.NumSt
	WHERE Ball > 2;

--	4.2. �������� �������� ���������, �� ������� �������� ������� ��������
SELECT DISTINCT d.Name FROM Balls as b
	JOIN Disciplines as d ON b.IdDisc = d.NumDisc;

--	4.3. �������� �������� ��������� �� ����������� 230100
SELECT DISTINCT d.Name FROM Uplans as u
	JOIN Disciplines as d ON u.NumDisc = d.NumDisc
	WHERE NumDir = '230100';

--	4.4. �������� ��� ���������, ������� ����� ����� ������ ��������
SELECT s.FIO as 'Passed' FROM Students as s
		JOIN Balls as b ON s.NumSt = b.NumSt
		WHERE b.Ball > 2
		GROUP BY s.NumGr, s.FIO 
		HAVING COUNT(s.FIO) > 1;

--4.5. �������� ��� ���������, ���������� ����������� ����
SELECT s.FIO FROM Balls as b
	JOIN Students as s ON b.NumSt = s.NumSt
	WHERE Ball = (SELECT MIN(Ball) FROM Balls);

--4.6. �������� ��� ���������, ���������� ������������ ����
SELECT DISTINCT s.FIO FROM Balls as b
	JOIN Students as s ON b.NumSt = s.NumSt
	WHERE Ball = (SELECT MAX(Ball) FROM Balls);

--4.7. �������� ������ �����, � ������� ���� ����� ������ ��������, �������� ������� �� ������ � 1 ��������
SELECT s.NumGr FROM Balls as b
	JOIN Students as s ON s.NumSt = b.NumSt
	WHERE b.IdDisc IN (SELECT u.IdDisc FROM Uplans as u
					JOIN Disciplines as d ON u.NumDisc = d.NumDisc
					WHERE d.[Name] = '������' AND u.Semestr = 1)
		AND b.Ball > 2
	GROUP BY s.NumGr
	HAVING COUNT(s.NumGr) > 1;

--4.8. �������� ��� ���������, ���������� �� ����� �������� ����� ���������� ������ �� ���� ��������� ����� 9.
SELECT s.FIO, SUM(Ball) FROM Balls as b
	JOIN Students as s ON s.NumSt = b.NumSt
	GROUP BY s.FIO
	HAVING SUM(Ball) > 9;
	
--4.9. �������� ��������, �� ������� ���������� ������� ��������� ����� ������
SELECT u.Semestr FROM Balls AS b
	JOIN Uplans AS u ON b.IdDisc = u.IdDisc
	WHERE b.Ball > 2
	GROUP BY u.Semestr
	HAVING COUNT(b.IdBall) > 1;

--4.10. �������� ���������, ������� ����� ������ ��������.
SELECT s.FIO as 'Passed' FROM Students as s
		JOIN Balls as b ON s.NumSt = b.NumSt
		WHERE b.Ball > 2
		GROUP BY s.NumGr, s.FIO 
		HAVING COUNT(s.FIO) > 1;