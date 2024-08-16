CREATE VIEW DimCourse_info AS
SELECT c.CRS_ID, c.CRS_Name, c.Min, c.Max, c.Credit_Hours, c.INS_ID, c.Track_ID, t.Track_Name
FROM Course c
JOIN Track t ON c.Track_ID = t.Track_ID;
---------------------------------------------------