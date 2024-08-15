-- Create Audit table
CREATE TABLE ExamAudit (
    Audit_ID INT PRIMARY KEY IDENTITY(1,1),
    Exam_ID INT,
    Action VARCHAR(50),
    Old_Status VARCHAR(MAX),
    New_Status VARCHAR(MAX),
    [Audit_Date] DATETIME,
	Actionn nvarchar(max)
);

-- Create Trigger
CREATE TRIGGER PreventExamEdit
ON Exam
INSTEAD OF UPDATE
AS
BEGIN
    DECLARE @Exam_ID INT, @IS_Corrective INT;

    -- Check if any rows are being updated
    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        -- Check if any of the updated exams are currently being taken by students
        SELECT @Exam_ID = Exam_ID, @IS_Corrective = IS_Corrective
        FROM inserted
        WHERE EXISTS (
            SELECT 1 
            FROM Stu_EX_Ans 
            WHERE Exam_ID = inserted.Exam_ID
        );

        -- If the exam is being taken by students, prevent the update
        IF @Exam_ID IS NOT NULL
        BEGIN
		  RAISERROR ('Cannot update exam while students are taking it.', 16, 1);
		  INSERT INTO ExamAudit (Exam_ID,[Old_Status],[New_Status],[Audit_Date],[Actionn])
          SELECT i.Exam_ID, 'UPDATE', d.Total_Grade, i.Total_Grade, GETDATE()
          FROM inserted i
          JOIN deleted d ON i.Exam_ID = d.Exam_ID;
        END;
    END;

    -- Update the Exam table
    UPDATE e
    SET Total_Grade = i.Total_Grade,
        NO_MCQ = i.NO_MCQ,
        NO_T_F = i.NO_T_F,
        Start_Date = i.Start_Date,
        End_Date = i.End_Date,
        INS_ID = i.INS_ID,
        CRS_ID = i.CRS_ID,
        IS_Normal = i.IS_Normal,
        IS_Corrective = i.IS_Corrective
    FROM Exam e
    INNER JOIN inserted i ON e.Exam_ID = i.Exam_ID;
END;
------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS PreventExamEdit;
DROP TABLE [dbo].[ExamAudit]
----------------------------------
UPDATE Exam
SET Total_Grade = 90
WHERE Exam_ID = 8;
---------------------------
SELECT * FROM [dbo].[ExamAudit]
