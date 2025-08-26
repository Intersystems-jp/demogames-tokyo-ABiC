/// 
Class Cube.ClinicData Extends %DeepSee.CubeDefinition [ DependsOn = EHR.Test, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ClinicData" displayName="ClinicData" disabled="false" abstract="false" sourceClass="EHR.Test" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Dept" disabled="false" hasAll="false" allCaption="All Dept" allDisplayName="Dept" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Dept" disabled="false" sourceProperty="PID.Dept" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AdmissionDate" disabled="false" hasAll="false" allCaption="All AdmissionDate" allDisplayName="AdmissionDate" sourceProperty="PID.AdmissionDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AdmissionDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
      <level name="AdmissionDateMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="AdmissionDateDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DischargeDate" disabled="false" hasAll="false" allCaption="All DischargeDate" allDisplayName="DischargeDate" sourceProperty="PID.DischargeDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="DischargeDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
      <level name="DischargeDateMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
      <level name="DischargeDateDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Gender" disabled="false" hasAll="false" allCaption="All Gender" allDisplayName="Gender" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Gender" disabled="false" sourceProperty="PID.Gender" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Diagnosis" disabled="false" hasAll="false" allCaption="All Diagnosis" allDisplayName="Diagnosis" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Diagnosis" disabled="false" sourceProperty="PID.Diagnosis" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="10">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TestDate" disabled="false" hasAll="false" allCaption="All TestDate" allDisplayName="TestDate" sourceProperty="TestDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TestDateYear" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="11">
      </level>
      <level name="TestDateMonth" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="12">
      </level>
      <level name="TestDateDay" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="13">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TestName" disabled="false" hasAll="false" allCaption="All TestName" allDisplayName="TestName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TestName" disabled="false" sourceProperty="TestName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="14">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TestResult" disabled="false" hasAll="false" allCaption="All TestResult" allDisplayName="TestResult" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TestResult" disabled="false" sourceProperty="TestResult" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="15">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="HospitalStay" disabled="false" hasAll="false" allCaption="All HospitalStay" allDisplayName="HospitalStay" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="HospitalStay" disabled="false" sourceExpression="$select(%source.PID.DischargeDate&apos;=&quot;&quot;: (%source.PID.DischargeDate-%source.PID.AdmissionDate),1:&quot;外来&quot;)" list="false" useDisplayValue="true" sort="desc numeric" useAsFilter="true" hidden="false" factNumber="16">
      </level>
    </hierarchy>
  </dimension>
</cube>
}

Parameter DOMAIN;

}
