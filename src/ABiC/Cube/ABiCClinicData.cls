/// 
Class ABiC.Cube.ABiCClinicData Extends %DeepSee.CubeDefinition [ DependsOn = ABiC.EHRTest, ProcedureBlock ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="ABiCClinicDataCube" displayName="ABiCClinicDataCube" disabled="false" abstract="false" sourceClass="ABiC.EHRTest" namedFactNums="true" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="Department" disabled="false" hasAll="false" allCaption="All Department" allDisplayName="Department" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Department" disabled="false" sourceProperty="PID.Department.DeptName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="2">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="TestName" disabled="false" hasAll="false" allCaption="All TestName" allDisplayName="TestName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TestName" disabled="false" sourceProperty="TestName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="6">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AdmissionDate" disabled="false" hasAll="false" allCaption="All AdmissionDate" allDisplayName="AdmissionDate" sourceProperty="PID.AdmissionDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="7">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="8">
      </level>
      <level name="Day" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="9">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DischargeDate" disabled="false" hasAll="false" allCaption="All DischargeDate" allDisplayName="DischargeDate" sourceProperty="PID.DischargeDate" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="10">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="11">
      </level>
      <level name="Day" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="12">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Gender" disabled="false" hasAll="false" allCaption="All Gender" allDisplayName="Gender" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Gender" disabled="false" sourceExpression="$SELECT(%source.PID.Gender=&quot;F&quot;:&quot;Female&quot;,1:&quot;Male&quot;)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="13">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="AdmissionFlg" disabled="false" hasAll="false" allCaption="All AdmissionFlg" allDisplayName="AdmissionFlg" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="AdmissionFlg" disabled="false" sourceExpression="$select(%source.PID.AdmissionFlg=1:&quot;Admission&quot;,1:&quot;Visit&quot;)" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="14">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Diagnosis" disabled="false" hasAll="false" allCaption="All Diagnosis" allDisplayName="Diagnosis" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Diagnosis" disabled="false" sourceProperty="PID.Diagnosis" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="15">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="LengthOfStay" disabled="false" hasAll="false" allCaption="All LengthOfStay" allDisplayName="LengthOfStay" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="LengthOfStay" disabled="false" sourceExpression="%source.PID.DischargeDate-%source.PID.AdmissionDate" list="false" useDisplayValue="true" sort="desc numeric" useAsFilter="true" hidden="false" factNumber="16">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="DateOfEx" disabled="false" hasAll="false" allCaption="All DateOfEx" allDisplayName="DateOfEx" sourceProperty="WorkDate.DateOfEx" type="time" calendar="gregorian" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Year" disabled="false" timeFunction="Year" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="3">
      </level>
      <level name="Month" disabled="false" timeFunction="MonthNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="4">
      </level>
      <level name="Day" disabled="false" timeFunction="DayNumber" list="false" useDisplayValue="true" useAsFilter="true" hidden="false" factNumber="5">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="HospitalStay" disabled="false" hasAll="false" allCaption="All HospitalStay" allDisplayName="HospitalStay" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="HospitalStay" disabled="false" sourceExpression="$select((%source.PID.DischargeDate-%source.PID.AdmissionDate)&gt;0:(%source.PID.DischargeDate-%source.PID.AdmissionDate),1:&quot;Visit&quot;)" list="false" useDisplayValue="true" sort="desc numeric" useAsFilter="true" hidden="false" factNumber="17">
      </level>
    </hierarchy>
  </dimension>
  <measure name="AgeAVG" disabled="false" sourceProperty="PID.Age" aggregate="AVG" type="number" hidden="false" searchable="false" factNumber="1">
  </measure>
  <measure name="LenghtOfStayAVG" disabled="false" sourceExpression="%source.PID.DischargeDate-%source.PID.AdmissionDate" aggregate="AVG" type="number" hidden="false" searchable="false" factNumber="2">
  </measure>
</cube>
}

Parameter DOMAIN;

}
