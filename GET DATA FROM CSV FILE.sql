CREATE  or alter PROCEDURE EvaluateAllCourses
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StudentID INT;
    DECLARE @CRSID INT;
    
    -- Declare cursor to loop through students
    DECLARE StudentCursor CURSOR FOR
    SELECT Student_ID
    FROM Stu_CRS;
    
    -- Begin transaction
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Open the cursor
        OPEN StudentCursor;
        
        -- Fetch the first row from the cursor
        FETCH NEXT FROM StudentCursor INTO @StudentID;
        
        -- Start the loop
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Declare cursor to loop through courses assigned to the current student
            DECLARE CourseCursor CURSOR FOR
            SELECT CRS_ID
            FROM Stu_CRS
            WHERE Student_ID = @StudentID;
            
            -- Open the course cursor
            OPEN CourseCursor;
            
            -- Fetch the first row from the course cursor
            FETCH NEXT FROM CourseCursor INTO @CRSID;
            
            -- Evaluate each course assigned to the current student
            WHILE @@FETCH_STATUS = 0
            BEGIN
                -- Check if the student has already evaluated the course
                IF NOT EXISTS (SELECT 1 FROM Stu_CRS_Evaluate WHERE Student_ID = @StudentID AND CRS_ID = @CRSID)
                BEGIN
                    -- If the student hasn't evaluated the course yet, insert the evaluation result into the Stu_CRS_Evaluate table
                    INSERT INTO Stu_CRS_Evaluate (Student_ID, CRS_ID, Rate)
                    VALUES (@StudentID, @CRSID, 'Evaluation Result');
                    
                    PRINT CONCAT('Student ', @StudentID, ' evaluated course ', @CRSID);
                END;
                
                -- Fetch the next row from the course cursor
                FETCH NEXT FROM CourseCursor INTO @CRSID;
            END;
            
            -- Close and deallocate the course cursor
            CLOSE CourseCursor;
            DEALLOCATE CourseCursor;
            
            -- Fetch the next row from the student cursor
            FETCH NEXT FROM StudentCursor INTO @StudentID;
        END;
        
        -- Commit the transaction
        COMMIT TRANSACTION;
        
        -- Close and deallocate the student cursor
        CLOSE StudentCursor;
        DEALLOCATE StudentCursor;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if an error occurs
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Print error message
        PRINT 'An error occurred during course evaluation: ' + ERROR_MESSAGE();
    END CATCH;
END
-------------------------------
exec EvaluateAllCourses;
---------------------------------
CREATE PROCEDURE UpdateEvaluationResultsFromCSV
AS
BEGIN
    SET NOCOUNT ON;

    -- Create a temporary table to hold CSV data
    CREATE TABLE #TempEvaluationResults (
        Student_ID INT,
        CRS_ID INT,
        Rate NVARCHAR(MAX)
    );

    -- Import CSV data into the temporary table
    BULK INSERT #TempEvaluationResults
    FROM 'C:\Users\Aya Rashdan\Desktop\Sql Project\data 2.csv'
    WITH (
        FIELDTERMINATOR = ',',  
        ROWTERMINATOR = '\n',  
        FIRSTROW = 2
    );

    DECLARE @StudentID INT;
    DECLARE @CRSID INT;
    DECLARE @Rate NVARCHAR(MAX);

    -- Declare cursor to loop through temporary table
    DECLARE EvaluationCursor CURSOR FOR
    SELECT Student_ID, CRS_ID, Rate
    FROM #TempEvaluationResults;

    -- Open the cursor
    OPEN EvaluationCursor;

    -- Fetch the first row from the cursor
    FETCH NEXT FROM EvaluationCursor INTO @StudentID, @CRSID, @Rate;

    -- Start the loop
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Check if the evaluation record already exists for the student and course
        IF EXISTS (SELECT 1 FROM Stu_CRS_Evaluate WHERE Student_ID = @StudentID AND CRS_ID = @CRSID)
        BEGIN
            -- Update the existing evaluation record
            UPDATE Stu_CRS_Evaluate
            SET Rate = @Rate
            WHERE Student_ID = @StudentID AND CRS_ID = @CRSID;

            PRINT CONCAT('Updated evaluation result for Student ', @StudentID, ' and Course ', @CRSID);
        END
        ELSE
        BEGIN
            -- Insert a new evaluation record
            INSERT INTO Stu_CRS_Evaluate (Student_ID, CRS_ID, Rate)
            VALUES (@StudentID, @CRSID, @Rate);

            PRINT CONCAT('Inserted evaluation result for Student ', @StudentID, ' and Course ', @CRSID);
        END;

        -- Fetch the next row from the cursor
        FETCH NEXT FROM EvaluationCursor INTO @StudentID, @CRSID, @Rate;
    END;

    -- Close and deallocate the cursor
    CLOSE EvaluationCursor;
    DEALLOCATE EvaluationCursor;

    -- Drop the temporary table
    DROP TABLE #TempEvaluationResults;
END
-----------------------------
execute UpdateEvaluationResultsFromCSV;