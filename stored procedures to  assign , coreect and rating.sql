
--------------------------------------------------Stored Procedures for Assign exam and  correct and Rating Exam ------------------
---------------------------------------------------Inser Random Exam -------------------------------
use[ExaminationSystem];
CREATE OR ALTER PROCEDURE [dbo].[generate_random_exam_proc]
    @Exam_ID int OUTPUT,
    @Total_Grade int,
    @Type int,
    @Start_Date datetime,
    @End_Date datetime,
    @INS_ID int,
    @CRS_ID int
AS
BEGIN
    -- Check if the provided Instructor ID exists
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE INS_ID = @INS_ID)
    BEGIN
        PRINT 'Instructor does not exist';
        RETURN;
    END

    -- Check if the provided Course ID exists
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CRS_ID = @CRS_ID)
    BEGIN
        PRINT 'Course does not exist';
        RETURN;
    END

    -- Generate a unique Exam_ID
    DECLARE @ExamID int;
    SELECT @ExamID = ISNULL(MAX(Exam_ID), 0) + 1 FROM Exam;

    -- Insert exam information into the Exam table
    INSERT INTO Exam (Exam_ID, Total_Grade, [IS_Normal], NO_MCQ, NO_T_F, Start_Date, End_Date, INS_ID, CRS_ID)
    VALUES (@ExamID, @Total_Grade, @Type, 5, 5, @Start_Date, @End_Date, @INS_ID, @CRS_ID);

-- Select random 5 MCQ questions
INSERT INTO [dbo].[Ex_Questions] (Exam_ID, Question_ID, Grade, CRS_ID)
SELECT TOP 5 @ExamID, Question_ID, Grade, CRS_ID
FROM Questions
WHERE CRS_ID = @CRS_ID AND MCQ = 1
      AND Question_ID NOT IN (SELECT Question_ID FROM [dbo].[Ex_Questions] WHERE Exam_ID = @ExamID)
ORDER BY NEWID(); 

-- Select random 5 T/F questions
INSERT INTO [dbo].[Ex_Questions] (Exam_ID, Question_ID, Grade, CRS_ID)
SELECT TOP 5 @ExamID, Question_ID, Grade, CRS_ID
FROM Questions
WHERE CRS_ID = @CRS_ID AND T_F = 1
      AND Question_ID NOT IN (SELECT Question_ID FROM [dbo].[Ex_Questions] WHERE Exam_ID = @ExamID)
ORDER BY NEWID();


    SET @Exam_ID = @ExamID; -- Assign the generated Exam_ID to the output parameter

    PRINT 'Random exam created successfully';
END;

DECLARE @ExamID int;
EXEC generate_random_exam_proc 
    @Exam_ID = @ExamID OUTPUT,
    @Total_Grade = 100,
    @Type = 1,
    @Start_Date = '2024-03-01',
    @End_Date = '2024-03-02',
    @INS_ID = 1,  -- Assuming the Instructor ID exists in the database
    @CRS_ID = 102;  -- Assuming the Course ID exists in the database
-----------------------------------------------------------------
---------------------------------------------Create manual Ex----------------------
CREATE OR ALTER PROCEDURE create_manual_exam_proc
    @Exam_ID int OUTPUT,
    @Total_Grade int,
    @Type int,
    @Start_Date datetime,
    @End_Date datetime,
    @INS_ID int,
    @CRS_ID int,
    @MCQ_Question_IDs varchar(MAX),
    @T_F_Question_IDs varchar(MAX)
AS
BEGIN
    -- Generate a unique Exam_ID
    DECLARE @ExamID int;
    SELECT @ExamID = ISNULL(MAX(Exam_ID), 0) + 1 FROM Exam;

    -- Check if the provided Instructor ID exists
    IF NOT EXISTS (SELECT 1 FROM Instructor WHERE INS_ID = @INS_ID)
    BEGIN
        PRINT 'Instructor does not exist';
        RETURN;
    END;

    -- Check if the provided Course ID exists
    IF NOT EXISTS (SELECT 1 FROM Course WHERE CRS_ID = @CRS_ID)
    BEGIN
        PRINT 'Course does not exist';
        RETURN;
    END;

    -- Insert exam information into the Exam table
    INSERT INTO Exam (Exam_ID, Total_Grade, [IS_Normal], NO_MCQ, NO_T_F, Start_Date, End_Date, INS_ID, CRS_ID)
    VALUES (@ExamID, @Total_Grade, @Type, 5, 5, @Start_Date, @End_Date, @INS_ID, @CRS_ID);

    -- Insert selected MCQ questions
    INSERT INTO [dbo].[Ex_Questions] (Exam_ID, Question_ID, Grade, CRS_ID)
    SELECT @ExamID, CAST(value AS int), Grade, @CRS_ID
    FROM STRING_SPLIT(@MCQ_Question_IDs, ',') 
    JOIN Questions ON CAST(value AS int) = Questions.Question_ID
    WHERE CRS_ID = @CRS_ID;

    -- Insert selected T/F questions
    INSERT INTO [dbo].[Ex_Questions] (Exam_ID, Question_ID, Grade, CRS_ID)
    SELECT @ExamID, CAST(value AS int), Grade, @CRS_ID
    FROM STRING_SPLIT(@T_F_Question_IDs, ',') 
    JOIN Questions ON CAST(value AS int) = Questions.Question_ID
    WHERE CRS_ID = @CRS_ID;

    PRINT 'Exam created successfully with selected questions';
    SET @Exam_ID = @ExamID; -- Assign the generated Exam_ID to the output parameter
END;

	DECLARE @NewExamID int;
EXEC create_manual_exam_proc 
    @Exam_ID = @NewExamID OUTPUT,
    @Total_Grade = 100,
    @Type = 1,
    @Start_Date = '2024-03-03  02:00:00'   ,
    @End_Date = '2024-03-03  04:00:00 ',
    @INS_ID = 1,
    @CRS_ID = 104,
    @MCQ_Question_IDs = '38,41,42,43,44',
    @T_F_Question_IDs = '36,37,39,40,51';

	select  ex.[CRS_ID],ex.[Question_ID],q.[Question]from  [dbo].[Ex_Questions] ex  join [dbo].[Questions]  q
	on ex.[Question_ID]=q.[Question_ID]
	where ex.[CRS_ID]=102;
----------------------------- --------------------01---Save students Answers ----------------------------
CREATE OR ALTER PROCEDURE SaveStudentExamAnswers
    @Ex_No INT,
    @Std_ID INT,
    @ques_ID INT,
    @Std_Ans NVARCHAR(MAX),
	@student_enter_exam_date DATETIME
AS
BEGIN TRY
    IF NOT EXISTS (SELECT * FROM Exam WHERE Exam_ID = @Ex_No)
    BEGIN
        SELECT 'The exam does not exist' AS ErrMessage;
    END
    ELSE IF NOT EXISTS (SELECT * FROM Student WHERE Student_ID = @Std_ID)
    BEGIN
        SELECT 'The student does not exist' AS ErrMessage;
    END
    ELSE
    BEGIN
        DECLARE @ExamStart DATETIME, @ExamEnd DATETIME;
        SELECT @ExamStart = Start_Date, @ExamEnd = End_Date FROM dbo.Exam WHERE Exam_ID = @Ex_No; 
        IF @student_enter_exam_date < @ExamEnd
        BEGIN
            INSERT INTO dbo.Stu_EX_Ans (Student_ID, Exam_ID, Student_Answer, Question_ID)
            VALUES (@Std_ID, @Ex_No, @Std_Ans, @ques_ID);
            PRINT 'Answer saved successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Cannot access the exam, time out.';
        END
    END
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 202, @Std_Ans = 'F', @student_enter_exam_date='2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 203, @Std_Ans = 'F', @student_enter_exam_date='2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 204, @Std_Ans = '0', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 205, @Std_Ans = 'F', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 206, @Std_Ans = '0', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID =207, @Std_Ans = '0', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 208, @Std_Ans = 'a', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 209, @Std_Ans = '0', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 210, @Std_Ans = '0', @student_enter_exam_date = '2024-03-01 03:00:00';
Exec SaveStudentExamAnswers @Ex_No = 11, @Std_ID =36, @ques_ID = 211, @Std_Ans = '0', @student_enter_exam_date = '2024-03-01 03:00:00';
---------------------------------------------------------------Savestudentanswers2-----------------
CREATE OR ALTER PROCEDURE SaveStudentExamAnswer
    @Ex_No INT,
    @Std_ID INT,
    @ques_ID INT,
    @Std_Ans NVARCHAR(MAX)
AS
BEGIN TRY
    IF NOT EXISTS (SELECT * FROM Exam WHERE Exam_ID = @Ex_No)
    BEGIN
        SELECT 'The exam does not exist' AS ErrMessage;
    END
    ELSE IF NOT EXISTS (SELECT * FROM Student WHERE Student_ID = @Std_ID)
    BEGIN
        SELECT 'The student does not exist' AS ErrMessage;
    END
    ELSE
    BEGIN
	   DECLARE @@student_enter_exam_date DATETIME 
        DECLARE @ExamStart DATETIME, @ExamEnd DATETIME;
        SELECT @ExamStart = Start_Date, @ExamEnd = End_Date FROM dbo.Exam WHERE Exam_ID = @Ex_No; 
        IF @@student_enter_exam_date < @ExamEnd
        BEGIN
            INSERT INTO dbo.Stu_EX_Ans (Student_ID, Exam_ID, Student_Answer, Question_ID)
            VALUES (@Std_ID, @Ex_No, @Std_Ans, @ques_ID);
            PRINT 'Answer saved successfully.';
        END
        ELSE
        BEGIN
            PRINT 'Cannot access the exam, time out.';
        END
    END
END TRY
BEGIN CATCH
    SELECT ERROR_MESSAGE() AS ErrorMessage;
END CATCH;
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 131, @Std_Ans = 'a';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 132, @Std_Ans = 'd';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 133, @Std_Ans = 'd';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 134, @Std_Ans = 'b';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 135, @Std_Ans = 'd';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 136, @Std_Ans = 'T';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 137, @Std_Ans = 'F';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 138, @Std_Ans = 'T';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 139, @Std_Ans = 'T';
Exec SaveStudentExamAnswers @Ex_No = 14, @Std_ID = 4, @ques_ID = 140, @Std_Ans = 'F';
-----------------------------------------------Correct Exam --------------------------------------
CREATE OR ALTER PROCEDURE CorrectMCQQuestions
(
  @examID INT
)
AS
BEGIN
  -- Update student's grades for MCQ questions in the specified exam
  UPDATE Stu_EX_Ans
  SET Grade = 
      CASE 
        WHEN UPPER(Stu_EX_Ans.Student_Answer) = UPPER(Questions.Model_Answer) THEN 10 -- Correct answer
        ELSE 0 -- Incorrect answer
      END
  FROM Stu_EX_Ans
  INNER JOIN Questions ON Stu_EX_Ans.Question_ID = Questions.Question_ID
  WHERE Stu_EX_Ans.Exam_ID = @examID;
 -- Filter by Exam_ID and Course_ID

END;
Exec CorrectMCQQuestions @examID =11

-------------------------------------------------calculte Total)_Grade and rating ---------------
USE [ExaminationSystem]
GO

CREATE OR ALTER PROCEDURE CalculateTotalGradeAndRate
(     
    @StudentID INT,
    @ExamID INT
)
AS 
BEGIN
    DECLARE @TotalGrade INT;
    DECLARE @Rating VARCHAR(50);

    -- Calculate total grade for the student in the specified exam
    SELECT @TotalGrade = SUM(Grade) 
    FROM Stu_EX_Ans
    WHERE Student_ID = @StudentID AND Exam_ID = @ExamID;

    -- Insert the Total_Grade and Rating into the student_results table
    INSERT INTO [dbo].[student_results] (Student_ID, Exam_ID, total_grade, result_rating)
    VALUES (@StudentID, @ExamID, @TotalGrade, 
            CASE
                WHEN @TotalGrade >= 90 THEN 'A'
                WHEN @TotalGrade >= 80 THEN 'B'
                WHEN @TotalGrade >= 70 THEN 'C'
                WHEN @TotalGrade >= 60 THEN 'D'
                ELSE 'corrective'
            END);
END;


exec CalculateTotalGradeAndRate 17,11
exec CalculateTotalGradeAndRate 18,11
exec CalculateTotalGradeAndRate 19,11
exec CalculateTotalGradeAndRate 20,11
exec CalculateTotalGradeAndRate 21,11
exec CalculateTotalGradeAndRate 22,11
exec CalculateTotalGradeAndRate 23,11
exec CalculateTotalGradeAndRate 27,11
exec CalculateTotalGradeAndRate 28,11
exec CalculateTotalGradeAndRate 29,11
exec CalculateTotalGradeAndRate 30,11
exec CalculateTotalGradeAndRate 31,11
exec CalculateTotalGradeAndRate 32,11
exec CalculateTotalGradeAndRate 33,11
exec CalculateTotalGradeAndRate 34,11
exec CalculateTotalGradeAndRate 35,11
exec CalculateTotalGradeAndRate 36,11
-------------------------------------Assaign  corrective Exam to student  ------------------------
CREATE OR ALTER PROC AssignStudentToExams
(
    @studentId INT,
    @examId INT,
    @Total_Grade INT,
    @Type INT,
    @Start_Date DATETIME,
    @End_Date DATETIME,
    @INS_ID INT,
    @new_exam_id INT
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE Student_ID = @studentId)
    BEGIN
        PRINT 'Student does not exist';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Exam WHERE Exam_ID = @examId)
    BEGIN
        PRINT 'Exam does not exist';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM [dbo].[Stu_EX_Ans] WHERE Student_ID = @studentId AND Exam_ID = @new_exam_id)
    BEGIN
        PRINT 'Student already assigned to this exam';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Exam WHERE Exam_ID = @new_exam_id)
    BEGIN
        PRINT 'New exam ID already exists';
        RETURN;
    END

    DECLARE @CRS_ID_Value INT;
    SELECT @CRS_ID_Value = [CRS_ID] FROM exam WHERE Exam_ID = @examId;

    INSERT INTO Exam (Exam_ID, Total_Grade, [IS_Corrective], NO_MCQ, NO_T_F, Start_Date, End_Date, INS_ID, CRS_ID)
    VALUES (@new_exam_id, @Total_Grade, @Type, 5, 5, @Start_Date, @End_Date, @INS_ID, @CRS_ID_Value);

    PRINT 'Student added to exam successfully'; 
END;

EXEC AssignStudentToExams 
    @examId = 8,
    @new_exam_id = 20,
    @Total_Grade = 100,
    @Type = 1,
    @Start_Date = '2024-03-01',
    @End_Date = '2024-03-02',
    @INS_ID = 1,
    @studentId = 10;
-----------------------------------------------------------------------add corrective 2-------------------------------
CREATE OR ALTER PROC AssignStudentToExams
(
    @studentId INT,
    @examId INT,
    @Total_Grade INT,
    @Type INT,
    @Start_Date DATETIME,
    @End_Date DATETIME,
    @INS_ID INT,
    @new_exam_id INT
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Student WHERE Student_ID = @studentId)
    BEGIN
        PRINT 'Student does not exist';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Exam WHERE Exam_ID = @examId)
    BEGIN
        PRINT 'Exam does not exist';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM [dbo].[Stu_EX_Ans] WHERE Student_ID = @studentId AND Exam_ID = @examId)
    BEGIN
        PRINT 'Student already assigned to this exam';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM Exam WHERE Exam_ID = @new_exam_id)
    BEGIN
        PRINT 'New exam ID already exists';
        RETURN;
    END

    -- Check if the student's result is corrective
    IF EXISTS (SELECT 1 FROM [dbo].[student_results] WHERE Student_ID = @studentId AND Exam_ID = @examId AND[result_rating] = 'corrective')
    BEGIN
        PRINT 'Student has a corrective result for this exam';
        RETURN;
    END

    DECLARE @CRS_ID_Value INT;
    SELECT @CRS_ID_Value = [CRS_ID] FROM exam WHERE Exam_ID = @examId;

    INSERT INTO Exam (Exam_ID, Total_Grade, [IS_Corrective], NO_MCQ, NO_T_F, Start_Date, End_Date, INS_ID, CRS_ID)
    VALUES (@new_exam_id, @Total_Grade, @Type, 5, 5, @Start_Date, @End_Date, @INS_ID, @CRS_ID_Value);

    PRINT 'Student added to exam successfully'; 
END;

	-------------------------------------------------Stored to evaluate course -------------------
CREATE OR ALTER PROCEDURE Course_evaluation 
(
    @st_id INT,
    @Crd_id INT,
    @rating VARCHAR(50)
)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Student] WHERE [Student_ID] = @st_id)
    BEGIN
        PRINT 'Student does not exist';
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Course] WHERE [CRS_ID] = @Crd_id)
    BEGIN
        PRINT 'Course does not exist';
        RETURN;
    END

    INSERT INTO [dbo].[Stu_CRS_Evaluate] ([Student_ID], [CRS_ID], [Rate])
    SELECT @st_id, @Crd_id, @rating
    WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Stu_CRS_Evaluate] WHERE [Student_ID] = @st_id AND [CRS_ID] = @Crd_id);
END;
exec Course_evaluation      @st_id =1 ,@Crd_id=100 ,@rating='good' 
exec Course_evaluation      @st_id =1 ,@Crd_id=101 ,@rating='excellent' 
exec Course_evaluation      @st_id =1 ,@Crd_id=102 ,@rating='v.good' 
exec Course_evaluation      @st_id =1 ,@Crd_id=103 ,@rating='bad' 
exec Course_evaluation      @st_id =1 ,@Crd_id=104 ,@rating='good' 
exec Course_evaluation      @st_id =1 ,@Crd_id=105 ,@rating='v.good' 
exec Course_evaluation      @st_id =1 ,@Crd_id=106 ,@rating='excellent ' 
--------------------------------------------------------stored_course_student_grades--------------------------------------
CREATE OR ALTER PROCEDURE stored_course_student_grades
(
    @st_id INT,
    @crs_id INT
)
AS
BEGIN
    -- Check if the student exists
    IF NOT EXISTS (SELECT 1 FROM [dbo].[Student] WHERE [Student_ID] = @st_id)
    BEGIN
        PRINT 'Student does not exist';
        RETURN;
    END

    -- Insert student grades into Stu_CRS_Evaluate
    INSERT INTO  [dbo].[Stu_CRS]([Student_ID], [CRS_ID], [Grade])
    SELECT @st_id, @crs_id, [total_grade] 
    FROM [dbo].[student_results]
    WHERE [Student_ID] = @st_id; -- assuming you want to fetch the grade for the given student
END;



exec stored_course_student_grades @st_id =17,@crs_id=110
exec stored_course_student_grades @st_id =18,@crs_id=110
exec stored_course_student_grades @st_id =19,@crs_id=110
exec stored_course_student_grades @st_id =20,@crs_id=110
exec stored_course_student_grades @st_id =21,@crs_id=110
exec stored_course_student_grades @st_id =22,@crs_id=110
exec stored_course_student_grades @st_id =23,@crs_id=110
exec stored_course_student_grades @st_id =24,@crs_id=110
exec stored_course_student_grades @st_id =25,@crs_id=110
exec stored_course_student_grades @st_id =26,@crs_id=110
exec stored_course_student_grades @st_id =27,@crs_id=110
exec stored_course_student_grades @st_id =28,@crs_id=110
exec stored_course_student_grades @st_id =29,@crs_id=110
exec stored_course_student_grades @st_id =30,@crs_id=110
exec stored_course_student_grades @st_id =31,@crs_id=110
exec stored_course_student_grades @st_id =32,@crs_id=110
exec stored_course_student_grades @st_id =33,@crs_id=110
exec stored_course_student_grades @st_id =34,@crs_id=110
exec stored_course_student_grades @st_id =35,@crs_id=110
exec stored_course_student_grades @st_id =36,@crs_id=110