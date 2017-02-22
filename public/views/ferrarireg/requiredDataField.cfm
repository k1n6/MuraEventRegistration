<cfparam default="0" name="attributes.required">

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
			<input
				<cfif attributes.required eq '1'> required='true' </cfif>
				data-optiongroupid = "#attributes.groupdata.optiongroupid##attributes.suffix#"
		placeholder="Choose a date" class=" <cfif attributes.required neq '1'>not_required</cfif> form-control required_data_field" type="date-local" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="time">
			<input 
			<cfif attributes.required eq '1'> required='true' </cfif>
			data-optiongroupid = "#attributes.groupdata.optiongroupid##attributes.suffix#"
			placeholder="Choose a time" class="<cfif attributes.required neq '1'>not_required</cfif> form-control required_data_field" type="time-local" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="datetime">
			<input
			<cfif attributes.required eq '1'> required='true' </cfif>
			data-optiongroupid = "#attributes.groupdata.optiongroupid##attributes.suffix#"
			 placeholder="Choose a date and time"  class=" <cfif attributes.required neq '1'>not_required</cfif> form-control required_data_field" type="datetime-local" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="number">
			<input 
			<cfif attributes.required eq '1'> required='true' </cfif>
			data-optiongroupid = "#attributes.groupdata.optiongroupid##attributes.suffix#"
			placeholder="Enter a number"  class="<cfif attributes.required neq '1'>not_required</cfif> form-control required_data_field" type="number" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>
		<cfcase value="string">
			<input 
			<cfif attributes.required eq '1'> required='true' </cfif>
			data-optiongroupid = "#attributes.groupdata.optiongroupid##attributes.suffix#"
			placeholder="Enter a value"  class=" <cfif attributes.required neq '1'>not_required</cfif> form-control required_data_field" type="text" value="#useValue#" id="#useName#" name="#useName##attributes.suffix#">
		</cfcase>

	</cfswitch>
</cfoutput>