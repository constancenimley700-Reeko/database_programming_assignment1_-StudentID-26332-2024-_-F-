Create Table Students ( 
Studentid int primary key,
StudentName varchar(100),
Gender varchar(10),
Department varchar(50));

Create Table  Courses (
Courseid int primary key,
CourseName varchar(100),
Credits int);

Create Table Enrollments (
Enrollmentid int primary key,
Studentid int,
Courseid int,
Score int,
Semester varchar(20),

FOREIGN KEY(Studentid) REFERENCES Students(Studentid),
FOREIGN KEY(Courseid) REFERENCES Courses(Courseid));

INSERT INTO  Students VALUES
(1,'john Doe', 'Male', 'Computer Science');
INSERT INTO Students VALUES
(2, 'Mary Jane', 'Female', 'Information Technology');
INSERT INTO Students VALUES
(3, 'Peter Smith', 'Male', 'Computer Science');
INSERT INTO Students VALUES
(4, 'Alice Brown', 'Female', 'Business');

INSERT INTO Courses VALUES
(101, 'Database Programming',3);

INSERT INTO Courses VALUES
(102, 'Discrete Mathematics',3);

INSERT INTO Courses VALUES
(103,'Statistics',3);

INSERT INTO Enrollments VALUES
(1,1,101,85, 'Semester 1');

INSERT INTO Enrollments VALUES
(2,1,102,78, 'Semester 1');

INSERT INTO Enrollments VALUES
(3,2,101,90, 'Semester 1');

INSERT INTO Enrollments VALUES
(4,2,103,88, 'Semester 1');

INSERT INTO Enrollments VALUES
(5,3,101,70, 'Semester 1');

INSERT INTO Enrollments VALUES
(6,4,103,95, 'Semester 1');

---ER Diagram

Students
---------
StudentID (PK)
StudentName
Gender
Department

      |
      | 1:M
      |

Enrollments
------------
EnrollmentID (PK)
StudentID (FK)
CourseID (FK)
Score
Semester

      |
      | M:1
      |

Courses
---------
CourseID (PK)
CourseName
Credits

---Simple CTE
WITH StudentScores AS
(
    SELECT StudentID, Score
    FROM Enrollments
)
SELECT *
FROM StudentScores;

---Multiple CTEs
WITH TotalScores AS
(
    SELECT StudentID,
           SUM(Score) AS TotalScore
    FROM Enrollments
    GROUP BY StudentID
),

AverageScores AS
(
    SELECT AVG(TotalScore) AS AvgScore
    FROM TotalScores
)

SELECT *
FROM AverageScores;


---Recursive 
WITH Numbers AS
(
    SELECT 1 AS Num

    UNION ALL

    SELECT Num + 1
    FROM Numbers
    WHERE Num < 10
)

SELECT *
FROM Numbers;


---CTE with Aggregation
WITH DepartmentAverage AS
(
    SELECT S.Department,
           AVG(E.Score) AS AverageScore
    FROM Students S
    JOIN Enrollments E
    ON S.StudentID = E.StudentID
    GROUP BY S.Department
)

SELECT *
FROM DepartmentAverage;

---CTE with JOIN
WITH StudentCourses AS
(
    SELECT S.StudentName,
           C.CourseName,
           E.Score
    FROM Students S
    JOIN Enrollments E
    ON S.StudentID = E.StudentID
    JOIN Courses C
    ON E.CourseID = C.CourseID
)

SELECT *
FROM StudentCourses;

---PART B: SQL Window Functions--Ranking Functions
---(ROW_NUMBER()
SELECT Studentid,
       Score,
       ROW_NUMBER() OVER(ORDER BY Score DESC) AS RowNum
FROM Enrollments;

---RANK()
SELECT StudentID,
       Score,
       RANK() OVER(ORDER BY Score DESC) AS RankNo
FROM Enrollments;

--DENSE_RANK()
SELECT StudentID,
       Score,
       DENSE_RANK() OVER(ORDER BY Score DESC) AS DenseRank
FROM Enrollments;

--PERCENT_RANK()
SELECT StudentID,
       Score,
       PERCENT_RANK() OVER(ORDER BY Score) AS PercentRank
FROM Enrollments;

--Aggregate Window Functions
--SUM() OVER()
SELECT StudentID,
       Score,
       SUM(Score) OVER() AS TotalScore
FROM Enrollments;

--AVG() OVER()
SELECT StudentID,
       Score,
       SUM(Score) OVER() AS TotalScore
FROM Enrollments;

--MIN() OVER()

SELECT StudentID,
       Score,
       MIN(Score) OVER() AS LowestScore
FROM Enrollments;

--MAX() OVER()
SELECT StudentID,
       Score,
       MAX(Score) OVER() AS HighestScore
FROM Enrollments;

--Navigation Functions--LAG()
SELECT StudentID,
       Score,
       LAG(Score) OVER(ORDER BY Score) AS PreviousScore
FROM Enrollments;

--LEAD()
SELECT StudentID,
       Score,
       LEAD(Score) OVER(ORDER BY Score) AS NextScore
FROM Enrollments;

--Distribution Functions
--NTILE()
SELECT StudentID,
       Score,
       NTILE(4) OVER(ORDER BY Score DESC) AS Quartile
FROM Enrollments;

--CUME_DIST()
SELECT StudentID,
       Score,
       CUME_DIST() OVER(ORDER BY Score) AS Distribution
FROM Enrollments;




