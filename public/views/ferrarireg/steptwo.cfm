
<!---   

This pulls in args
--->



<cfparam default="2" name="curstep">
<cfinclude template="stepSaver.cfm">
<cfparam name="input_struct.option" default="" >
<cfparam name="input_struct.optiongroup" default="" >
<cfparam name="input_Struct.main_eventprice" default="">
<cfloop from='0' to ='10' index='i'>
	<cfparam name="input_struct.option_#i#" default="" >
	<cfparam name="input_struct.optiongroup_#i#" default="" >
	<cfparam name="input_Struct.main_eventprice_#i#" default="">
</cfloop>
<cfparam name="session.reg_options[2].nonMemberGuests" default="0">
<cfset numberGuests = session.reg_options[2].nonMemberGuests>
<cfparam name="request.runningTotal" default="0">
<cfparam default="false" name="reviewmode">
<!---   
	This prevents the back button / reload page confirmation prompt to users.
--->
<cfset req = getHTTPRequestData()>
<cfif req.method eq "POST" and reviewmode neq "true">
	<script>
		window.location.href = window.location.href;
	</script>
</cfif>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<h2>Registration Options - Main Event</h2>		
		</div>
	</div>
		<div class="panel panel-default">
			<form method="post" action="?EventRegistrationaction=public:ferrarireg.stepthree&EventID=<cfoutput>#rc.eventid#</cfoutput>">
				<div class="panel-body">
				<cfset guest ="">
				<cfset guestName = session.reg_options[2].full_name>	
				<div class="panel panel-default">			
					<cfinclude template="stepTwoOptions.cfm">
				</div>
				<cfloop from='0' to ="#session.reg_options[2].nonMemberGuests - 1#" index='i'>
					<cfset guest = i>
					<cfset guestLabel = i + 1>
					<cfset guestName = session.reg_options[2]['guest#i#first'] & " " & session.reg_options[2]['guest#i#last']>
					<div class="panel panel-default">			
						<cfinclude template="stepTwoOptions.cfm">
					</div>
				</cfloop>
				<cfif reviewmode neq 'true'>
					<fieldset>
						<div class="form-group row">
							<div class="col-sm-3 pull-left">
								<button class="btn btn-primary" onclick="window.location.href = '?EventRegistrationaction=public:ferrarireg.default&EventID=<cfoutput>#rc.eventid#</cfoutput>&goingback=true'; return false;">&lt;- Return to Previous Step</button>
							</div>
							<div class="col-sm-3 pull-right text-align-right">
								<button class="btn btn-primary" type="submit">Proceed To Next Step -></button>
							</div>

						</div>
					</fieldset>
				</cfif>
				</div>
			</form>
		</div>
					
</div>

<script>
	
	function updateCheckbox(ele, optiongroupid){
		if($(ele).val() != '')
				$('#optiongroup' + optiongroupid).prop('checked', true);
		else
				$('#optiongroup' + optiongroupid).prop('checked', false);
	}
</script>
	
	
	
		



