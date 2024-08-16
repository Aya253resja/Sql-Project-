CREATE VIEW DimQuestion_view
AS
SELECT q.Question_ID, q.Question, q.Model_Answer, e.Exam_ID, e.Total_Grade, e.Start_Date, e.End_Date
FROM Questions q
left JOIN Exam e ON q.CRS_ID = e.CRS_ID;
---------------------------------------------------------
