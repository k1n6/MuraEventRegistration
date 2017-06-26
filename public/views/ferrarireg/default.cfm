<!---   
	first we need to check if this user is from the admin attempting to Edit a user's registration
	
	then log them in on the front-end as this user if possible.
--->



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
<cfparam name="request.total_items" default="#structnew()#">
<cfinclude template="../main/createMuraUserIfneeded.cfm">
	


<cfif ( 
		val(session.event_config.allow_guests) neq 1 
		or rc.event_data.main_data.allow_guest_registration neq 1
	)
		and  ((not isdefined('session.target_user_session.stmember.id')) or val(session.target_user_session.stmember.id) eq 0)>

		<cfif session.target_user_session.admin_user>
			<h3 class="alert alert-info">Bypassing membership requirement for registration for an admin user</h3>
		<cfelse>
			<cflocation url="#$.siteConfig('memberloginpage')#?logintoregisterforevents=true&returnto=#cgi.path_info#?#urlencodedformat(cgi.query_string)#" addtoken="false">
		</cfif>
		
</cfif>

<!---   
	This pulls member data into the input struct for this form.
	this only overwrites it if it doesn't already exist in the session (built
	by the stepsaver as the user moves 	between steps)
--->
<cfset session.isMember = false>
<cfif rc.member_data.recordcount lte 1>
	<cfloop list="address_1,address_2,address_3,city,country,zip,name_last,name_first,state,membernumber,Email" index='i'>
		<cfif not structkeyexists(input_struct, i)>
			<cfif not structkeyexists(input_struct, i)>
				<cfset input_struct[i] = rc.member_data[i][1]>	
			</cfif>
		</cfif>
	</cfloop>
	<cfset full_name = rc.member_data.name_first & ' ' & rc.member_data.name_last>
	<cfif not structkeyexists(input_struct, 'full_name')>
		<cfset input_struct['full_name'] = full_name>	
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
<div class="">
	<div class="">
	<div class="row">
		<div class="col-md-12">
			<h2>Registering for '#rc.event_data.main_data.shortTitle#'</h2>
		</div>
	</div>
	<cfif reviewmode neq 'true' and rc.event_data.main_data.longdescription neq "<p><br></p>">
		<div class="row">
			<div class="col-md-12 vertical_padding_1">
				#rc.event_data.main_data.longdescription#
			</div>
		</div>
	</cfif>
	
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
						  <h4>Registering As Guest!</h4>
							You are registering as a guest as you are not logged in to a Ferrari Members account. <br>
							<cfif not ( isdefined("reviewmode") and reviewmode eq 'true')>
								<a href="#$.siteConfig('memberloginpage')#?returnto=#urlencodedformat('#cgi.path_info#?#cgi.query_string#')#">Click here to login to your FCA account.</a>
						  	</cfif>
						</div>
				  </div>
				</div>

			</div>
		</div>
	</cfif>
	 
	
	
	
<cfif reviewmode neq 'true'>
	<script>
		 $(function(){
			 $("##StateChoose").chained("##Country");
			 $("##nonMemberGuests").on('change', function(){
				 var target = $(this).val();
				 for(i = 1; i < 11; i++)
					 $('##guest' + i ).css('display', 'none').find('input');//.prop('required', false)
				 for(i = 1; i <= target; i++)
					 $('##guest' + i ).css('display', 'block').find('input');//.prop('required', true)
				 
				if(target >= 1)
					 $('.guest_name_instructions').css('display', 'block');
				else
					 $('.guest_name_instructions').css('display', 'none');
					
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
			<input type="hidden" name="eventid" value="#url.eventid#">
			<cfif structkeyexists(input_struct, 'editing_registration')>
				<input type="hidden" name="editing_registration" value="#input_struct['editing_registration']#" />
			<cfelse>
				<input type="hidden" name="editing_registration" value="" />
			</cfif>
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
				<div class="form-group required"> <!-- Email Address-->
					<label for="full_name_id" class="control-label">Email Address</label>
					<input type="text" class="form-control" id="email_address" name="email_address" placeholder="Email Address"
						required='true' 
						data-error="Please provide a valid email address"
						value="#trim(input_struct['Email'])#"
					>
					<div class="help-block with-errors"></div>
				</div>
				<cfif val(input_struct['membernumber']) gt 0>
					<div class="form-group"> <!-- Member Number -->
						<label for="membernumber" class="control-label">Member Number </label>
						<input type="text" class="form-control" id="membernumber" name="membernumber" placeholder="Member Number"
							required='false' 
							readonly='true'
							data-error=""
							value="#trim(input_struct['membernumber'])#"
						>
						<div class="help-block with-errors"></div>
					</div>
				<cfelse>
					<input type="hidden" name="membernumber" value="0">
				</cfif>
					

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
					<cfloop from='1' to ="10" index='i'>
				
						<cfif not isdefined('input_struct.guest#i#first')>
							<cfset input_struct['guest#i#first'] = "">
						</cfif>
						<cfif not isdefined('input_struct.guest#i#last')>
							<cfset input_struct['guest#i#last'] = "">
						</cfif>
						
						<div class="guest#i#  form-group row" id="guest#i#" style="display: none;">
							<fieldset class="col-md-12">
								<legend>Guest #i# Information</legend>
							</fieldset>
						
							<div class="form-group  col-md-6" >
								<label for="guest#i#first" class="control-label">Guest #i# First Name</label>
								<input type="text" class="form-control" id="guest#i#first" name="guest#i#first" placeholder="First Name"
								  value="#input_struct['guest#i#first']#"
								>
							</div>					

							<div class="form-group col-md-6 "> 
								<label for="guest#i#last" class="control-label">Guest #i# Last Name</label>
								<input type="text" class="form-control" id="guest#i#last" name="guest#i#last" placeholder="Last Name"
								value="#input_struct['guest#i#last']#"
								>
							</div>

							
						</div>
					</cfloop>
					<div class="guest_name_instructions">
						Guest names are optional and we will use placeholders such as "Guest ##1" if you don't enter a name.
					</div>
						
						
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



