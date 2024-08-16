
----------------------------------------------
CREATE VIEW StudentResultsView 
AS
SELECT sr.student_id,
i.[INS_ID] ,
i.[Dept_ID],
i.[Supervisor_ID],
sr.total_grade as student_Exam_grade,
e.[CRS_ID],
sr.result_rating, 
sr.Exam_ID,
E.Total_Grade AS Exam_Total_Grade
,tr.[mgr_id],q.[Question_ID],
t.[Track_id],
t. [Branch_id],
it.[Intake_ID]
FROM  [dbo].[student_results] as sr
left join Exam E On E.Exam_ID=sr.Exam_ID
left join [dbo].[Instructor] i on i.INS_ID=e.INS_ID
left join  [dbo].[Student] s on sr.student_id=s.Student_ID
left join [dbo].[Track_branch] t on s.Track_ID=t.Track_id
left join [dbo].[training_manager] tr on tr.branch_id=t.Branch_id
left join [dbo].[Questions] q on e.CRS_ID=q.CRS_ID
left join [dbo].[Intake] it on t.Branch_id= it .Branch_ID
