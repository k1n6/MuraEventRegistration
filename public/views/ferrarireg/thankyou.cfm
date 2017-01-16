
<cfif isdefined("session.summary_data")>
	<h1>Your Registration Has Been Received!</h1>
	<button onclick="window.print(); return false;" class="btn btn-primary"><i class="icon-printer icon-white"></i> Print This Page For Your Records</button>
	<cfoutput>#session.summary_data#</cfoutput>
<cfelse>
	No Session Data Available.<br>
	You completed checkout too long ago to display your receipt.
</cfif>