<cfif guest eq "">
	<legend class="main_legend">Your Activities</legend>
	<cfset guestsuffix = "">
<cfelse>
	<legend class="main_legend"><cfoutput>#guestName#</cfoutput> Activities</legend>
	<cfset guestsuffix = "_#guest#">
</cfif>

<fieldset>
<cfset used_activities = 0>
<cfoutput query="getChosenSubData" group="subeventid">
	<cfif (
										( guestsuffix eq '' and 
											(subevent_available_to eq 3 
											or ( subevent_available_to eq 2 and not session.isMember)
											or ( subevent_available_to eq 1 and session.isMember)
											)
										) or (
											guestsuffix neq '' and listfindnocase('2,3', subevent_available_to)
										))>
		<cfset used_activities += 1>
		<div class="col-md-12">
					<legend class="sublegend">
						#subevent_name#  
							<cfif val(subevent_price) gt 0>
								/ #dollarformat(subevent_price)#
							<cfelse>

							</cfif>
						<div class="pull-right">
						#dateformat(subevent_start, 'long')# #timeformat(subevent_startTime, 'short')# 
								to 
								#timeformat(subevent_endtime, 'short')#
						</div>

					</legend>
		</div>

		<cfset cnt = 0>
		<cfset activity_chosen = false>
		<cfoutput group="optiongroupid">
			<div class="form-group row">
				<div class="col-md-12">
					<label for="optiongroup#subeventid##guestsuffix#" class="control-label col-sm-3">
						<cfif required eq 1>
							<cfset activity_chosen = true>
							<input type="checkbox" disabled id="optiongroup#subeventid#" name='optiongroup#guestsuffix#' value='#subeventid#'
									 checked readonly='true'>
							<input type="hidden" name="optiongroup" value="#subeventid#" />
						<cfelse>
							<input type="checkbox"  <cfif listfindnocase(input_struct['optiongroup#guestsuffix#'], subeventid)>checked
							<cfset activity_chosen = true>
							<cfset request.runningTotal += val(price)>
							</cfif> id="optiongroup#subeventid##guestsuffix#" name='optiongroup#guestsuffix#' value='#subeventid#' >
						</cfif>
						<cfif group_name eq "">
							#subevent_name#
						<cfelse>
							#group_name#
						</cfif>


						<cfif activity_chosen>
							<cfset request.runningTotal += val(subevent_price)>
						</cfif>


					</label>
					<div class="col-sm-5">
						<p>#group_description#</p>
						<cfif require_data neq "">
							<cfquery name="thisGroupData" dbtype="query">
								select require_data, field_group, group_description, optiongroupid
								from getChosenSubData
								where optiongroupid = #optiongroupid#
							</cfquery>
							<cf_requiredDataField groupdata="#thisGroupData#" input_struct="#input_struct#" suffix="#guestsuffix#">
						</cfif>
					</div>
					<div class="col-sm-4">
						<cfif option_id neq "">

							<cfset usedOptions = {}>
								<p>Make a selection below for <em>#group_name#</em></p>
							<select name="option#guestsuffix#"  class="form-control" onchange="updateCheckbox(this, #optiongroupid#);">
								<cfif required neq 1>
									<option value="">Make a selection..</option>
								</cfif>
								<cfoutput>
									<cfset cnt += 1>
									<cfif not structkeyexists(usedOptions, option_id)>
										<cfset usedOptions[option_id] = 1>
										<option value="#option_id#"
										<cfif listfindnocase(input_struct['option#guestsuffix#'], option_id)>
											<cfset request.runningTotal += val(price)>
											selected
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
				<cfif cnt neq getChosenSubData.recordcount>
					<div class="form-group row">
						<div class="hide-sm col-sm-10 col-sm-push-1"><hr></div>
					</div>
				<cfelse>

				</cfif>
			</div>
		</cfoutput>
	</cfif>
</cfoutput>
<cfif used_activities eq 0>
	<div class="col-md-12">
	
		<h4>No Activities Available</h4>
		
	</div>
</cfif>
					</fieldset>