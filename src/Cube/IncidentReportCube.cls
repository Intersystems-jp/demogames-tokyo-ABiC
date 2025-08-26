/// 
Class Cube.IncidentReportCube Extends %DeepSee.CubeDefinition [ DependsOn = Incident.Report, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="IncidentReportCube" displayName="IncidentReportCube" disabled="false" abstract="false" sourceClass="Incident.Report" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="DurationOfHarm" disabled="false" hasAll="false" allCaption="All DurationOfHarm" allDisplayName="DurationOfHarm" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DurationOfHarm" disabled="false" sourceProperty="DurationOfHarm" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateOfOccurence" disabled="false" hasAll="false" allCaption="All DateOfOccurence" allDisplayName="DateOfOccurence" sourceProperty="DateOfOccurence" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DateOfOccurenceYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
      <level name="DateOfOccurenceMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="DateOfOccurenceDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="HarmScore" disabled="false" hasAll="false" allCaption="All HarmScore" allDisplayName="HarmScore" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="HarmScore" disabled="false" sourceProperty="HarmScore" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All Department" allDisplayName="Department" type="data" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Department" disabled="false" sourceProperty="Department" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ReportLevel" disabled="false" hasAll="false" allCaption="All ReportLevel" allDisplayName="ReportLevel" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="ReportLevel" disabled="false" sourceProperty="ReportLevel" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
    </hierarchy>
  </dimension>
  <listing name="ReportDetails" disabled="false" listingType="table" fieldList="DateOfOccurence,Department,Related,Report" sql="select Department,Incident.GetEmployee(Related),DateOfOccurence,Report from $$$SOURCE WHERE $$$RESTRICT" selectMode="2">
  </listing>
</cube>
}

Parameter DOMAIN;

}
