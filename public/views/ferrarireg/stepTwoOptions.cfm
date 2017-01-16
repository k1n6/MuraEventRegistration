
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
							<cfif not structkeyexists(usedPrices, price_id)>
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
		<cfoutput query="rc.event_data.main_data" group="optiongroupid">
			<cfif field_group neq "">
				<legend class="sublegend">#field_group#</legend>
			</cfif>
			<div class="form-group row">
				<label for="optiongroup#optiongroupid##guestsuffix#" class="control-label col-sm-3">
					<cfif required eq 1>
						<input type="checkbox" disabled id="optiongroup#optiongroupid##guestsuffix#" name='optiongroup#guestsuffix#' value='#optiongroupid#'
								 checked readonly='true' style="display: none;">
						<input type="hidden" name="optiongroup" value="#optiongroupid#" />
					<cfelse>
						<input style="display: none;" <cfif listfindnocase(input_struct['optiongroup#guestsuffix#'], optiongroupid)>checked</cfif> type="checkbox" id="optiongroup#optiongroupid##guestsuffix#" name='optiongroup#guestsuffix#' value='#optiongroupid#' >
					</cfif>
					#group_name#

				</label>
				<div class="col-sm-5">
					<p>#group_description#</p>
					<cfif require_data neq "">
						<cfquery name="thisGroupData" dbtype="query">
							select require_data, field_group, group_description, optiongroupid
							from rc.event_data.main_data
							where optiongroupid = #optiongroupid#
						</cfquery>
						<cf_requiredDataField groupdata="#thisGroupData#" input_struct="#input_struct#" suffix="#guestsuffix#">
					</cfif>
				</div>
				<div class="col-sm-4">
					<cfif option_id neq "">
						<p>Select an option below  for <em>#group_name#</em></p>
						<cfset usedOptions = {}>
						<select name="option#guestsuffix#"  class="form-control" onchange="updateCheckbox(this, '#optiongroupid##guestsuffix#');">
							<cfif required neq 1>
								<option value="">Make a selection..</option>
							</cfif>
							<cfoutput>
								<cfset cnt += 1>
								<cfif not structkeyexists(usedOptions, option_id)>
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
					<cfelse>
						<cfset cnt += 1>
					</cfif>						
				</div>

			</div>


		</cfoutput>
	</div>
</fieldset>