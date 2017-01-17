
<cfif isdefined("session.summary_data")>
	<h1>Your Registration Has Been Received!</h1>
	<button onclick="window.print(); return false;" class="btn btn-primary"><i class="icon-printer icon-white"></i> Print This Page For Your Records</button>
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
<cfelse>
	No Session Data Available.<br>
	You completed checkout too long ago to display your receipt.
</cfif>