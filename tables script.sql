USE [ExaminationSystem]
GO
/****** Object:  Table [dbo].[Branch]    Script Date: 3/6/2024 10:07:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Branch](
	[Branch_ID] [int] NOT NULL,
	[Branch_Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Branch_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Course]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Course](
	[CRS_ID] [int] NOT NULL,
	[CRS_Name] [varchar](100) NULL,
	[Min] [int] NULL,
	[Max] [int] NULL,
	[Credit_Hours] [int] NULL,
	[INS_ID] [int] NULL,
	[Track_ID] [int] NULL,
 CONSTRAINT [PK__Course__AA9750031E9148FB] PRIMARY KEY CLUSTERED 
(
	[CRS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Crs_Topics]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Crs_Topics](
	[Crs_ID] [int] NULL,
	[Crs_Name] [nvarchar](max) NULL,
	[Topics] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Department]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Department](
	[Dept_ID] [int] NOT NULL,
	[Dept_Name] [varchar](50) NULL,
	[Branch_ID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[Dept_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ex_Questions]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ex_Questions](
	[Exam_ID] [int] NULL,
	[Question_ID] [int] NULL,
	[Grade] [int] NULL,
	[CRS_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Exam]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Exam](
	[Exam_ID] [int] NOT NULL,
	[Total_Grade] [int] NULL,
	[NO_MCQ] [int] NULL,
	[NO_T_F] [int] NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[INS_ID] [int] NULL,
	[CRS_ID] [int] NULL,
	[IS_Normal] [int] NULL,
	[IS_Corrective] [int] NULL,
 CONSTRAINT [PK__Exam__C782CA79890919FC] PRIMARY KEY CLUSTERED 
(
	[Exam_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Instructor]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructor](
	[INS_ID] [int] NOT NULL,
	[Fname] [varchar](50) NULL,
	[Lname] [varchar](50) NULL,
	[Phone] [int] NULL,
	[Address] [varchar](100) NULL,
	[Gender] [varchar](10) NULL,
	[Age] [int] NULL,
	[Email] [varchar](100) NULL,
	[Dept_ID] [int] NULL,
	[Supervisor_ID] [int] NULL,
 CONSTRAINT [PK__Instruct__A3DBF5718AE300C2] PRIMARY KEY CLUSTERED 
(
	[INS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Intake]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Intake](
	[Intake_ID] [int] NOT NULL,
	[Intake_Duration] [date] NOT NULL,
	[Branch_ID] [int] NULL,
 CONSTRAINT [PK__Intake__D7826D7A83392435] PRIMARY KEY CLUSTERED 
(
	[Intake_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Questions]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questions](
	[Question_ID] [int] NOT NULL,
	[Question] [varchar](max) NULL,
	[Model_Answer] [varchar](255) NULL,
	[T_F] [varchar](max) NULL,
	[MCQ] [varchar](max) NULL,
	[Grade] [int] NULL,
	[CRS_ID] [int] NULL,
 CONSTRAINT [PK__Question__B0B2E4C6F224639C] PRIMARY KEY CLUSTERED 
(
	[Question_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stu_CRS]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stu_CRS](
	[Student_ID] [int] NOT NULL,
	[CRS_ID] [int] NOT NULL,
	[Grade] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stu_CRS_Evaluate]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stu_CRS_Evaluate](
	[Student_ID] [int] NOT NULL,
	[CRS_ID] [int] NOT NULL,
	[Rate] [nvarchar](max) NULL,
 CONSTRAINT [PK__Stu_CRS___885D9CAC9B247067] PRIMARY KEY CLUSTERED 
(
	[Student_ID] ASC,
	[CRS_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Stu_EX_Ans]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Stu_EX_Ans](
	[exam_id] [int] NULL,
	[Student_ID] [int] NOT NULL,
	[Grade] [int] NULL,
	[Student_Answer] [varchar](255) NULL,
	[Question_ID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Student]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Student](
	[Student_ID] [int] NOT NULL,
	[Fname] [varchar](50) NULL,
	[Lname] [varchar](50) NULL,
	[Phone] [varchar](20) NULL,
	[Address] [varchar](100) NULL,
	[Position] [varchar](50) NULL,
	[Link] [varchar](100) NULL,
	[Freelance_status] [int] NULL,
	[Company_Name] [varchar](100) NULL,
	[Gender] [varchar](10) NULL,
	[Graduation_Year] [int] NULL,
	[Birth_Date] [date] NULL,
	[Track_ID] [int] NULL,
	[Hiring_Status] [int] NULL,
	[certificate_status] [int] NULL,
 CONSTRAINT [PK__Student__A2F4E9AC8C4BD79B] PRIMARY KEY CLUSTERED 
(
	[Student_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[student_results]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[student_results](
	[student_id] [int] NULL,
	[total_grade] [int] NULL,
	[result_rating] [varchar](max) NULL,
	[Exam_ID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Track]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Track](
	[Track_ID] [int] NOT NULL,
	[Track_Name] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Track_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Track_branch]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Track_branch](
	[Track_id] [int] NULL,
	[Branch_id] [int] NULL,
	[branch_name] [nvarchar](max) NULL,
	[Track_name] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[training_manager]    Script Date: 3/6/2024 10:07:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[training_manager](
	[mgr_id] [int] IDENTITY(1,1) NOT NULL,
	[mgr_name] [nvarchar](30) NULL,
	[branch_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[mgr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [FK__Course__INS_ID__4AB81AF0] FOREIGN KEY([INS_ID])
REFERENCES [dbo].[Instructor] ([INS_ID])
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK__Course__INS_ID__4AB81AF0]
GO
ALTER TABLE [dbo].[Course]  WITH CHECK ADD  CONSTRAINT [FK__Course__Track_ID__4BAC3F29] FOREIGN KEY([Track_ID])
REFERENCES [dbo].[Track] ([Track_ID])
GO
ALTER TABLE [dbo].[Course] CHECK CONSTRAINT [FK__Course__Track_ID__4BAC3F29]
GO
ALTER TABLE [dbo].[Crs_Topics]  WITH CHECK ADD  CONSTRAINT [FK_Crs_Topics_Course] FOREIGN KEY([Crs_ID])
REFERENCES [dbo].[Course] ([CRS_ID])
GO
ALTER TABLE [dbo].[Crs_Topics] CHECK CONSTRAINT [FK_Crs_Topics_Course]
GO
ALTER TABLE [dbo].[Department]  WITH CHECK ADD FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
ALTER TABLE [dbo].[Ex_Questions]  WITH CHECK ADD  CONSTRAINT [FK_Ex_Questions_Exam] FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Ex_Questions] CHECK CONSTRAINT [FK_Ex_Questions_Exam]
GO
ALTER TABLE [dbo].[Ex_Questions]  WITH CHECK ADD  CONSTRAINT [FK_Ex_Questions_Questions1] FOREIGN KEY([Question_ID])
REFERENCES [dbo].[Questions] ([Question_ID])
GO
ALTER TABLE [dbo].[Ex_Questions] CHECK CONSTRAINT [FK_Ex_Questions_Questions1]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK__Exam__CRS_ID__52593CB8] FOREIGN KEY([CRS_ID])
REFERENCES [dbo].[Course] ([CRS_ID])
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK__Exam__CRS_ID__52593CB8]
GO
ALTER TABLE [dbo].[Exam]  WITH CHECK ADD  CONSTRAINT [FK__Exam__INS_ID__5165187F] FOREIGN KEY([INS_ID])
REFERENCES [dbo].[Instructor] ([INS_ID])
GO
ALTER TABLE [dbo].[Exam] CHECK CONSTRAINT [FK__Exam__INS_ID__5165187F]
GO
ALTER TABLE [dbo].[Instructor]  WITH CHECK ADD  CONSTRAINT [FK__Instructo__Dept___440B1D61] FOREIGN KEY([Dept_ID])
REFERENCES [dbo].[Department] ([Dept_ID])
GO
ALTER TABLE [dbo].[Instructor] CHECK CONSTRAINT [FK__Instructo__Dept___440B1D61]
GO
ALTER TABLE [dbo].[Instructor]  WITH CHECK ADD  CONSTRAINT [FK__Instructo__Super__44FF419A] FOREIGN KEY([Supervisor_ID])
REFERENCES [dbo].[Instructor] ([INS_ID])
GO
ALTER TABLE [dbo].[Instructor] CHECK CONSTRAINT [FK__Instructo__Super__44FF419A]
GO
ALTER TABLE [dbo].[Intake]  WITH CHECK ADD  CONSTRAINT [FK__Intake__Branch_I__47DBAE45] FOREIGN KEY([Branch_ID])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
ALTER TABLE [dbo].[Intake] CHECK CONSTRAINT [FK__Intake__Branch_I__47DBAE45]
GO
ALTER TABLE [dbo].[Questions]  WITH CHECK ADD  CONSTRAINT [FK__Questions__CRS_I__5629CD9C] FOREIGN KEY([CRS_ID])
REFERENCES [dbo].[Course] ([CRS_ID])
GO
ALTER TABLE [dbo].[Questions] CHECK CONSTRAINT [FK__Questions__CRS_I__5629CD9C]
GO
ALTER TABLE [dbo].[Stu_CRS]  WITH CHECK ADD  CONSTRAINT [FK__Stu_CRS__CRS_ID__60A75C0F] FOREIGN KEY([CRS_ID])
REFERENCES [dbo].[Course] ([CRS_ID])
GO
ALTER TABLE [dbo].[Stu_CRS] CHECK CONSTRAINT [FK__Stu_CRS__CRS_ID__60A75C0F]
GO
ALTER TABLE [dbo].[Stu_CRS]  WITH CHECK ADD  CONSTRAINT [FK__Stu_CRS__Student__5FB337D6] FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Stu_CRS] CHECK CONSTRAINT [FK__Stu_CRS__Student__5FB337D6]
GO
ALTER TABLE [dbo].[Stu_CRS_Evaluate]  WITH CHECK ADD  CONSTRAINT [FK__Stu_CRS_E__CRS_I__6477ECF3] FOREIGN KEY([CRS_ID])
REFERENCES [dbo].[Course] ([CRS_ID])
GO
ALTER TABLE [dbo].[Stu_CRS_Evaluate] CHECK CONSTRAINT [FK__Stu_CRS_E__CRS_I__6477ECF3]
GO
ALTER TABLE [dbo].[Stu_CRS_Evaluate]  WITH CHECK ADD  CONSTRAINT [FK__Stu_CRS_E__Stude__6383C8BA] FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Stu_CRS_Evaluate] CHECK CONSTRAINT [FK__Stu_CRS_E__Stude__6383C8BA]
GO
ALTER TABLE [dbo].[Stu_EX_Ans]  WITH CHECK ADD  CONSTRAINT [FK__Stu_EX_An__Exam___59FA5E80] FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Stu_EX_Ans] CHECK CONSTRAINT [FK__Stu_EX_An__Exam___59FA5E80]
GO
ALTER TABLE [dbo].[Stu_EX_Ans]  WITH CHECK ADD  CONSTRAINT [FK__Stu_EX_An__Stude__59063A47] FOREIGN KEY([Student_ID])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[Stu_EX_Ans] CHECK CONSTRAINT [FK__Stu_EX_An__Stude__59063A47]
GO
ALTER TABLE [dbo].[Stu_EX_Ans]  WITH CHECK ADD  CONSTRAINT [FK_Stu_EX_Ans_Exam] FOREIGN KEY([exam_id])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[Stu_EX_Ans] CHECK CONSTRAINT [FK_Stu_EX_Ans_Exam]
GO
ALTER TABLE [dbo].[Stu_EX_Ans]  WITH CHECK ADD  CONSTRAINT [FK_Stu_EX_Ans_Questions] FOREIGN KEY([Question_ID])
REFERENCES [dbo].[Questions] ([Question_ID])
GO
ALTER TABLE [dbo].[Stu_EX_Ans] CHECK CONSTRAINT [FK_Stu_EX_Ans_Questions]
GO
ALTER TABLE [dbo].[Student]  WITH CHECK ADD  CONSTRAINT [FK__Student__Track_I__4E88ABD4] FOREIGN KEY([Track_ID])
REFERENCES [dbo].[Track] ([Track_ID])
GO
ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK__Student__Track_I__4E88ABD4]
GO
ALTER TABLE [dbo].[student_results]  WITH CHECK ADD  CONSTRAINT [FK_student_results_Exam] FOREIGN KEY([Exam_ID])
REFERENCES [dbo].[Exam] ([Exam_ID])
GO
ALTER TABLE [dbo].[student_results] CHECK CONSTRAINT [FK_student_results_Exam]
GO
ALTER TABLE [dbo].[student_results]  WITH CHECK ADD  CONSTRAINT [FK_student_results_Student1] FOREIGN KEY([student_id])
REFERENCES [dbo].[Student] ([Student_ID])
GO
ALTER TABLE [dbo].[student_results] CHECK CONSTRAINT [FK_student_results_Student1]
GO
ALTER TABLE [dbo].[Track_branch]  WITH CHECK ADD  CONSTRAINT [FK_Track_branch_Branch] FOREIGN KEY([Branch_id])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
ALTER TABLE [dbo].[Track_branch] CHECK CONSTRAINT [FK_Track_branch_Branch]
GO
ALTER TABLE [dbo].[Track_branch]  WITH CHECK ADD  CONSTRAINT [FK_Track_branch_Track] FOREIGN KEY([Track_id])
REFERENCES [dbo].[Track] ([Track_ID])
GO
ALTER TABLE [dbo].[Track_branch] CHECK CONSTRAINT [FK_Track_branch_Track]
GO
ALTER TABLE [dbo].[training_manager]  WITH CHECK ADD FOREIGN KEY([branch_id])
REFERENCES [dbo].[Branch] ([Branch_ID])
GO
