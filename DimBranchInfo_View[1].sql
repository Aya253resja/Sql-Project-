CREATE VIEW DimBranchInfo
AS
SELECT b.Branch_ID, b.Branch_Name, d.Dept_ID,TB.Track_Name
FROM Branch b 
JOIN Department d ON b.Branch_ID = d.Branch_ID
join [dbo].[Track_branch] TB ON TB.Branch_id=b.Branch_ID;
---------------------------------------------------------