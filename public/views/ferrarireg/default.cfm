
<script src="/global/chained.js"></script>
<cfparam name="session.reg_options" default="#arraynew(1)#">
<cfif not (isdefined('url.goingback') and url.goingback eq 'true')>
	<cfset session.reg_options = arraynew(1)>
</cfif>
<cfparam default="1" name="curstep">
<cfinclude template="stepSaver.cfm">

<cfparam default="" name="input_struct.subevent">
<cfparam default="0" name="input_struct.nonMemberGuests">
<cfparam default="" name="input_struct.main_eventprice">
<cfparam default="false" name="reviewmode">
<cfparam name="request.runningTotal" default="0">



<cfif val(session.event_config.allow_guests) neq 1 and  ((not isdefined('session.stmember.id')) or val(session.stmember.id) eq 0)>

	<cflocation url="/members/member-login/?returnto=#cgi.path_info#?#urlencodedformat(cgi.query_string)#" addtoken="false">
</cfif>

<!---   
	This pulls member data into the input struct for this form.
	this only overwrites it if it doesn't already exist in the session (built
	by the stepsaver as the user moves 	between steps)
--->
<cfset session.isMember = false>
<cfif rc.member_data.recordcount lte 1>
	<cfloop list="#rc.member_data.columnlist#" index='i'>
		<cfif not structkeyexists(input_struct, i)>
			<cfif not structkeyexists(input_struct, i)>
				<cfset input_struct[i] = rc.member_data[i][1]>	
			</cfif>
		</cfif>
	</cfloop>
	<cfset full_name = rc.member_data.name_first & ' ' & rc.member_data.name_last>
	<cfif not structkeyexists(input_struct, 'full_name')>
		<cfset input_strut['full_name'] = full_name>	
	</cfif>
</cfif>
<cfif rc.member_data.recordcount gt 0>
	<cfset session.isMember = true>
</cfif>

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

<cfoutput>
<div class="container-fluid">
	<div class="container-fluid">
	<div class="row">
		<div class="col-md-12">
			<h2>Basic Information</h2>		
			<p>Provide your contact information and select which activities you'd like to participate in below.</p>
		</div>
	</div>
	<cfif rc.member_data.recordcount lt 1>
		<div class="row">
			<div class="col-md-12">
				<div class="panel-group panel-warning">
				  <div class="panel panel-default">
					  <div class="panel-body">
						  <h4>Registering As Guest</h4>
							You are registering as a guest as you are not logged in to a Ferrari Members account. <br>
							<cfif not ( isdefined("reviewmode") and reviewmode eq 'true')>
								<a href="/members/member-login/?returnto=#cgi.path_info#?#urlencodedformat(cgi.query_string)#">Click here to login to your FCA account.</a>
						  	</cfif>
						</div>
				  </div>
				</div>

			</div>
		</div>
	</cfif>
	<!---   
	<div class="row">
		<div class="col-md-12">
			<h4>#rc.event_data.main_data.shortTitle#</h4>
		</div>
	</div>
	<cfif reviewmode neq 'true'>
		<div class="row">
			<div class="col-md-12 vertical_padding_1">
				#rc.event_data.main_data.longdescription#
			</div>
		</div>
	</cfif>
	--->
	
<cfif reviewmode neq 'true'>
	<script>
		 $(function(){
			 $("##StateChoose").chained("##Country");
			 $("##nonMemberGuests").on('change', function(){
				 var target = $(this).val();
				 for(i = 0; i < 11; i++)
					 $('##guest' + i ).css('display', 'none').find('input').prop('required', false);
				 for(i = 0; i < target; i++)
					 $('##guest' + i ).css('display', 'block').find('input').prop('required', true);
			 }).change();
			 
			 $('.form-group.required').each(function(){
				 if($(this).find('.help-block').length ==0)
					 $(this).find('input,select').after('<div class="help-block with-errors"></div>');
			 })
		 });
		
	</script>
</cfif>

	<cfinclude template="/fca_plugins/forms/qry_StatesProvinces.cfm">

	
		<div class="panel panel-default">
			<form method="post" action="?EventRegistrationaction=public:ferrarireg.steptwo&EventID=#rc.eventid#" role="form" data-toggle="validator">
			<div class="panel-body">
				<fieldset>
						<legend>Your Contact Information</legend>
				</fieldset>
				<div class="form-group required"> <!-- Full Name -->
					<label for="full_name_id" class="control-label">Full Name</label>
					<input type="text" class="form-control" id="full_name_id" name="full_name" placeholder="Full Name"
						required='true' 
						data-error="Please provide your full name"
						value="#trim(input_struct['full_name'])#"
					>
					<div class="help-block with-errors"></div>
				</div>	

				<div class="form-group required" > <!-- Street 1 -->
					<label for="address_1" class="control-label">Street Address 1</label>
					<input type="text" 
						data-error="You have to enter an address"
					class="form-control" id="address_1" name="address_1" placeholder="Street address, P.O. box, company name, c/o"
					required  value="#input_struct.address_1#"
					>
				</div>					

				<div class="form-group "> <!-- Street 2 -->
					<label for="address_2" class="control-label">Street Address 2</label>
					<input type="text" class="form-control" id="address_2" name="address_2" placeholder="Apartment, suite, unit, building, floor, etc."
					value="#input_struct.address_2#"
					>
				</div>
				
				<div class="form-group"> <!-- Street 3 -->
					<label for="address_3" class="control-label">Street Address 3</label>
					<input type="text" class="form-control" id="address_3" name="address_3" placeholder="Apartment, suite, unit, building, floor, etc."
					value="#input_struct.address_3#"
					>
				</div>

				

				<div class="form-group required"> <!-- City-->
					<label for="city" class="control-label">City</label>
					<input type="text" class="form-control" id="city" name="city" placeholder="City"
					required  value="#input_struct.city#"
					>
				</div>									

				<div class="form-group required">
					<label for="Country" class="control-label">Country</label>
					<select required  class="form-control" id="Country" name="country">

							<option value="" >Choose A Country</option>
							<option value="US" <cfif isdefined("input_struct.country") and input_struct.country eq 'US'> selected </cfif> >United States</option>
							<option value="CA" <cfif isdefined("input_struct.country") and input_struct.country eq 'CA'> selected </cfif>>Canada</option>
							<option value="xx"></option>
					
						<cfloop query="qCountries">
							<cfif qCountries.Abbrev neq 'US' AND qCountries.Abbrev neq 'CA' >
								<option value="#qCountries.Abbrev#" <cfif isdefined("input_struct.country") and input_struct.country eq qCountries.Abbrev> selected="selected" </cfif>>#qCountries.country#</option>
							</cfif>
						</cfloop>
					</select>
				</div>
				<div class="form-group required"> <!-- State Button -->
					<label for="StateChoose" class="control-label">State</label>
					<select required   class="form-control"  name="State" id="StateChoose" 
						data-error="Please select a state from the list"
					>
						<option value="">Choose One...</option>


						<cfloop query="qCountries">
							<cfif qCountries.Abbrev neq 'US' AND qCountries.Abbrev neq 'CA' AND qCountries.Abbrev neq 'MX'>
								<option class="#qCountries.Abbrev#" value="71">Outside U.S./Canada</option>
							</cfif>
							<cfif qCountries.Abbrev eq 'MX'>
								<option class="#qCountries.Abbrev#" value="72" >Mexico</option>
							</cfif>
						</cfloop>

						<cfloop query="qStates">
							<option class="US" value="#qStates.Abbrev#" <cfif isdefined("input_struct.state") and input_struct.state eq qStates.Abbrev> selected="selected" </cfif>>#qStates.vchstateprov#</option>
						</cfloop>

						<cfloop query="qProvinces">
							<option class="CA" value="#qProvinces.Abbrev#" <cfif isdefined("input_struct.state") and input_struct.state eq qProvinces.Abbrev> selected="selected" </cfif>>#qProvinces.vchstateprov#</option>
						</cfloop>

					</select> 					
				</div>

				<div class="form-group required"> <!-- Zip Code-->
					<label for="zip" class="control-label">Zip Code</label>
					<input required   type="text" class="form-control" id="zip" name="zip" placeholder=""
					value="#input_struct.zip#"
					>
				</div>	
				<!---   
					Activities and related price selection was moved to the main event options page and the activities option page, perspectively.
					Otherwise, we are basically asking them twice.


							<fieldset>
								<legend>Select Acitivities</legend>
							</fieldset>
							<div class="form-group">
								<div class="col-sm-4 form-header">
									<h4>Event</h4>
								</div>
								<div class="col-sm-6">
									<h4>Date / Time</h4>
								</div>
								<div class="col-sm-2">
									<h4>Cost</h4>
								</div>
							</div>
							<div class="form-group row" >
								<label for="MainEvent" class="control-label col-sm-3">
									<input type="checkbox" disabled  name='MainEvent' value='1' checked readonly='true'>
									Main Event (required)
								</label>
								<div class="col-sm-5">

									<p>#dateformat(rc.event_data.main_data.eventdate, 'long')# #timeformat(rc.event_data.main_data.event_startTime, 'short')# to #timeformat(rc.event_data.main_data.event_endTime, 'short')#</p>
								</div>
								<div class="col-sm-4">
									<cfset usedPrices = {}>
									<select name="main_eventprice"  class="form-control">
										<cfloop query="rc.event_data.price_data">
											<cfif not structkeyexists(usedPrices, price_id)>
												<cfset usedPrices[price_id] = 1>
												<option value="#price_id#"
														<cfif listfindnocase(input_struct.main_eventprice, price_id)>
															<cfset request.runningTotal += val(price)>
															selected 
														</cfif>
												>
												#dollarformat(price)# / 
													#price_name#

												</option>

											</cfif>
										</cfloop>
									</select>							
								</div>
							</div>	
							<cfset usedActs = {}>
							<cfloop query="rc.event_data.sub_data">
								<cfif not structkeyexists(usedActs, subeventid)>

										<cfset usedActs[subeventid] = 1>
										<div class="form-group row">
											<label for="subevent#subeventid#" class="control-label col-sm-3">
												<cfif subevent_required eq 1>
													<cfset request.runningTotal += val(subevent_price)>
													<input type="checkbox" disabled id="subevent#subeventid#" name='subevent' value='#subeventid#' checked readonly='true'>
													<input type="hidden" name="subevent" value="#subeventid#" />
												<cfelse>
													<input type="checkbox" 
															<cfif listfindnocase(input_struct.subevent, subeventid)> 
																checked
																<cfset request.runningTotal += val(subevent_price)>
															</cfif>

													id="subevent#subeventid#" name='subevent' value='#subeventid#' >
												</cfif>
												#subevent_name# <cfif subevent_required eq 1>(required)</cfif>
											</label>
											<div class="col-sm-5">
												#dateformat(subevent_start, 'long')# #timeformat(subevent_startTime, 'short')# 
												to 
												#timeformat(subevent_endtime, 'short')#
											</div>
											<div class="col-sm-4">

												<cfif subevent_price eq 0>
													Free
												<cfelse>
													#dollarformat(subevent_price)#
													</cfif>
											</div>
											<div class="col-md-12">
												#subevent_description#
											</div>
										</div>

								</cfif>

							</cfloop>
				--->
				<fieldset>
					<legend>Additional Participants</legend>
					<p>Select how many guests you'd like to bring as guests</p>
					<div class="form-group row">
						<div class="col-sm-4">
							Guests
						</div>
						<div class="col-sm-8">
							<select name="nonMemberGuests" id="nonMemberGuests"  class="form-control">
								<cfloop from='0' to ="10" index='i'>
									<option value="#i#"
											<cfif input_struct.nonMemberGuests eq i> selected </cfif>
									>#i# additional guests</option>
								</cfloop>
							</select>
						</div>
					</div>
					<cfloop from='0' to ="10" index='i'>
				
						<cfif not isdefined('input_struct.guest#i#first')>
							<cfset input_struct['guest#i#first'] = "">
						</cfif>
						<cfif not isdefined('input_struct.guest#i#last')>
							<cfset input_struct['guest#i#last'] = "">
						</cfif>
						<cfif not isdefined('input_struct.guest#i#email')>
							<cfset input_struct['guest#i#email'] = "">
						</cfif>
						<div class="guest#i#  form-group row" id="guest#i#" style="display: none;">
							<fieldset class="col-md-12">
								<legend>Guest #i+1# Information</legend>
							</fieldset>
						
							<div class="form-group required col-md-6" >
								<label for="guest#i#first" class="control-label">Guest #i+1# First Name</label>
								<input type="text" class="form-control" id="guest#i#first" name="guest#i#first" placeholder="First Name"
								required  value="#input_struct['guest#i#first']#"
								>
							</div>					

							<div class="form-group col-md-6 required"> 
								<label for="guest#i#last" class="control-label">Guest #i+1# Last Name</label>
								<input type="text" class="form-control" id="guest#i#last" name="guest#i#last" placeholder="Last Name"
								value="#input_struct['guest#i#last']#"
								>
							</div>

							<div class="form-group required col-md-12"> 
								<label for="guest#i#email" class="control-label">Guest #i+1# Email Address</label>
								<input type="email" class="form-control" id="guest#i#email" name="guest#i#email" placeholder="Email Address"
								value="#input_struct['guest#i#email']#"
								>
							</div>
						</div>
					</cfloop>

						
						
				</fieldset>
				<cfif reviewmode neq 'true'>
					<fieldset>
						<div class="form-group row">
							<div class="col-sm-12 pull-right text-align-right">
								<button class="btn btn-primary" type="submit">Proceed To Next Step -></button>
							</div>

						</div>
					</fieldset>
				</cfif>
					
			</form>
		</div>
		</div>
	</div>
			
</div>
</cfoutput>



