/// 
Class ABiC.Cube.Attendance Extends %DeepSee.CubeDefinition [ DependsOn = ABiC.Attendance, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ABiCAttendanceCube" displayName="ABiCAttendanceCube" disabled="false" abstract="false" sourceClass="ABiC.Attendance" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="NightShiftFlag" disabled="false" hasAll="false" allCaption="All NightShiftFlag" allDisplayName="NightShiftFlag" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="NightShiftFlag" disabled="false" sourceExpression="$select(%source.NightShiftFlag=1:&quot;Night&quot;,1:&quot;Day&quot;)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="OvertimeHour" disabled="false" hasAll="false" allCaption="All OvertimeHour" allDisplayName="OvertimeHour" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="OvertimeHour" disabled="false" sourceProperty="OvertimeHour" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftName" disabled="false" hasAll="false" allCaption="All ShiftName" allDisplayName="ShiftName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ShiftName" disabled="false" sourceProperty="Shift.ShiftName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All Department" allDisplayName="Department" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Department" disabled="false" sourceProperty="Department.DeptName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateOfEx" disabled="false" hasAll="false" allCaption="All DateOfEx" allDisplayName="DateOfEx" sourceProperty="WorkDate.DateOfEx" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
      <level name="Day" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EmpRole" disabled="false" hasAll="false" allCaption="All EmpRole" allDisplayName="EmpRole" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EmpRole" disabled="false" sourceProperty="EmpID.EmpRole" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
    </hierarchy>
  </dimension>
  <measure name="WorkHourAVG" disabled="false" sourceProperty="WorkHour" aggregate="AVG" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="OvertimeHourMax" disabled="false" sourceProperty="OvertimeHour" aggregate="MAX" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
  <measure name="NightShiftFlag" disabled="false" sourceExpression="$select(%source.NightShiftFlag=1:1,1:0)" aggregate="SUM" type="integer" hidden="false" searchable="false" factNumber="3">
  </measure>
  <measure name="DayShift" disabled="false" sourceExpression="$select(%source.NightShiftFlag=1:0,1:1)" aggregate="COUNT" type="boolean" hidden="false" searchable="false" factNumber="4">
  </measure>
  <listing name="ConsecutiveDays" displayName="連続勤務日数" disabled="false" listingType="table" fieldList="WITH cte AS ( SELECT     ID As AttendanceID,     EmpID,     WorkDate-&gt;DateOfEx,     WorkHour,     OvertimeHour,     Shift-&gt;ShiftName As ShiftName,     ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY WorkDate-&gt;DateOfEx) AS rn FROM $$$SOURCE WHERE $$$RESTRICT ) SELECT AttendanceID, EmpID-&gt;Name, MIN(WorkDate) AS start_date, MAX(WorkDate) AS end_date, WorkHour, OverTimeHour, ShiftName, COUNT(*) AS consecutive_days FROM ( SELECT      AttendanceID,     EmpID,     EmpID-&gt;Name,     WorkDate-&gt;DateOfEx,     WorkHour,     OverTimeHour,     ShiftName,     DATEADD(&apos;dd&apos;, -rn, WorkDate-&gt;DateOfEx) AS grp FROM cte ) AS sub GROUP BY EmpID, grp ORDER BY EmpID, consecutive_days DESC  " sql="WITH cte AS ( SELECT     ID As AttendanceID,     EmpID,     EmpID-&gt;Name As EmpName,     WorkDate-&gt;DateOfEx as workdate,     WorkHour,     OvertimeHour,     Shift-&gt;ShiftName As ShiftName,     ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY WorkDate-&gt;DateOfEx) AS rn FROM $$$SOURCE WHERE $$$RESTRICT ) SELECT AttendanceID, EmpName, COUNT(*) AS consecutive_days,MIN(workdate) AS start_date, MAX(workdate) AS end_date, WorkHour, OverTimeHour, ShiftName FROM ( SELECT      AttendanceID,     EmpID,     EmpName,     workdate,     WorkHour,     OverTimeHour,     ShiftName,     DATEADD(&apos;dd&apos;, -rn, workdate) AS grp FROM cte ) AS sub GROUP BY EmpID, grp ORDER BY consecutive_days DESC " selectMode="2">
  </listing>
</cube>
}

Parameter DOMAIN;

}
