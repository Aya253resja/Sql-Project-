CREATE VIEW DimExamm AS
SELECT e.Exam_ID, e.Total_Grade, e.NO_MCQ, e.NO_T_F, e.Start_Date, e.End_Date, e.INS_ID, e.CRS_ID, e.IS_Normal, e.IS_Corrective, c.CRS_Name, i.Fname AS Instructor_Fname, i.Lname AS Instructor_Lname
FROM Exam e
LEFT JOIN Course c ON e.CRS_ID = c.CRS_ID
LEFT JOIN Instructor i ON e.INS_ID = i.INS_ID;
