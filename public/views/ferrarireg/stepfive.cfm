
<cfparam default="5" name="curstep">
<cfinclude template="stepSaver.cfm">
<cfparam name="request.runningTotal" default="0">
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
</cfif>
<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<h2>Payment Information</h2>		
		</div>
	</div>
		<div class="panel panel-default">
			<cfsavecontent variable="summary">
					<script>
							$(function(){
								$('input, select').prop('disabled', 'true');
							})
					</script>
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
											<div class="col-sm-12">
												<h3>Total price of all acivities and options selected: <cfoutput>#dollarformat(request.runningTotal)#</cfoutput><br></h3>

											</div>
										</div>

									</fieldset>

								</div>
							</form>
						</div>
			
			</cfsavecontent>
			<cfset session.summary_data = summary>
			<form method="post" action="?EventRegistrationaction=public:ferrarireg.stepfour&EventID=<cfoutput>#rc.eventid#</cfoutput>">
				<div class="panel-body">
				<fieldset>
					<h3>Total price of all acivities and options selected: <cfoutput>#dollarformat(request.runningTotal)#</cfoutput><br></h3>
				</fieldset>
				<fieldset>
				
						<div class="form-group row">
							<div class="col-sm-3 pull-left">
								<button class="btn btn-primary" onclick="window.location.href = '?EventRegistrationaction=public:ferrarireg.stepfour&EventID=<cfoutput>#rc.eventid#</cfoutput>&goingback=true';  return false;">&lt;- Return to Review</button>
							</div>
							<cfset NOTIFYURL = "http://#cgi.server_name#/notify.cfm">
							<cfset TransactionID= "FCA Events Registration">
							<cfset return = "">
							<cfset cancel_return = "">
							<cfset custom = "">
							<cfset paypalurl= "https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&invoice=#right(getTickcount(), 5)#&notify_url=#notifyurl#&business=dan.baughman@gmail.com&item_name=#TransactionID#&item_number=Registration_7463&amount=#request.runningtotal#&shipping=0%2e00&no_shipping=0&no_note=1&tax=0%2e00&lc=US&currency_code=USD&bn=PP%2dBuyNowBF&charset=UTF%2d8&return=#return#&cancel_return=#cancel_return#&custom=#custom#">

							<div class="col-sm-3">
								<a 
									href="?EventRegistrationaction=public:ferrarireg.thankyou"
									class="btn btn-primary">Admin Checkout</a>
							</div>			
							<div class="col-sm-3 pull-right text-align-right">
								<a 
								   href = "<cfoutput>#paypalurl#</cfoutput>"
								   class="btn btn-primary" type="submit">Pay Through Pay Pal</a>
							</div>

						</div>
					
				</fieldset>
				
				</div>
			</form>
		</div>
					
</div>
	
	
	

