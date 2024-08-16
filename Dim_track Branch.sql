-- View for DimTrackBranch with Join
CREATE VIEW DimTrackBranch AS
SELECT tb.Track_id, tb.Branch_id, tb.branch_name, tb.Track_name
FROM Track_branch tb
JOIN Track t ON tb.Track_id = t.Track_ID;