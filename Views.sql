Create or alter view InstructorInfooo
as
select Inst.[INS_ID],Inst.[Fname],Inst.[Lname],
Inst.Gender,
Inst.[Address],
Inst.[Email],
Inst.[Age],
Inst.[Phone],
COU.[CRS_Name]
from Instructor Inst join 
 Course COU
on COU.INS_ID=Inst.INS_ID

select * from InstructorInfooo
----------------------------------------------------------------------------
create or alter  view StudentinCorrective
as
select s.[Student_ID],
s.[Fname],
s.[Lname],
s.[Phone],
s.Track_ID,
C.[Min],
C.[CRS_Name],
STC.[Grade],
E.Exam_id
from Student s join [dbo].[Stu_CRS] STC 
on s.[Student_ID] =STC.[Student_ID] join Exam E 
on E.[CRS_ID]=STC.[CRS_ID]join Course C
on C.[CRS_ID] = E.[CRS_ID]
where STC.grade < C.[Min]

select * from StudentinCorrective
-----------------------------------------------------------------------
select * from [dbo].[Stu_CRS]
create view coursePerformance 
as 
select C.[CRS_ID],
C.[CRS_Name],
count(STC.Student_ID) as Total_students,
Avg(STC.[Grade]) as Average_degree
From Course C join [dbo].[Stu_CRS] STC
on c.[CRS_ID] =STC.[CRS_ID]
group by C.[CRS_ID] ,C.[CRS_Name]
select * from coursePerformance 
------------------------------------------------------------------------
