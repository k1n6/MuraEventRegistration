
<cfset useName = "optionGroupCustomValue_#attributes.groupdata.optiongroupid#">

<!---   
	Todo: Set this value to read from the input data struct (attributes.input_struct).
--->
<cfif not structkeyexists(attributes.input_struct, usename & attributes.suffix)>
	<cfset attributes.input_struct[usename & attributes.suffix] = "">
</cfif>
<cfset useValue = "#attributes.input_struct[usename & attributes.suffix]#">
<cfoutput>
	<cfswitch expression="#attributes.groupdata.require_data#">


		<cfcase value="date">
			<input placeholder="Choose a date" class="form-control" type="date-local" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="time">
			<input placeholder="Choose a time" class="form-control" type="time-local" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="datetime">
			<input placeholder="Choose a date and time"  class="form-control" type="datetime-local" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="number">
			<input placeholder="Enter a number"  class="form-control" type="number" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="string">
			<input placeholder="Enter a value"  class="form-control" type="text" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>

	</cfswitch>
</cfoutput>