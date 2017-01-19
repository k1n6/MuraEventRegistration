
<fieldset>
	<cfset cnt = 0>
	<cfif guest eq "">
		<legend class="main_legend">Your Options</legend>
		<cfset guestsuffix = "">
	<cfelse>
		<legend class="main_legend"><cfoutput>#guestName#</cfoutput> Options</legend>
		<cfset guestsuffix = "_#guest#">
	</cfif>
	<div class="col-md-12">
		<cfoutput>
			<div class="form-group row" >
				<label for="MainEvent" class="control-label col-sm-3">
					<input type="checkbox" disabled  name='MainEvent' value='1' checked readonly='true' style="display: none;">
					Main Event (required)
				</label>
				<div class="col-sm-5">

					<p>#dateformat(rc.event_data.main_data.eventdate, 'long')# #timeformat(rc.event_data.main_data.event_startTime, 'short')# to #timeformat(rc.event_data.main_data.event_endTime, 'short')#</p>
				</div>
				<div class="col-sm-4">
					<cfset usedPrices = {}>
				
					<select name="main_eventprice#guestsuffix#"  class="form-control">
						<cfloop query="rc.event_data.price_data">
							<cfif not structkeyexists(usedPrices, price_id)
								and (
									( guestsuffix eq '' and 
										(available_to eq 3 
										or ( available_to eq 2 and not session.isMember)
										or ( available_to eq 1 and session.isMember)
										)
									) or (
										guestsuffix neq '' and listfindnocase('2,3', available_to)
									))
									
									
									>
								<cfset usedPrices[price_id] = 1>
								<option value="#price_id#"
										<cfif listfindnocase(input_struct['main_eventprice#guestsuffix#'], price_id)>
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
		</cfoutput>
		
		<cfset lastgroup = "">
		<cfoutput query="rc.event_data.main_data" group="optiongroupid">
			<cfif ( guestsuffix eq '' and 
										(optiongroup_available_to eq 3 
										or ( optiongroup_available_to eq 2 and not session.isMember)
										or ( optiongroup_available_to eq 1 and session.isMember)
										)
									) or (
										guestsuffix neq '' and listfindnocase('2,3', optiongroup_available_to)
									)>
				<cfif lastgroup neq field_group>
					<cfset lastgroup = field_group>									
					<cfif field_group neq "">
						<legend class="sublegend">#field_group#</legend>
					</cfif>
				</cfif>
				<div class="form-group row">
					<label for="optiongroup#optiongroupid##guestsuffix#" class="control-label col-sm-3 text-align-right
																				<cfif required eq 1> required </cfif>
					">
						<cfif required eq 1>
							<input type="checkbox" disabled id="optiongroup#optiongroupid##guestsuffix#" name='optiongroup#guestsuffix#' value='#optiongroupid#'
									 checked readonly='true' style="display: none;">
							<input type="hidden" name="optiongroup" value="#optiongroupid#" />
						<cfelse>
							<input style="display: none;" <cfif listfindnocase(input_struct['optiongroup#guestsuffix#'], optiongroupid)>checked</cfif> type="checkbox" id="optiongroup#optiongroupid##guestsuffix#" name='optiongroup#guestsuffix#' value='#optiongroupid#' >
						</cfif>
						#group_name#

					</label>
					<div class="col-sm-9">
						<div class="flexparent">

							<div class="flexchild">
								
								<cfif require_data neq "">
									<cfquery name="thisGroupData" dbtype="query">
										select require_data, field_group, group_description, optiongroupid
										from rc.event_data.main_data
										where optiongroupid = #optiongroupid#
									</cfquery>
									<cf_requiredDataField groupdata="#thisGroupData#" input_struct="#input_struct#" suffix="#guestsuffix#" required="#required#">
								</cfif>
								<cfif group_description neq "<p><br></p>">
									#group_description#
								</cfif>
							</div>
								
						<cfif option_id neq "">
							<div class="flexchild">

								
								<cfset usedOptions = {}>
								<select name="option#guestsuffix#"  class="form-control" onchange="updateCheckbox(this, '#optiongroupid##guestsuffix#');">
									<cfif required neq 1>
										<option value="">Make a selection..</option>
									</cfif>
									<cfoutput>
										<cfset cnt += 1>
										<cfif not structkeyexists(usedOptions, option_id)
										and (
											( guestsuffix eq '' and 
												(option_available_to eq 3 
												or ( option_available_to eq 2 and not session.isMember)
												or ( option_available_to eq 1 and session.isMember)
												)
											) or (
												guestsuffix neq '' and listfindnocase('2,3', option_available_to)
											))
											>
											<cfset usedOptions[option_id] = 1>
											<option value="#option_id#"
													<cfif listfindnocase(input_struct['option#guestsuffix#'], option_id)>
														selected
													  <cfset request.runningTotal += val(price)>
													</cfif>
													>
												#name#
												#dollarformat(price)#
											</option>

										</cfif>
									</cfoutput>
								</select>
								<p>Select an option above for <em>#group_name#</em></p>
							</div>	
						<cfelse>
							<cfset cnt += 1>
						</cfif>		
							</div>				
					</div>

				</div>
			<cfelse>
				<cfoutput>
					<cfset cnt += 1>
				</cfoutput>
			</cfif>

		</cfoutput>
	</div>
</fieldset>