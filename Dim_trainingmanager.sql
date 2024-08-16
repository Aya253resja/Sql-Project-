-- View for DimTrainingManager with Join
CREATE VIEW DimTrainingManager 
AS
SELECT tm.mgr_id, tm.mgr_name, tm.branch_id, b.Branch_Name
FROM training_manager tm
JOIN Branch b ON tm.branch_id = b.Branch_ID;