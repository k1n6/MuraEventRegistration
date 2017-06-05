<div class="panel panel-default">
		<div class="panel-body">
<h3>Total price of all acivities and options selected: <cfoutput><span class="dollar_container">#dollarformat(use_total)#</span></cfoutput><br></h3>
<cfif structkeyexists(session.reg_options[2], 'editing_registration') and val(session.reg_options[2].editing_registration) gt 0>
	<cfset session.reg_payments = rc.FERRARI_REG.getPaymentTotal(session.reg_options[2].editing_registration)>
<cfelse>
	<cfset session.reg_payments = 0>
</cfif>

<cfoutput>

<cfif request.runningTotal eq 0>
			<cfset session.target_total = 0>
			<cfset session.runningTotal = 0>
			<cfset session.useTax = 0>
<cfelse>

	<cfif session.event_config.charge_tax eq 1 and val(session.event_config.taxrate) gt 0>

			<h3>Tax: <span class="dollar_container">#dollarformat(rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100)))#</span></h3>
			<cfset session.useTax = rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100))>
			<cfset use_total += rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100))>
			<cfset session.runningTotal = use_total>
			<cfif session.reg_payments gt 0>
				<h3>Subtotal: <span class="dollar_container">#dollarformat(use_total)#</span></h3>
				<cfset use_total -= session.reg_payments>
				<h3>Minus Previous Payments: <span class="dollar_container">#dollarformat(-1 * session.reg_payments)#</span></h3>
			</cfif>
			<h3>Grand Total: <span class="dollar_container">#dollarformat(use_total)#</span></h3>	
			<cfset session.target_total = use_total>
			<cfset session.runningTotal = use_total>
			<cfset session.useTax = 0>
		
		<input type="hidden" name="taxAmount" value="#rc.FERRARI_REG.roundPenniesUp(use_total)#">
	<cfelse>
		<cfset session.runningTotal = request.runningTotal>
		<cfset session.useTax = 0>
		<cfif session.reg_payments gt 0>
			<cfset use_total -= session.reg_payments>
			<h3>Previous Payments: <span class="dollar_container">#dollarformat(-1 * session.reg_payments)#</span></h3>
		</cfif>
		<h3>Total Due: <span class="dollar_container">#dollarformat(rc.FERRARI_REG.roundPenniesUp(use_total))#</span></h3>	
		<cfset session.target_total = use_total>
		<input type="hidden" name="taxAmount" value="#rc.FERRARI_REG.roundPenniesUp(use_total)#">
	</cfif>
</cfif>

</cfoutput>
			</div></div>