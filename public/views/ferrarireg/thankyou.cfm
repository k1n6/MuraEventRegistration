<cfsavecontent variable="session.lastRegistration">
	<cfif isdefined("session.summary_data")>

		<cfset reg_results = rc.FERRARI_REG.saveRegistration(session.reg_options, session.summary_data, session.runningTotal, session.total_items,session.reg_options[2].eventid, session.useTax)>

		<cfset bcc_list = rc.FERRARI_REG.getBCCList(session.reg_options[2].eventid)>

		<cfif not reg_results.success>
			An Error Occurred Creating your registration.
			<cfset throw_object = {results = reg_results, options = session.reg_options}>
			<cfsavecontent variable="t">

				<cfoutput>#reg_results.message#</cfoutput>
				<cfdump var="#session.reg_options#" label="session.reg_options">
				<cfdump var="#cgi#" label="cgi">
				<cfset data = GetHttpRequestData()>
				<cfdump var="#data#" label="HTTP Request Data">

			</cfsavecontent>

			<cffile action="write" output="#t#" file="#expandpath('/logs/RegistrationSerializationError-#dateformat(now(), 'mm_dd_yyyy')# #getTickCount()#.html')#">
			<cfthrow 
				type="user"
				message="An Error Occurred Creating your registration."
				>
		<cfelse>

		</cfif>
		<cfoutput>
			<span style="display: none;" id="registrationid">#reg_results.message#</span>
			<h1>Your Registration Has Been Received!</h1>
			<h2>Registration ID #reg_results.message#</h2>
		</cfoutput>
		<button onclick="window.print(); return false;" class="btn btn-primary"><i class="icon-printer icon-white"></i> Print This Page For Your Records</button>
		<cfsavecontent variable="confirmation">
			<cfif isdefined('url.payviaCheck') and url.payviaCheck eq 'true'>
				<br clear=all />
				<br clear=all />
				<div class="row">
					<div class="col-md-12">
						<div class="panel-group panel-warning">
						  <div class="panel panel-default">
							  <div class="panel-body">
								  <cfoutput>
									<h4>Pay Via Check</h4>
									<p>You have selected to pay via check.  Please send your check to:<br>
										#session.event_config.payment_address#
									<br>
										<cfparam default="" name="session.event_config.payable_to">
											Make checks payable to <em><strong>#session.event_config.payable_to#</strong></em></p>
								  </cfoutput>
							  </div>
							</div>
						</div>
					</div>
				</div>
			</cfif>

			<cfoutput>#session.summary_data#</cfoutput>
		</cfsavecontent>
		<cfset send_results = rc.ferrari_reg.sendConfirmationEmails(confirmation, bcc_list, reg_results.message, session.reg_options)>
		<cfif not send_results>
			<br clear=all />
				<br clear=all />
				<div class="row">
					<div class="col-md-12">
						<div class="panel-group panel-warning">
						  <div class="panel panel-default">
							  <div class="panel-body">
							  	<cfif $.siteConfig('disableregistrationemails') eq "true">
									<strong>Email Confirmations not sent becuase that is turned off in the configuration.</strong>
								<cfelse>
									<strong>Unable to send email confirmations - Either the email address you entered is invalid or the site is not configured to send emails from a valid address.</strong>
								</cfif>
							  </div>
						  </div>
						</div>
					</div>
				</div>							  
		</cfif>
		<cfoutput>#confirmation#</cfoutput>

		<cfif reg_results.success>
			<cfset session.summary_data= "">
			<cfset session.reg_options = arraynew(1)>
			<cfset session.runningTotal = 0>
			<cfset session.total_items = {}>
			<cfset session.reg_completed = true>
		</cfif>
	<cfelse>
		No Session Data Available.<br>
		You completed checkout too long ago to display your receipt.
	</cfif>
</cfsavecontent>
<cfoutput>#session.lastRegistration#</cfoutput>