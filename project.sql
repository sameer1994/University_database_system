											--DESIGN MODIFICATIONS
	/* a) I replaced my Employee Health Benefits and Students majors and minors with yours because there were 
	     too many modifications to make and it was affecting other tables and their relationships as well.
	   b) I changed CourseTimings table so that one course can have different timings, can be held in different 
	     rooms and can have different capacities.
	   c) Made Studentgrade as optional, earlier it was required
	   d) Changed Addresses Table and modified prerequisites table 
	   e) Added a m2m FacultyandCourses table
	   f) Changed persons table to have a local and home address ID's
*/

CREATE TABLE Address (
	AddressID    INTEGER        PRIMARY KEY   IDENTITY(1,1),
	Street1      VARCHAR(30)    NOT NULL,
	Street2      VARCHAR(10),
	City         VARCHAR(20)    NOT NULL,
	State        VARCHAR(15)    NOT NULL,
	ZIPCode      CHAR(5)        NOT NULL
);

CREATE TABLE Persons (
	PersonID         INTEGER        PRIMARY KEY,
	FirstName        VARCHAR(30)    NOT NULL,
	LastName         VARCHAR(30)    NOT NULL,
	Ntid             VARCHAR(35)    NOT NULL,
	Password         VARCHAR(32),
	LocalAddressID   INTEGER        NOT NULL      REFERENCES Address(AddressID),
	HomeAddressID    INTEGER                      REFERENCES Address(AddressID)
);

CREATE TABLE StudentStatus (
	ID     INTEGER      PRIMARY KEY   IDENTITY(1,1),
	Text   VARCHAR(30)  NOT NULL
);

CREATE TABLE Students (
	StudentID       INTEGER  PRIMARY KEY   REFERENCES Persons(PersonID),
	DateOfBirth     DATE     NOT NULL,
	Ssn             CHAR(9),
	StatusID        INTEGER  NOT NULL      REFERENCES StudentStatus(ID)
);

CREATE TABLE College (
	CollegeID      INTEGER      PRIMARY KEY IDENTITY(1,1),
	CollegeName    VARCHAR(30)  NOT NULL
);

CREATE TABLE AreaOfStudy (
	AreaOfStudyID    INTEGER     PRIMARY KEY  IDENTITY(1,1),
	StudyTitle       VARCHAR(30) NOT NULL,
	CollegeID        INTEGER     NOT NULL     REFERENCES College(CollegeID)
);

CREATE TABLE StudentAreaOfStudy (
	StudentStudyID   INTEGER     PRIMARY KEY  IDENTITY(1,1),
	StudentID        INTEGER     NOT NULL     REFERENCES Students(StudentID),
	AreaID           INTEGER     NOT NULL     REFERENCES AreaOfStudy(AreaOfStudyID), 
	IsMajor          CHAR(1)     NOT NULL
);


Create TABLE BenefitSelection (
	BenefitSelectionID    INTEGER     PRIMARY KEY   IDENTITY(1,1),
	Text                  VARCHAR(30) NOT NULL
);

CREATE TABLE Benefits (
	BenefitID         INTEGER       PRIMARY KEY   IDENTITY(1,1),
	BenefitCost       DECIMAL(7,2)  NOT NULL,
	BenefitSelection  INTEGER       NOT NULL      REFERENCES BenefitSelection(BenefitSelectionID),
	Description       VARCHAR(100)  NOT NULL
);

CREATE TABLE Employees (
	EmployeeID          INTEGER      PRIMARY KEY REFERENCES Persons(PersonID) ,
	Ssn                 CHAR(9)      NOT NULL,
	YearlyPay           DECIMAL(9,2) NOT NULL CHECK(YearlyPay<1000000 AND YearlyPay>10000),
	IsStatus            CHAR(1)      NOT NULL,
	HealthBenefitsID    INTEGER      NOT NULL REFERENCES Benefits(BenefitID),
	VisionBenefitsID    INTEGER      NOT NULL REFERENCES Benefits(BenefitID),
	DentalBenefitsID    INTEGER      NOT NULL REFERENCES Benefits(BenefitID)
);

CREATE TABLE CourseInfo (
	CourseID          INTEGER         PRIMARY KEY IDENTITY(1,1),
	CourseCode        CHAR(3)         NOT NULL,
	Coursenumber      INTEGER         NOT NULL,
	CourseTitle       VARCHAR(30)     NOT NULL,
	CourseDescription VARCHAR(100)    NOT NULL
);

CREATE TABLE Prerequisites (
	ParentCourseID    INTEGER    REFERENCES CourseInfo(CourseID),
	ChildCourseID     INTEGER    REFERENCES  CourseInfo(CourseID),
	PRIMARY KEY(ParentCourseID,ChildCourseID)
);

CREATE TABLE CourseStatus (
	ID     INTEGER     PRIMARY KEY IDENTITY(1,1),
	Text   VARCHAR(30) NOT NULL
);

CREATE TABLE StudentGrades (
	ID     INTEGER     PRIMARY KEY IDENTITY(1,1),
	Text   VARCHAR(30) NOT NULL,
);

CREATE TABLE EnrollmentInCourse (
	EnrollmentID        INTEGER     PRIMARY KEY IDENTITY(1,1),
	CourseID            INTEGER     NOT NULL    REFERENCES CourseInfo(CourseID) ,
	FacultyID           INTEGER     NOT NULL    REFERENCES Employees(EmployeeID),
	StudentID           INTEGER     NOT NULL    REFERENCES Students(StudentID),
	StudentCourseStatus INTEGER     NOT NULL    REFERENCES CourseStatus(ID),
	StudentGradeID      INTEGER                 REFERENCES StudentGrades(ID)
); 


CREATE TABLE Requirements (
	ID    INTEGER     PRIMARY KEY IDENTITY(1,1),
	Text  VARCHAR(30) NOT NULL
);

CREATE TABLE JobInfo (
	JobID          INTEGER       PRIMARY KEY IDENTITY(1,1),
	JobTitle       VARCHAR(50)   NOT NULL,
	JobDescription VARCHAR(100),
	MaxPay         DECIMAL(9,2)              CHECK(MaxPay<1000000),
	MinPay         DECIMAL(8,2)  NOT NULL    CHECK(MinPay>10000),
	IsUnion        CHAR(1)       NOT NULL
);
 
CREATE TABLE RequirementsOfJob (
	JobID         INTEGER REFERENCES JobInfo(JobID),
	RequirementID INTEGER REFERENCES Requirements(ID),
	PRIMARY KEY(JobID,RequirementID)
);

CREATE TABLE JobsAndEmployees (
	JobID       INTEGER     REFERENCES JobInfo(JobID),
	EmployeeID  INTEGER     REFERENCES Employees(EmployeeID),
	PRIMARY KEY(JobID,EmployeeID)
);

CREATE TABLE FacultyAndCourses (
	FacultyID   INTEGER    REFERENCES Employees(EmployeeID),
	CourseID    INTEGER    REFERENCES CourseInfo(CourseID),
	PRIMARY KEY(FacultyID, CourseID)
);


CREATE TABLE ListOfBuildings (
	ID     INTEGER       PRIMARY KEY  IDENTITY(1,1),
	Text   VARCHAR(30)   NOT NULL
);

CREATE TABLE ProjectorOptions (
	ID     INTEGER       PRIMARY KEY  IDENTITY(1,1),
	Text   VARCHAR(30)   NOT NULL
);

CREATE TABLE ClassRoom (
	ClassRoomID       INTEGER     PRIMARY KEY IDENTITY(1,1),
	BuildingNameID    INTEGER     NOT NULL    REFERENCES ListOfBuildings(ID),
	RoomNumber        VARCHAR(10) NOT NULL,
	MaxSeating        INTEGER     NOT NULL    CHECK(MaxSeating<=200),
	ProjectorID       INTEGER     NOT NULL    REFERENCES ProjectorOptions(ID),
	NoOfWhiteBoards   INTEGER     NOT NULL,
	OtherEquipment    VARCHAR(20)
);


CREATE TABLE CourseTimings (
	CourseScheduleID     INTEGER    PRIMARY KEY   IDENTITY(1,1),
	CourseID             INTEGER    NOT NULL      REFERENCES CourseInfo(CourseID),
	StartDate            DATE       NOT NULL,
	EndDate              DATE       NOT NULL,
	StartTime            TIME       NOT NULL,
	EndTime              TIME       NOT NULL,
	ClassRoomID          INTEGER    NOT NULL      REFERENCES ClassRoom(ClassRoomID),
	Seats                INTEGER    NOT NULL
);

CREATE TABLE ListOfDays (
	ID     INTEGER      PRIMARY KEY IDENTITY(1,1),
	Text   VARCHAR(10)  NOT NULL
);

CREATE TABLE CourseOnDays (
	CourseScheduleID      INTEGER   NOT NULL   REFERENCES CourseTimings(CourseScheduleID),
	DayID                 INTEGER   NOT NULL   REFERENCES ListOfDays(ID),
	PRIMARY KEY(CourseScheduleID,DayID)
);

INSERT INTO ADDRESS(Street1, Street2, City, State, ZIPCode)
	VALUES('312 Westcott Street', 'Apt 6', 'Syracuse', 'NY', '13210'),
		  ('400 Euclid Ave', NULL, 'Syracuse', 'NY', '13210'),
		  ('555 Columbus Street','Apt 3','Syracuse', 'NY', '13213'),
		  ('102 Harvard Place', NULL, 'Syracuse', 'NY','13215'),
		  ('185 Avondale Place', NULL, 'Syracuse', 'NY','13210'),
		  ('1700 East Fayette Street', 'Apt 6', 'Syracuse', 'NY','13210'),
		  ('215 Cherry Street', NULL, 'Syracuse', 'NY', '13217'),
		  ('855 Ackerman Ave', NULL, 'Syracuse', 'NY', '13250'),
		  ('325 Concord Place', NULL, 'Syracuse', 'NY', '13210'),
		  ('320 Lancaster Ave', NULL,' Syracuse', 'NY','13245'),
		  ('220 Prospect Ave', 'Apt 5', 'San Francisco', 'CA', '94101'),
		  ('414 Union Ave', 'Apt3', 'Seatle', 'WA', '98101'),
		  ('1200 Court Street', NULL, 'New York City', 'NY', '10001'),
		  ('525 North Street', 'Apt 4', 'Miami', 'FL', '33101'),
		  ('323 Pacific Ave', NULL, 'Tampa', 'FL', '33601');

--First 6 are students, rest 5 are employees.
INSERT INTO Persons(PersonID, FirstName, LastName, Ntid, Password, LocalAddressID, HomeAddressID)
		VALUES(2454651,'Tyrion', 'Lannister','tlannister',NULL,1,11),
			  (2454652,'Joffrey', 'Baratheon','jbaratheon',NULL,2,12),
			  (1463458,'Sansa', 'Stark','sstark',NULL,3,13),
			  (2589634,'Arya', 'Stark', 'astark',NULL,4,14),
			  (1478523,'Danerys', 'Tagereyan', 'dtagareyan', NULL,5,15),
			  (2589637,'Ramsay', 'Bolton', 'rbolton', 'tyuhnf@#', 10,NULL),
			  (2258857,'Ned', 'Stark', 'nstark', 'samurai',6,NULL),
			  (1236587,'Robert', 'Baratheon', 'rbaratheon', 'syrsam198#', 7,NULL),
			  (8879653,'Khal', 'Drogo', 'kdrogo','dragoon123$', 8,NULL),
			  (1478963,'Petyr', 'Baelish', 'pbaelish','qwert543@',9,NULL),
			  (1454651,'Stannis', 'Baratheon','sbaratheon','yahoo@#$',13,NULL);

INSERT INTO StudentStatus(Text)
		VALUES('Undergraduate'),
			  ('Graduate'),
			  ('Non-Matriculated'),
			  ('Graduated');


INSERT INTO Students(StudentID,DateOfBirth,Ssn,StatusID)
		VALUES(2454651,'1994-06-03',NULL,1),
			  (2454652,'1993-08-05',655516137,2),
			  (1463458,'1995-07-09',654986235,3),
			  (2589634,'1990-08-04',623857412,4),
			  (1478523,'1991-01-05',NULL,1),
			  (2589637,'1991-02-03',NULL,2);

INSERT INTO College(CollegeName)
		VALUES('School of Architecture'),
			  ('College of Law'),
			  ('School of Information Studies'),
			  ('College of Engineering'),
			  ('David B. Falk Sports College ');


INSERT INTO AreaOfStudy(StudyTitle,CollegeID)
		VALUES('Architectural Design',1),
			  ('Home Design',1),
			  ('Criminal Justice',2),
			  ('Criminal Psychology',2),
			  ('Information Management',3),
			  ('Business Technologies',3),
			  ('Computer Science',4),
			  ('Electrical Engineering',4),
			  ('Biological Sciences',4),
			  ('Sports Management',5),
			  ('Sport Dynamics',5);

INSERT INTO StudentAreaOfStudy(StudentID, AreaID, IsMajor)
		VALUES(1463458,1,'Y'),
			  (1463458,4,'N'),
			  (1478523,2,'Y'),
			  (1478523,8,'N'),
			  (2454651,3,'Y'),
			  (2454651,8,'N'),
			  (2454652,9,'Y'),
			  (2454652,11,'Y'),
			  (2589634,5,'Y'),
			  (2589634,6,'Y'),
			  (2589637,7,'Y'),
			  (2589637,10,'N');

INSERT INTO BenefitSelection(Text)
		VALUES('Single'),
			  ('Family'),
			  ('Opt-Out');

INSERT INTO Benefits(BenefitCost, BenefitSelection, Description)
		VALUES(3000,1,'Comprehensive Healthcare including Emergency room treatment for the Employee'),
			  (6500,2,'Complete Healthcare and Emergency care for the family'),
			  (0,3,'Employee opted out of Healthcare'),
			  (1300,1,'Comprehensive Dental care for the Employee'),
			  (2750,2,'Complete Dental Care for the Employee and Family'),
			  (0,3,'Employee opted out of Dental Care'),
			  (1000,1,'Comprehensive Vision coverage for the Employee'),
			  (2400,2, 'Complete Vision coverage for the Employee and family'),
			  (0,3,'Employee opted out of vision coverage');

INSERT INTO Employees(EmployeeID, Ssn, YearlyPay, IsStatus,HealthBenefitsID, VisionBenefitsID, DentalBenefitsID)
		VALUES(2258857, 984563214,100000,'Y',1,4,7),
			  (1236587, 896543258,250000,'Y',2,5,8),
			  (8879653, 754638569,125000,'Y',3,5,9),
			  (1478963, 568963745,145000,'Y',2,6,7),
			  (1454651, 789623546,19000,'Y',1,6,9);
			 
INSERT INTO CourseInfo(CourseCode,CourseNumber,CourseTitle,CourseDescription)
		VALUES('ADA',484, 'Intro to Arch Design','Teaches the basics of design'),
			  ('ADA',700,'Designing a House', 'Teaches How to design a house'),
			  ('COL',325,' Basics of Criminal Justice', 'Teaches the basics of modern justice sytem'),
			  ('COL',500,'Advanced Criminal Psychology','Explains how criminal think'),
			  ('IME',226,'Basic Information Mgmt', 'Explains how to manage Information'),
			  ('IME',388,'Basic Business Tech','Teaches Basic Business methods'),
			  ('CSE',354,'Algorithms','Teaches Fundamental Algorithms'),
			  ('CSE',285,'Computer Vision', 'Teaches modern Computer Vision'),
			  ('EEE',523,'Electrical Circuits','Basics of Electricity and how our world works'),
			  ('BSC',123,'Human Anatomy','Basics of how Human Body works'),
			  ('BSC',101,'Animal and Plant Biology', 'Teaches the most fundamental aspects of biology'),
			  ('SPS',203,'Sport Physiotherapy', 'Teaches how atheletes bodies work'),
			  ('SPS',405,'Equipment Management','Teaches how various sports equipments work');

INSERT INTO Prerequisites(ParentCourseID,ChildCourseID)
		VALUES(2,1),
			  (4,3),
			  (6,5),
			  (8,7),
			  (9,7),
			  (10,11),
			  (13,12),
			  (12,10);

INSERT INTO CourseStatus(Text)
		VALUES('Regular'),
			  ('Audit'),
			  ('Pass/Fail');

INSERT INTO StudentGrades(Text)
		VALUES('A+'),
			  ('A'),
			  ('A-'),
			  ('B'),
			  ('B-'),
			  ('C'),
			  ('C-'),
			  ('D'),
			  ('F');

INSERT INTO EnrollmentInCourse(CourseID,FacultyID,StudentID,StudentCourseStatus,StudentGradeID)
		VALUES(1,2258857,1463458,1,1),
			  (2,2258857,1478523,1,NULL),
			  (3,1236587,2454651,2,NULL),
			  (4,1236587, 1463458,1,3),
			  (4,1236587 ,2454651,1,1),
			  (5,8879653 ,2589634,3,NULL),
			  (6,8879653,2589634,1,4),
			  (7,1478963,2589637,1,1),
			  (8,1478963,2589637,1,NULL),
			  (13,1454651,2589637,3,NULL),
			  (9,1478963,1478523,1,6),
			  (10,1478963,2454652,1,3),
			  (11,1478963,2454652,1,2),
			  (12,1454651,2454652,2,NULL);
			 


INSERT INTO JobInfo(JobTitle,JobDescription,MaxPay,MinPay,IsUnion)
		VALUES('Professor','Conduct Substantial research in area of interest and guide phd students',125000,85000,'N'),
			  ('Associate Professor','Teach multiple Courses and grad students',100000,74000,'N'),
			  ('Assistant Professor', 'Co-ordinate with TA and work and teach undergrad courses',85000,67000,'N'),
			  ('Department Chair','Head the department and handle various affairs',175000,110000,'N'),
			  ('Dean','Handle various university affairs and represent university positively',250000,200000,'N');

INSERT INTO Requirements(Text)
		VALUES('Determination'),
			  ('Exceptional Research Record'),
			  ('Publish Patents'),
			  ('Excellent Communication Skills'),
			  ('10+ years experience'),
			  ('20+ years experience'),
			  ('Oratory skills'),
			  ('Work with students'),
			  ('Publish papers');
			 
INSERT INTO RequirementsOfJob(JobID,RequirementID)
		VALUES(1,1),
			  (1,2),
			  (1,8),
			  (1,9),
			  (1,5),
			  (2,4),
			  (2,5),
			  (2,8),
			  (3,8),
			  (4,1),
			  (4,2),
			  (4,3),
			  (4,4),
			  (4,6),
			  (5,6),
			  (5,7),
			  (5,4);


INSERT INTO JobsAndEmployees(JobID,EmployeeID)
		VALUES(1,2258857),
			  (2,1236587),
			  (3,8879653),
			  (4,1478963),
			  (5,1454651),
			  (2,1454651),
			  (4,2258857);
			 
INSERT INTO FacultyAndCourses(FacultyID,CourseID)
		VALUES(2258857,1),
			  (2258857,2),
			  (1236587,3),
			  (1236587,4),
			  (8879653,5),
			  (8879653,6),
			  (1478963,7),
			  (1478963,8),
			  (1478963,9),
			  (1478963,10),
			  (1478963,11),
			  (1454651,12),
			  (1454651,13),
			  (8879653,7),
			  (8879653,8);


INSERT INTO ListOfBuildings(Text)
		VALUES('Colg of Arts And Sciences'),
			  ('Comp Science And Tech building'),
			  ('H.B Crouse'),
			  ('Maxwell School'),
			  ('Falk Building');

INSERT INTO ProjectorOptions(Text)
		VALUES('Basic'),
			  ('SmartBoard'),
			  ('No Projector');

INSERT INTO ClassRoom(BuildingNameID,RoomNumber,MaxSeating,ProjectorID,NoOfWhiteBoards,OtherEquipment)
		VALUES(1,'CAS-300',100,1,1,NULL),
			  (1,'CAS-125',40,2,1,NULL),
			  (2,'CST-105',65,3,2,'Speakers'),
			  (2,'CST-404',125,1,2,'Microphone'),
			  (3,'HBC-122',50,1,2,'Recorder'),
			  (3,'HBC-500',60,3,0,NULL),
			  (4,'MSC-256',75,2,2,NULL),
			  (5,'FB-105',40,1,3,NULL),
			  (5,'FB-123',85,1,1,'Microphone');

INSERT INTO CourseTimings(CourseID,StartDate,EndDate,StartTime,EndTime,ClassroomID,Seats)
		VALUES(1,'2016-08-29','2016-12-12','08:00:00','10:00:00',1,90),
			  (1,'2016-08-29','2016-12-12','14:00:00','16:00:00',1,75),
			  (2,'2016-08-30','2016-12-14','17:15:00','19:15:00',2,40),
			  (3,'2016-08-28','2016-12-08','10:15:00','11:45:00',5,40),
			  (4,'2017-01-17','2017-05-02','09:00:00','11:00:00',5,50),
			  (5,'2016-08-31','2016-12-15','12:00:00','14:00:00',7,60),
			  (5,'2017-01-19','2017-05-01','11:10:00','12:15:00',7,60),
			  (6,'2017-01-18','2017-05-03','13:15:00','14:25:00',7,55),
			  (7,'2016-08-29','2016-12-10','15:45:00','17:15:00',4,100),
			  (8,'2017-01-19','2017-05-02','18:45:00','20:15:00',3,60),
			  (9,'2016-08-28','2016-12-12','12:45:00','14:15:00',3,60),
			  (10,'2017-01-19','2017-05-02','13:15:00','14:45:00',4,50),
			  (11,'2016-09-01','2016-12-12','16:15:00','17:45:00',4,45),
			  (12,'2016-08-24','2016-12-13','08:20:00','09:40:00',8,35),
			  (13,'2016-08-25','2016-12-11','10:15:00','11:45:00',9,70);

INSERT INTO ListOfDays(Text)
		VALUES('Monday'),
			  ('Tuesday'),
			  ('Wednesday'),
			  ('Thursday'),
			  ('Friday');

INSERT INTO CourseOnDays(CourseScheduleID,DayID)
		VALUES(1,1),
			  (2,3),
			  (3,4),
			  (4,1),
			  (5,5),
			  (6,3),
			  (7,5),
			  (8,2),
			  (9,1),
			  (10,3),
			  (11,4),
			  (12,3),
			  (13,3),
			  (14,2),
			  (15,1);


									--VIEWS

/* This view shows the StudentID, the name of that student, the grade achieved by the student,
and the name of that course*/
CREATE VIEW StudentsAndCourses AS
	SELECT P.PersonID AS StudentID,P.FirstName+' '+P.LastName AS StudentName,G.Text AS Grade,C.CourseTitle
	FROM Persons P
	INNER JOIN Students S
	ON P.PersonID=S.StudentID
	INNER JOIN EnrollmentInCourse E
	ON E.StudentID=S.StudentID
	INNER JOIN StudentGrades G
	ON E.StudentGradeID=G.ID
	INNER JOIN CourseInfo C
	ON E.CourseID=C.CourseID;
SELECT * FROM StudentsAndCourses

/*This view generates the name of the employee, their yearly pay, the title of the position they're
holding and the description of that particular job*/
CREATE VIEW EmployeeJobs AS
		SELECT P.firstName+' '+P.LastName AS EmployeeName,E.YearlyPay,J.JobTitle,J.JobDescription
		FROM Persons P
		INNER JOIN Employees E
		ON P.PersonID=E.EmployeeID
		INNER JOIN JobsAndEmployees Je
		ON Je.EmployeeID=E.EmployeeID
		INNER JOIN JobInfo J
		ON J.JobID=Je.JobID
SELECT * FROM EmployeeJobs

/* This view gives the faculty name , the respective courses they're teaching and the seats in that course*/
CREATE VIEW FacultySeatsCourses AS
		SELECT P.firstName+' '+p.LastName AS FacultyName,C.CourseTitle,Ct.Seats AS NoOfSeats
		FROM Persons P
		INNER JOIN Employees E
		ON E.EmployeeID=P.PersonID
		INNER JOIN FacultyAndCourses F
		ON E.EmployeeID=F.FacultyID
		INNER JOIN  CourseInfo C
		ON C.CourseID=F.CourseID
		INNER JOIN CourseTimings Ct
		ON Ct.CourseID=C.CourseID
SELECT * FROM FacultySeatsCourses

/* This view generates the title of the course, the room-number in which that course is being held
and the name of tha building in which that room-number is there*/
CREATE VIEW CourseLocations AS
	    SELECT C.CourseTitle, Cl.RoomNumber, Lb.text AS NameOfBuilding
		FROM CourseInfo C
		INNER JOIN CourseTimings Ct
		ON Ct.CourseID=C.CourseID
		INNER JOIN ClassRoom Cl
		ON Ct.ClassRoomID=Cl.ClassRoomID
		INNER JOIN ListOfBuildings Lb
		ON Lb.ID=Cl.BuildingNameID
SELECT * FROM CourseLocations


                                  --STORED PROCEDURES

/*A Stored Procedure where an employee is enrolled into a new job. If the employee already holds 2 or more
Jobs, they won't be allowed to hold any more jobs, else we insert into the table */

CREATE PROCEDURE dbo.MultiJobs(@JobID AS INTEGER, @EmployeeID AS INTEGER)
AS
	DECLARE @numberOfJobs INTEGER

	SELECT @numberOfJobs=(SELECT COUNT(*) FROM JobsAndEmployees
						  WHERE EmployeeID=@EmployeeID 
						  GROUP BY EmployeeID
						  )
	IF (@numberOfJobs>=2)
		BEGIN

		PRINT 'ERROR-An Employee cannot be allowed to hold more than two jobs'

		END
	ELSE
		BEGIN 

		INSERT INTO JobsAndEmployees(JobID,EmployeeID)
				VALUES(@JobID,@EmployeeID);

		PRINT 'Employee Successfully Enrolled into the Job'

	END

--Procedure Execution
EXEC dbo.MultiJobs 2,2258857

/* Using this stored procedure we can update the employee benefits. It will first give a warning if the 
employee's health,vision or dental benefits are.being changed. Later it updates the benefits of the employee*/

CREATE PROCEDURE dbo.EmployeesAndBenefits(@employeeID AS INTEGER,@newHealthBenefitsID AS INTEGER,
										 @newVisionBenefitsID AS INTEGER,@newDentalBenefitsID AS INTEGER)
AS

	DECLARE @oldHealthBenefitsID INTEGER
	DECLARE @oldVisionBenefitsID INTEGER
	DECLARE @oldDentalBenefitsID INTEGER

	SELECT @oldHealthBenefitsID=(SELECT HealthBenefitsID FROM Employees WHERE EmployeeID=@employeeID)
	SELECT @oldVisionBenefitsID=(SELECT VisionBenefitsID FROM Employees WHERE EmployeeID=@employeeID)
	SELECT @oldDentalBenefitsID=(SELECT DentalBenefitsID FROM Employees WHERE EmployeeID=@employeeID)


	IF(@oldHealthBenefitsID!=@newHealthBenefitsID)
		BEGIN

		DECLARE @oldBenefit VARCHAR(20)
		SELECT @oldBenefit= (SELECT Text FROM BenefitSelection WHERE BenefitSelectionID= (SELECT BenefitSelection
																						 FROM Benefits 
																						 WHERE BenefitID=@oldHealthBenefitsID))
		DECLARE @newBenefit VARCHAR(20)
		SELECT @newBenefit= (SELECT Text FROM BenefitSelection WHERE BenefitSelectionID=(SELECT BenefitSelection
																						 FROM Benefits 
																						 WHERE BenefitID=@newHealthBenefitsID))
		PRINT 'WARNING- Employees health benefits are being changed from '+ @oldBenefit+ ' to '+ @newbenefit

		UPDATE Employees                                               --Updates employees health info
		SET HealthBenefitsID=@newHealthBenefitsID
		WHERE EmployeeID=@employeeID

		PRINT 'Health Benefits successfully updated';

		END

	
	IF(@oldVisionBenefitsID!=@newVisionBenefitsID)
		BEGIN

		DECLARE @oldBenefit1 VARCHAR(20)
		SELECT @oldBenefit1= (SELECT Text FROM BenefitSelection WHERE BenefitSelectionID=(SELECT BenefitSelection
																						 FROM Benefits 
																						 WHERE BenefitID=@oldVisionBenefitsID))
		DECLARE @newBenefit1 VARCHAR(20)
		SELECT @newBenefit1= (SELECT Text FROM BenefitSelection WHERE BenefitSelectionID=(SELECT BenefitSelection
																						 FROM Benefits 
																						 WHERE BenefitID=@newVisionBenefitsID))
		PRINT 'WARNING- Employees vision benefits are being changed from '+ @oldBenefit1+ ' to '+ @newbenefit1

		UPDATE Employees												--Updates employees Vision info
		SET VisionBenefitsID=@newVisionBenefitsID
		WHERE EmployeeID=@employeeID

		PRINT 'Vision Benefits successfully updated'
	END;

	
	IF(@oldDentalBenefitsID!=@newDentalBenefitsID)
		BEGIN

		DECLARE @oldBenefit2 VARCHAR(20)
		SELECT @oldBenefit2= (SELECT Text FROM BenefitSelection WHERE BenefitSelectionID=(SELECT BenefitSelection
																						 FROM Benefits 
																						 WHERE BenefitID=@oldDentalBenefitsID))
		DECLARE @newBenefit2 VARCHAR(20)
		SELECT @newBenefit2= (SELECT Text FROM BenefitSelection WHERE BenefitSelectionID=(SELECT BenefitSelection
																						 FROM Benefits 
																						 WHERE BenefitID=@newDentalBenefitsID))
		PRINT 'WARNING- Employees dental benefits are being changed from '+ @oldBenefit2+ ' to '+ @newbenefit2

		UPDATE Employees														--Updates employees Dental info
		SET DentalBenefitsID=@newDentalBenefitsID
		WHERE EmployeeID=@employeeID

		PRINT 'Dental Benefits successfully updated'

	END;

--Procedure Execution
EXEC dbo.EmployeesAndBenefits 1236587,1,5,9




								--FUNCTIONS

/* This calculates the effective income tax for a given employee, The tax brackets are as follows-
$0-10000- 10%
$10000-70000- 25%
$70000-200000- 30%
Greater than $200000- 35% */

CREATE FUNCTION dbo.EffectiveTax(@EmployeeID AS INTEGER)
	RETURNS FLOAT AS

	BEGIN

	DECLARE @annualPay DECIMAL(9,2)
	DECLARE @effectiveTax DECIMAL(8,2)
	SELECT @effectiveTax=0
	SELECT @annualPay=(SELECT YearlyPay FROM Employees WHERE @EmployeeID=EmployeeID)
	IF(@annualPay<=10000)
	BEGIN
		SELECT @effectiveTax=(0.1*10000)
	END

	ELSE IF(@annualPay>10000 AND @annualPay<=70000)
	BEGIN
		SELECT @effectiveTax=((0.1*10000)+(0.25*(@annualPay-10000)))
	END

	ELSE IF (@annualPay>70000 and @annualPay<=200000)
	BEGIN
		SELECT @effectiveTax=0.1*10000+0.25*60000+(0.3*(@annualPay-70000))
	END

	ELSE IF (@annualPay>200000)
	BEGIN
		SELECT @effectiveTax=0.1*10000+0.25*60000+0.3*130000+0.35*(@annualPay-200000)
	END

	RETURN @effectiveTax

END;

--Function Execution
DECLARE @tax AS DECIMAL(8,2)
SELECT @tax=dbo.EffectiveTax(1454651)
PRINT @tax


/*This function returns a table which shows the CourseTitle, the number of students the professor
is willing to enroll and the  maximum number of seats the class can hold*/

CREATE FUNCTION dbo.CourseStudents()
	RETURNS @return TABLE(CourseTitle VARCHAR(30),NoOfStudents INT, MaxSeating INT)
	BEGIN
		INSERT INTO @return
		SELECT Ci.CourseTitle,Ct.Seats,Cl.MaxSeating
		FROM CourseInfo Ci
		INNER JOIN CourseTimings Ct
		ON Ci.CourseID=Ct.CourseID
		INNER JOIN ClassRoom Cl
		ON Ct.ClassRoomID=Cl.ClassRoomID
		
	RETURN
END;

--Function Execution
SELECT * FROM dbo.CourseStudents();






