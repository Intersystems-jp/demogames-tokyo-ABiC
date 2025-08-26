Class ABiC.Utils
{

ClassMethod GetWeatherInfo(in)
{
}

ClassMethod SetSQLGWJDBC() As %Status
{
    set gc = ##class(%SQLConnection).%New()
    set gc.isJDBC = 1
    set gc.Name = "incidentreport"
    set gc.Usr = "SuperUser"
    set gc.pwd = "SYS"
    set gc.driver = "com.intersystems.jdbc.IRISDriver"
    set gc.URL = "jdbc:IRIS://127.0.0.1:1972/User"
    set gc.classpath = "/usr/irissys/dev/java/lib/1.8/intersystems-jdbc-3.10.3.jar"
    set gc.useCOALESCE = 1
    set status=gc.%Save()
    return status
}

ClassMethod createForeignTable()
{
    &SQL(CREATE FOREIGN SERVER ABiC.ForeignServer FOREIGN DATA WRAPPER JDBC CONNECTION 'incidentreport')
    &SQL(CREATE FOREIGN TABLE ABiC.FTIncidentReport (
        ReportID INTEGER,
        Related VARCHAR(50),
        DateOfOccurence DATE,
        ReportLevel VARCHAR(50),
        HarmScore VARCHAR(50),
        DurationOfHarm VARCHAR(50),
        Department VARCHAR(50),
        Report VARCHAR(1000)
        ) Server ABiC.ForeignServer Table 'Incident.Report')
    if SQLCODE<0 {
        write %msg,!
    }
}

/// 接続確認でテストしたほうがよさそう
ClassMethod test()
{
    &sql(select report into :repo from ABiC.FTIncidentReport where ReportID=1)
    write repo,!
}

ClassMethod dropFTable()
{
    &sql(drop foreign server ABiC.ForeignServer CASCADE)
}

ClassMethod DeleteFact(cubename As %String) As %Status
{
    return ##class(%DeepSee.Utils).%DeleteFact(cubename)
}

ClassMethod GetDateID(date As %Date) As %Integer
{
    set date=$ZDATEH(date,3)
    &sql(select ID into :id from ABiC.DateDimention where DateOfEx = :date)
    return id
}

ClassMethod GetDeptID(name As %String) As %Integer [ SqlProc ]
{
    &sql(select ID into :id from Hospital.Department where DeptName = :name)
    return $get(id)
}

ClassMethod GetDeptFromEmpID(empid As %Integer) As %Integer [ SqlName = GetDeptFromEmpID, SqlProc ]
{
    return ##class(Hospital.Employee).EmpIDIdxOpen(empid).DeptID.%Id()
}

}
