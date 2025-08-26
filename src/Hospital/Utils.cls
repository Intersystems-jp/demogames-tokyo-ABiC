Class Hospital.Utils
{

ClassMethod DeleteFact(cubename As %String) As %Status
{
    return ##class(%DeepSee.Utils).%DeleteFact(cubename)
}

/// 単一分析用の BI.Attendanceを作成する。
ClassMethod ETLAttendance()
{
    /*
WITH cte AS (
SELECT
    ID As AttendanceID,
    EmpID,
    WorkDate,
    WorkHour,
    OvertimeHour,
    Shift->ShiftName As ShiftName,
    ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY WorkDate) AS rn
FROM Hospital.Attendance
)
SELECT
AttendanceID,
MIN(WorkDate) AS start_date,
MAX(WorkDate) AS end_date,
WorkHour,
OverTimeHour,
ShiftName,
COUNT(*) AS consecutive_days
FROM (
SELECT 
    AttendanceID,
    EmpID,
    WorkDate,
    WorkHour,
    OverTimeHour,
    ShiftName,
    DATEADD('dd', -rn, WorkDate) AS grp
FROM cte
) AS sub
GROUP BY EmpID, grp
ORDER BY EmpID, consecutive_days DESC

    */
    set sql="WITH cte AS ("
    _"SELECT"
    _" ID As AttendanceID,EmpID,WorkDate,WorkHour,OvertimeHour,Shift->ShiftName As ShiftName,"
    _"ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY WorkDate) AS rn"
    _" FROM Hospital.Attendance"
    _")"
    _"SELECT" 
    _" AttendanceID,MIN(WorkDate) AS start_date,MAX(WorkDate) AS end_date,WorkHour,OverTimeHour,ShiftName,COUNT(*) AS consecutive_days"
    _" FROM ("
    _"SELECT" 
    _" AttendanceID,EmpID,WorkDate,WorkHour,OverTimeHour,ShiftName,DATEADD('dd', -rn, WorkDate) AS grp"
    _" FROM cte"
    _") AS sub"
    _" GROUP BY EmpID, grp"
    _" ORDER BY EmpID, consecutive_days DESC"
    set stmt=##class(%SQL.Statement).%New()
    set st=stmt.%Prepare(sql)
    set rset=stmt.%Execute()

    set sql2="insert into BI.Attendance (Attendance,WorkHour,OvertimeHour,StartDate,EndDate,ConsecutiveDay) VALUES(?,?,?,?,?,?)"
    set stmt2=##class(%SQL.Statement).%New()
    set st=stmt2.%Prepare(sql2)

    while rset.%Next() {
        set st=stmt2.%Execute(
            rset.AttendanceID,
            rset.WorkHour,
            rset.OvertimeHour,
            rset."start_date",
            rset."end_date",
            rset."consecutive_days"
        )
    }
}

/// 勤怠情報からWorkDateとDepartmentを共有ディメンジョンとできるようにしたABiC.ConsecutiveAttendanceを作る
/// WorkDate作成に ABiC.IncidentReport.GetDateID()使用
ClassMethod ETLABiCAttendance()
{
    /*
WITH cte AS (
SELECT
    ID As AttendanceID,
    EmpID,
    WorkDate,
    WorkHour,
    OvertimeHour,
    Shift->ShiftName As ShiftName,
    ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY WorkDate) AS rn
FROM Hospital.Attendance
)
SELECT
AttendanceID,
MIN(WorkDate) AS start_date,
MAX(WorkDate) AS end_date,
WorkHour,
OverTimeHour,
ShiftName,
COUNT(*) AS consecutive_days
FROM (
SELECT 
    AttendanceID,
    EmpID,
    WorkDate,
    WorkHour,
    OverTimeHour,
    ShiftName,
    DATEADD('dd', -rn, WorkDate) AS grp
FROM cte
) AS sub
GROUP BY EmpID, grp
ORDER BY EmpID, consecutive_days DESC

    */
    set sql="WITH cte AS ("
    _"SELECT"
    _" ID As AttendanceID,EmpID,WorkDate,WorkHour,OvertimeHour,Shift->ShiftName As ShiftName,"
    _"ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY WorkDate) AS rn"
    _" FROM Hospital.Attendance"
    _")"
    _"SELECT" 
    _" AttendanceID,MIN(WorkDate) AS start_date,MAX(WorkDate) AS end_date,WorkHour,OverTimeHour,ShiftName,COUNT(*) AS consecutive_days"
    _" FROM ("
    _"SELECT" 
    _" AttendanceID,EmpID,WorkDate,WorkHour,OverTimeHour,ShiftName,DATEADD('dd', -rn, WorkDate) AS grp"
    _" FROM cte"
    _") AS sub"
    _" GROUP BY EmpID, grp"
    _" ORDER BY EmpID, consecutive_days DESC"
    set stmt=##class(%SQL.Statement).%New()
    set st=stmt.%Prepare(sql)
    set rset=stmt.%Execute()

    set sql2="insert into ABiC.ConsecutiveAttendance (Attendance,Department,WorkHour,OvertimeHour,WorkDate,EndDate,ConsecutiveDay) VALUES(?,?,?,?,?,?,?)"
    set stmt2=##class(%SQL.Statement).%New()
    set st=stmt2.%Prepare(sql2)

    while rset.%Next() {
            set st=stmt2.%Execute(
            rset.AttendanceID,
            ..GetDeptInfoFromAttendance(rset.AttendanceID),
            rset.WorkHour,
            rset.OvertimeHour,
            ##class(ABiC.Utils).GetDateID($ZDATE(rset."start_date",3)),
            rset."end_date",
            rset."consecutive_days"
        )
    }
}

ClassMethod GetDeptInfoFromAttendance(attendance As %Integer) As %Integer [ SqlName = GetDeptInfoFromAttendance, SqlProc ]
{
    set empid=##class(Hospital.Attendance).%OpenId(attendance).EmpID.%Id()
    return ##class(Hospital.Employee).EmpIDIdxOpen(empid).DeptID.%Id()
}

ClassMethod LoadAll()
{
    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/departments.csv'
    INTO Hospital.Department
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/employees.csv'
    INTO Hospital.Employee
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/shifts.csv'
    INTO Hospital.Shift
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/attendance.csv'
    INTO Hospital.Attendance
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/leave_requests.csv'
    INTO Hospital.LeaveRequest
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/overtime_requests.csv'
    INTO Hospital.OvertimeRequest
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/work_history.csv'
    INTO Hospital.WorkHistory
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/ehr/patients.csv'
    INTO EHR.PatientInfo
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/ehr/patient_tests.csv'
    INTO EHR.Test
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )
    
    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/reports.csv'
    INTO Incident.Report (ReportID,Department,Related,DateOfOccurence,ReportLevel,HarmScore,DurationOfHarm,Report)
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )

    &sql(
    LOAD DATA FROM FILE '/opt/src/data/csv/trans.csv'
    INTO Inventory.MaterialTransaction
    USING {"from":{"file":{"charset":"UTF-8","header":true}}}
    )
}

}
