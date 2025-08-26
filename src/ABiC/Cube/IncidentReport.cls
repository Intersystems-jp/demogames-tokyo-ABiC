/// 
Class ABiC.Cube.IncidentReport Extends %DeepSee.CubeDefinition [ DependsOn = ABiC.IncidentReport, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ABiCIncidentReportCube" displayName="ABiCIncidentReportCube" disabled="false" abstract="false" sourceClass="ABiC.IncidentReport" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="HarmScore" disabled="false" hasAll="false" allCaption="All HarmScore" allDisplayName="HarmScore" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="HarmScore" disabled="false" sourceProperty="HarmScore" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DurationOfHarm" disabled="false" hasAll="false" allCaption="All DurationOfHarm" allDisplayName="DurationOfHarm" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DurationOfHarm" disabled="false" sourceProperty="DurationOfHarm" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ReportLevel" disabled="false" hasAll="false" allCaption="All ReportLevel" allDisplayName="ReportLevel" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ReportLevel" disabled="false" sourceProperty="ReportLevel" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateOfEx" disabled="false" hasAll="false" allCaption="All DateOfEx" allDisplayName="DateOfEx" sourceProperty="WorkDate.DateOfEx" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="10">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All Department" allDisplayName="Department" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Department" disabled="false" sourceProperty="Department.DeptName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <listing name="GetDetailInfo" disabled="false" listingType="table" fieldList="Department-&gt;DeptName,Related,DateOfOccurence-&gt;DateOfEx,DurationOfHarm,HarmScore,Report" sql="SELECT Department-&gt;DeptName,ABiC.GetEmpInfo(Related) As EmpName,ABiC.GetEmpRoleInfo(Related) As EmpRole ,WorkDate-&gt;DateOfEx,DurationOfHarm,HarmScore,Report from $$$SOURCE WHERE $$$RESTRICT" selectMode="2">
  </listing>
</cube>
}

Parameter DOMAIN;

}
