
<fieldset>
	<cfset cnt = 0>
	<cfif guest eq "">
		<legend class="main_legend">Your Options</legend>
		<cfset guestsuffix = "_0">
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
					<select name="main_eventprice#guestsuffix#"  class="form-control"
						
						
						>
						<cfloop query="rc.event_data.price_data">
							<cfif not structkeyexists(rc.counts.eventCounts,price_id)>
								<cfset rc.counts.eventCounts[price_id] = 0>
							</cfif>
							<cfif val(price_max_participation) gt 0 and max(0, price_max_participation - rc.counts.eventCounts[price_id]) eq 0>
							
							<cfelse>

								

								<cfif not structkeyexists(usedPrices, price_id)
									and (
										( guestsuffix eq '_0' and 
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
												<cfset request.total_items['main_eventprice_#val(guest)#'] = {id = price_id, price=val(price), guest=val(guest)}>

												selected 
											</cfif>
									>
									<cfif price gt 0>
										#dollarformat(price)# 
											/ 
									</cfif>
										#price_name#
										<cfif val(price_max_participation) gt 0>
											<br />						
											(#numberformat(max(0, price_max_participation - rc.counts.eventCounts[price_id]), ',')# left)
										<cfelse>
											(no cost)
										</cfif>

									</option>

								</cfif>
							</cfif>
						</cfloop>
					</select>							
				</div>
			</div>	
		</cfoutput>
		
		<cfset lastgroup = "">

		<cfoutput query="rc.event_data.main_data" group="optiongroupid">
			<cfif not structkeyexists(rc.counts.optionGroupCounts,optiongroupid)>
				<cfset rc.counts.optionGroupCounts[optiongroupid] = 0>
			</cfif>
		
			<cfif 
					 (not (
						val(optiongroup_maxparticipation) gt 0 
						and max(0, optiongroup_maxparticipation - rc.counts.optionGroupCounts[optiongroupid]) eq 0
					))
							and
								
									( guestsuffix eq '_0' and 
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
							<input type="checkbox" disabled id="optiongroup#optiongroupid##guestsuffix#" 
								 	name='optiongroup#guestsuffix#' value='#optiongroupid#'
									 checked readonly='true' style="display: none;">
							<input type="hidden" name="optiongroup#guestsuffix#" value="#optiongroupid#" />
						<cfelse>
							<input style="display: none;" <cfif listfindnocase(input_struct['optiongroup#guestsuffix#'], optiongroupid)>checked</cfif>
								type="checkbox" id="optiongroup#optiongroupid##guestsuffix#" name='optiongroup#guestsuffix#' value='#optiongroupid#' >
						</cfif>
						#group_name#
						<cfif val(optiongroup_maxparticipation) gt 0>
							(#numberformat(max(0, optiongroup_maxparticipation - rc.counts.optionGroupCounts[optiongroupid]), ',')# left)
						</cfif>
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
										<cfif not structkeyexists(rc.counts.optionCounts,option_id)>
											<cfset rc.counts.optionCounts[option_id] = 0>
										</cfif>
									
										<cfset cnt += 1>
										<cfif 
											(not (
												val(option_max_participation) gt 0 
												and max(0, option_max_participation - rc.counts.optionCounts[option_id]) eq 0
											))
											and
										
											not structkeyexists(usedOptions, option_id)
										and (
											( guestsuffix eq '_0' and 
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
													  <cfset request.total_items['option_#option_id#_#val(guest)#'] = {id = option_id, price=val(price), guest=val(guest)}>
													  <cfset request.runningTotal += val(price)>
													</cfif>
													>
												#name#
												<cfif price gt 0>
													#dollarformat(price)#
												<cfelse>
										   	 
											 	</cfif>
											 	<cfif val(option_max_participation) gt 0>
													(#numberformat(max(0, option_max_participation - rc.counts.optionCounts[option_id]), ',')# left)
												</cfif>
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