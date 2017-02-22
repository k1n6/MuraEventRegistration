
<cfparam default="5" name="curstep">
<cfinclude template="stepSaver.cfm">
<cfparam name="request.runningTotal" default="0">
<cfparam name="request.total_items" default="#structnew()#">
<cfparam name="input_struct.optiongroup" default="" >
<cfparam default="false" name="reviewmode">

<!---   
	This prevents the back button / reload page confirmation prompt to users.
--->
<cfset req = getHTTPRequestData()>
<cfif req.method eq "POST" and reviewmode neq "true">
	<script>
		window.location.href = window.location.href;
	</script>
	<cfabort>
</cfif>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<h2>Payment Information</h2>		
		</div>
	</div>
		<div class="panel panel-default">
			<cfsavecontent variable="summary">
					<div class="summary_html">
						<script>
							$(function(){
								$('.summary_html input, .summary_html select').prop('disabled', 'true');
							})
						</script>
						<cfset request.runningTotal ="0">
						<cfset request.total_items ="#structnew()#">
						<cfset reviewmode = true>
						<cfset url.goingback = 'true'>
						<cfset curstep = 1>
						<cfinclude template="default.cfm">
						<cfset curstep = 2>
						<cfinclude template="steptwo.cfm">
						<cfset curstep = 3>
						<cfinclude template="stepthree.cfm">
						<br clear="all" />

						<div class="container-fluid">


							<div class="panel panel-default">
								<form method="post" action="?EventRegistrationaction=public:ferrarireg.stepfive&EventID=<cfoutput>#rc.eventid#</cfoutput>">
									<div class="panel-body">
										<fieldset>
											<div class="form-group row">
												<div class="col-sm-12 text-align-right">
													<h3>Total price of all acivities and options selected: <cfoutput>#dollarformat(request.runningTotal)#</cfoutput><br></h3>
													<cfif session.event_config.charge_tax eq 1 and val(session.event_config.taxrate) gt 0>
														<cfoutput>
															<h3>Tax: #dollarformat(request.runningTotal * (session.event_config.taxrate / 100))#</h3>
															<h3>Total: #dollarformat(request.runningTotal + request.runningTotal * (session.event_config.taxrate / 100))#</h3>
															<cfset  session.runningTotal = request.runningTotal>
															<cfset total = request.runningTotal + request.runningTotal * (session.event_config.taxrate / 100)>
														</cfoutput>
													<cfelse>
														<cfset  session.runningTotal= request.runningTotal>
														<cfset total = request.runningTotal>														
													</cfif>
												</div>
											</div>

										</fieldset>

									</div>
								</form>
							</div>
					</div>
			</cfsavecontent>
			<cfset session.total_items = request.total_items>
			<cfset session.summary_data = summary>
			<form method="post" action="?EventRegistrationaction=public:ferrarireg.stepfour&EventID=<cfoutput>#rc.eventid#</cfoutput>">
				<div class="panel-body">
				<fieldset>
					<div class="col-sm-12 text-align-right">
													<h3>Total price of all acivities and options selected: <cfoutput>#dollarformat(request.runningTotal)#</cfoutput><br></h3>
													<cfif session.event_config.charge_tax eq 1 and val(session.event_config.taxrate) gt 0>
														<cfoutput>
															<h3>Tax: #dollarformat(rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100)))#</h3>
															<h3>Total: #dollarformat(request.runningTotal + request.runningTotal * (session.event_config.taxrate / 100))#</h3>
															<cfset total = request.runningTotal + rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100))>
														</cfoutput>
														<input type="hidden" name="taxAmount" value="#rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100))#">
														<cfset session.useTax = rc.FERRARI_REG.roundPenniesUp(request.runningTotal * (session.event_config.taxrate / 100))>
													<cfelse>
														<input type="hidden" name="taxAmount" value="0">
														<cfset session.useTax = 0>
														<cfset total = request.runningTotal>
													</cfif>
												</div>
				</fieldset>
				<fieldset>
		
						<div class="form-group row">
							<div class="col-sm-6 pull-left">
								<button class="btn btn-primary" onclick="window.location.href = '?EventRegistrationaction=public:ferrarireg.stepfour&EventID=<cfoutput>#rc.eventid#</cfoutput>&goingback=true';  return false;">&lt;- Return to Review</button>
							</div>
							<cfset NOTIFYURL 			= urlencodedformat("http://#cgi.server_name#:9191/notify.cfm")>
							<cfset TransactionID		= "FCA Events Registration">
							<cfset return				= urlencodedformat("http://#cgi.server_name#/event-registration/public-registration-page/?EventRegistrationaction=public:ferrarireg.lastReg")>
							<cfset cancel_return 		= urlencodedformat("http://#cgi.server_name##cgi.path_info#?#cgi.query_string#")>
							<cfset custom 				= urlencodedformat("http://#cgi.server_name##cgi.path_info#?#cgi.query_string#")>
							<cfset paypalemail 			= session.event_config.paypal_emailaddress>
							<cfset item_number 			= "#numberformat(getTickCount() / 1000, '0')#">
							<cfset paypalurl 			= "www.paypal.com">
							<cfif session.event_config.paypal_sandbox_mode eq '1'>
								<cfset paypalurl 		= "www.sandbox.paypal.com">
							</cfif>
							<cfset paypalurl			= "https://#paypalurl#/cgi-bin/webscr?cmd=_xclick&notify_url=#notifyurl#&business=#paypalemail#&item_name=#TransactionID#&item_number=#item_number#&amount=#total#&shipping=0%2e00&no_shipping=0&no_note=1&tax=0%2e00&lc=US&currency_code=USD&bn=PP%2dBuyNowBF&charset=UTF%2d8&return=#return#&cancel_return=#cancel_return#&custom=#custom#&invoice=">

										
							<div class="col-sm-6 pull-right text-align-right">
								<a 
								   data-paypal-href = "<cfoutput>#paypalurl#</cfoutput>"
								   id="paypalCheckoutButton"
								   class="btn btn-primary" type="submit">Pay Through Pay Pal</a><br>
									<br>
								<cfif val(session.event_config.allow_checks) eq 1>
								<a 
									href="?EventRegistrationaction=public:ferrarireg.thankyou&payviaCheck=true"
									class="btn btn-primary">Mail In A Check</a>
								
								</cfif>

							</div>
							<div class="col-sm-12">
								<br>
								<br>
								<a 
									href="?EventRegistrationaction=public:ferrarireg.thankyou"
									class="btn btn-primary">Admin Checkout</a>
							</div>
							

						</div>
					
				</fieldset>
				
				</div>
			</form>
		</div>
					
</div>
<script>
	$(function(){
		$('#paypalCheckoutButton').on('click', function(){
			var pphref = $(this).attr('data-paypal-href');
			$.get('.?EventRegistrationaction=public:ferrarireg.thankyou', function(d){
				regid = $(d).find("#registrationid")[0].innerHTML;
				console.log(pphref + regid);
				window.location.href = pphref + regid;
			})
			
		})
		
	})
</script>
	
	
	

