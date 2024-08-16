CREATE VIEW DimInstructor AS
SELECT i.INS_ID, i.Fname, i.Lname, i.Phone, i.Address, i.Gender, i.Age, i.Email, i.Dept_ID, i.Supervisor_ID, d.Dept_Name,b.Branch_Name
FROM Instructor i
JOIN Department d ON i.Dept_ID = d.Dept_ID
join[dbo].[Branch] b ON b.Branch_ID=d.Branch_ID;
-------------------------------------------------------------------------