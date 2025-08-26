/// 
Class ABiC.Cube.ConsecutiveAttendance Extends %DeepSee.CubeDefinition [ DependsOn = ABiC.ConsecutiveAttendance, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ABiCConsecutiveDayCube" disabled="false" abstract="false" sourceClass="ABiC.ConsecutiveAttendance" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="NightShiftFlag" disabled="false" hasAll="false" allCaption="All NightShiftFlag" allDisplayName="NightShiftFlag" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="NightShiftFlag" disabled="false" sourceExpression="$select(%source.Attendance.NightShiftFlag=1:&quot;Night&quot;,1:&quot;Day&quot;)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ShiftName" disabled="false" hasAll="false" allCaption="All ShiftName" allDisplayName="ShiftName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ShiftName" disabled="false" sourceProperty="Attendance.Shift.ShiftName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Status" disabled="false" hasAll="false" allCaption="All Status" allDisplayName="Status" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Status" disabled="false" sourceProperty="Attendance.EmpID.Status" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EmpType" disabled="false" hasAll="false" allCaption="All EmpType" allDisplayName="EmpType" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EmpType" disabled="false" sourceProperty="Attendance.EmpID.EmpType" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EmpRole" disabled="false" hasAll="false" allCaption="All EmpRole" allDisplayName="EmpRole" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EmpRole" disabled="false" sourceProperty="Attendance.EmpID.EmpRole" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="EndDate" disabled="false" hasAll="false" allCaption="All EndDate" allDisplayName="EndDate" sourceProperty="EndDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="EndDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
      <level name="EndDateMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
      <level name="EndDateDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="10">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateOfEx" disabled="false" hasAll="false" allCaption="All StartDate" allDisplayName="WorkDate" sourceProperty="WorkDate.DateOfEx" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="11">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="12">
      </level>
      <level name="Day" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="13">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All DeptName" allDisplayName="DeptName" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Department" disabled="false" sourceProperty="Department.DeptName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ConsecutiveDay" disabled="false" hasAll="false" allCaption="All ConsecutiveDay" allDisplayName="ConsecutiveDay" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ConsecutiveDay" disabled="false" sourceProperty="ConsecutiveDay" list="false" useDisplayValue="true" sort="desc numeric" useAsFilter="true" hidden="false" factNumber="14">
      </level>
    </hierarchy>
  </dimension>
  <measure name="ConsecutiveDayAVG" disabled="false" sourceProperty="ConsecutiveDay" aggregate="AVG" type="integer" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="OvertimeHour" disabled="false" sourceProperty="OvertimeHour" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
  <measure name="WorkHour" disabled="false" sourceProperty="WorkHour" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="3">
  </measure>
  <measure name="ConsecutiveDaysMax" disabled="false" sourceProperty="ConsecutiveDay" aggregate="MAX" type="integer" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="NightShiftFlag" disabled="false" sourceProperty="Attendance.NightShiftFlag" aggregate="COUNT" type="boolean" hidden="false" searchable="false" factNumber="4">
  </measure>
  <measure name="DayShift" disabled="false" sourceExpression="$select(%source.Attendance.NightShiftFlag=1:0,1:1)" aggregate="COUNT" type="boolean" hidden="false" searchable="false" factNumber="5">
  </measure>
  <listing name="GetEmpInfo" disabled="false" listingType="table" fieldList="Attendance-&gt;EmpID-&gt;%ID,Attendance-&gt;EmpID-&gt;DeptID-&gt;DeptName,Attendance-&gt;EmpID-&gt;EmpRole,Attendance-&gt;EmpID-&gt;Name,Attendance-&gt;EmpID-&gt;Status,Attendance-&gt;EmpID-&gt;EmpType,WorkDate-&gt;DateOfEx,EndDate,Attendance-&gt;Shift-&gt;ShiftName,WorkHour,ConsecutiveDay" orderBy="ConsecutiveDay Desc" selectMode="2">
  </listing>
  <listing name="GetTopConsecutiveEmployee" disabled="false" listingType="table" fieldList="Attendance-&gt;EmpID-&gt;EmpID,Attendance-&gt;EmpID-&gt;Name,Attendance-&gt;EmpID-&gt;DeptID-&gt;DeptName,Attendance-&gt;EmpID-&gt;EmpRole,Attendance-&gt;EmpID-&gt;EmpType" sql="select top 1 Attendance-&gt;EmpID-&gt;EmpID,Attendance-&gt;EmpID-&gt;Name,Attendance-&gt;EmpID-&gt;DeptID-&gt;DeptName,Attendance-&gt;EmpID-&gt;EmpRole,Attendance-&gt;EmpID-&gt;EmpType,ConsecutiveDay from $$$SOURCE WHERE $$$RESTRICT order by ConsecutiveDay desc" selectMode="2">
    <additionalDescription>top 1</additionalDescription>
  </listing>
</cube>
}

Parameter DOMAIN;

}
