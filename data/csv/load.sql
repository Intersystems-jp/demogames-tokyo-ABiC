LOAD DATA FROM FILE '/data/csv/departments.csv'
 INTO Hospital.Department
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/employees.csv'
 INTO Hospital.Employee
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/shifts.csv'
 INTO Hospital.Shift
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/attendance.csv'
 INTO Hospital.Attendance
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/leave_requests.csv'
 INTO Hospital.LeaveRequest
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/overtime_requests.csv'
 INTO Hospital.OvertimeRequest
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/work_history.csv'
 INTO Hospital.WorkHistory
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/ehr/patients.csv'
 INTO EHR.PatientInfo
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/ehr/patient_tests.csv'
 INTO EHR.Test
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/reports.csv'
 INTO Incident.Report (ReportID,Department,Related,DateOfOccurence,ReportLevel,LevelOfDisability,ContinuityOfDisability,Report)
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}

LOAD DATA FROM FILE '/data/csv/trans.csv'
 INTO Inventory.MaterialTransaction
 USING {"from":{"file":{"charset":"UTF-8","header":true}}}