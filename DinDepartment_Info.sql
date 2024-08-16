CREATE VIEW DimDepartment_Info AS
SELECT d.Dept_ID, d.Dept_Name, d.Branch_ID, b.Branch_Name
FROM Department d
JOIN Branch b ON d.Branch_ID = b.Branch_ID;
--------------------------------------------------------------------