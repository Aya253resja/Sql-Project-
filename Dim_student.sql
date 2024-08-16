-- View for DimStudent with Join
CREATE VIEW DimStudent AS
SELECT s.Student_ID, s.Fname, s.Lname, s.Phone, s.Address, s.Position,s.Link, s.Freelance_status, s.Company_Name, s.Gender, 
s.Graduation_Year, s.Birth_Date, s.Track_ID, s.Hiring_Status, s.certificate_status, s.Certificate_name, t.Track_Name
FROM Student s
left JOIN Track t ON s.Track_ID = t.Track_ID;