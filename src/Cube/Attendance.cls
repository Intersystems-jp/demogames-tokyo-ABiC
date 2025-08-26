/// 
Class Cube.Attendance Extends %DeepSee.CubeDefinition [ DependsOn = BI.Attendance, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ConsecutiveDayCube" disabled="false" abstract="false" sourceClass="BI.Attendance" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All DeptName" allDisplayName="DeptName" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DeptName" disabled="false" sourceProperty="Attendance.EmpID.DeptID.DeptName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="NightShiftFlag" disabled="false" hasAll="false" allCaption="All NightShiftFlag" allDisplayName="NightShiftFlag" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="NightShiftFlag" disabled="false" sourceExpression="$select(%source.Attendance.NightShiftFlag=1:&quot;夜勤&quot;,1:&quot;日勤&quot;)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
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
  <dimension name="StartDate" disabled="false" hasAll="false" allCaption="All StartDate" allDisplayName="StartDate" sourceProperty="StartDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="StartDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="11">
      </level>
      <level name="StartDateMonth" disabled="false" timeFunction="MonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="12">
      </level>
      <level name="StartDateDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="13">
      </level>
    </hierarchy>
  </dimension>
  <measure name="ConsecutiveDay" disabled="false" sourceProperty="ConsecutiveDay" aggregate="SUM" type="integer" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="OvertimeHour" disabled="false" sourceProperty="OvertimeHour" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
  <measure name="WorkHour" disabled="false" sourceProperty="WorkHour" aggregate="SUM" type="number" hidden="false" searchable="false" factNumber="3">
  </measure>
  <measure name="ConsecutiveDaysMax" disabled="false" sourceProperty="ConsecutiveDay" aggregate="MAX" type="integer" hidden="false" searchable="false" factNumber="1">
  </measure>
  <listing name="GetEmpInfo" disabled="false" listingType="table" fieldList="Attendance-&gt;EmpID-&gt;%ID,Attendance-&gt;EmpID-&gt;DeptID-&gt;DeptName,Attendance-&gt;EmpID-&gt;EmpRole,Attendance-&gt;EmpID-&gt;Name,Attendance-&gt;EmpID-&gt;Status,Attendance-&gt;EmpID-&gt;EmpType,StartDate,WorkHour,ConsecutiveDay" orderBy="ConsecutiveDay Desc" selectMode="2">
  </listing>
  <listing name="GetTopConsecutiveEmployee" disabled="false" listingType="table" fieldList="Attendance-&gt;EmpID-&gt;EmpID,Attendance-&gt;EmpID-&gt;Name,Attendance-&gt;EmpID-&gt;DeptID-&gt;DeptName,Attendance-&gt;EmpID-&gt;EmpRole,Attendance-&gt;EmpID-&gt;EmpType" sql="select top 1 Attendance-&gt;EmpID-&gt;EmpID,Attendance-&gt;EmpID-&gt;Name,Attendance-&gt;EmpID-&gt;DeptID-&gt;DeptName,Attendance-&gt;EmpID-&gt;EmpRole,Attendance-&gt;EmpID-&gt;EmpType,ConsecutiveDay from BI.Attendance order by ConsecutiveDay desc" selectMode="2">
    <additionalDescription>top 1</additionalDescription>
  </listing>
</cube>
}

Parameter DOMAIN;

}
