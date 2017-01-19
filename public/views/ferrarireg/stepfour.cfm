
<cfparam default="4" name="curstep">
<cfinclude template="stepSaver.cfm">
<cfparam name="input_struct.optiongroup" default="" >
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
	<cfabort>
</cfif>

<div class="">
	<div class="row">
		<div class="col-md-12">
			<h2>Registration Review</h2>		
		</div>
	</div>
	<script>
			$(function(){
				$('input, select').prop('disabled', 'true').prop("placeholder", "");
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
				<form method="post" action="?EventRegistrationaction=public:ferrarireg.stepfive&EventID=<cfoutput>#rc.eventid#</cfoutput>" role="form" data-toggle="validator">
					<div class="panel-body">
						<fieldset>
							<div class="form-group row">
								<div class="col-sm-12">
									<h3>Total price of all acivities and options selected: <cfoutput>#dollarformat(request.runningTotal)#</cfoutput><br></h3>

								</div>
							</div>
							<div class="form-group row">
								<div class="col-sm-6 pull-left">
									<button class="btn btn-primary" onclick="window.location.href = '?EventRegistrationaction=public:ferrarireg.stepthree&EventID=<cfoutput>#rc.eventid#</cfoutput>&goingback=true'; return false;">&lt;- Go Back</button>
								</div>
								<div class="col-sm-6 pull-right text-align-right">
									<button class="btn btn-primary" type="submit">Proceed To Checkout -></button>
								</div>

							</div>
						</fieldset>

					</div>
				</form>
			</div>
		</div>
				
			
				
					
</div>
	



