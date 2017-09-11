
<cfparam default="4" name="curstep">
<cfinclude template="stepSaver.cfm">
<cfparam name="input_struct.optiongroup" default="" >
<cfparam name="request.runningTotal" default="0">
<cfparam name="request.total_items" default="#structnew()#">
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

	<div class="panel panel-default">
		<form method="post" action="?EventRegistrationaction=public:ferrarireg.stepfive&EventID=<cfoutput>#rc.eventid#</cfoutput>" role="form" data-toggle="validator">
			<div class="panel-body">
				<fieldset>
					<div class="form-group row">
						<div class="col-sm-12 text-align-right">
							<cfset use_total = request.runningTotal>
							<cfinclude template="total_block.cfm">
						</div>
					</div>

					<div class="form-group row">
						<div class="col-sm-6 pull-left">
							<button class="btn btn-primary" onclick="window.location.href = '?EventRegistrationaction=public:ferrarireg.stepthree&EventID=<cfoutput>#rc.eventid#</cfoutput>&goingback=true'; return false;">&lt;- Go Back</button>
						</div>
						<div class="col-sm-6 pull-right text-align-right">
							<cfparam default="false" name="session.target_user_session.admin_user">
								<cfif arraylen(session.reg_options) lt 5 or not structkeyexists(session.reg_options[5], 'admin_notes')>
									<cfset use_notes = "">
								<cfelse>
									<cfset use_notes = session.reg_options[5].admin_notes>
								</cfif>

								<cfif session.target_user_session.admin_user>
									<div class="form-group">
										<label for="Country" class="control-label">Admin Notes</label>
										<textarea name="admin_notes" class="form-control">
											<cfoutput>
												#use_notes#													
											</cfoutput>
										</textarea>
									</div>

								</cfif>


							<cfif val(use_total) lte 0>
								<button class="btn btn-primary" type="submit">Proceed -></button>
							<cfelse>
								<button class="btn btn-primary" type="submit">Proceed To Checkout -></button>
							</cfif>
						</div>

					</div>
				</fieldset>

			</div>
		</form>
	</div>					
</div>
	



