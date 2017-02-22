<cfif guest eq "">
	<legend class="main_legend">Your Activities</legend>
	<cfset guestsuffix = "_0">
<cfelse>
	<legend class="main_legend"><cfoutput>#guestName#</cfoutput> Activities</legend>
	<cfset guestsuffix = "_#guest#">
</cfif>

<fieldset>
<cfset used_activities = 0>
<cfset cnt = 0>
<cfset eventWasVisible = false>
<cfoutput query="getChosenSubData" group="subeventid">
<cfset activity_chosen = false>
	<cfif (
		( guestsuffix eq '_0' and 
			(subevent_available_to eq 3 
			or ( subevent_available_to eq 2 and not session.isMember)
			or ( subevent_available_to eq 1 and session.isMember)
			)
		) or (
			guestsuffix neq '' and listfindnocase('2,3', subevent_available_to)
		))>
		<cfset eventWasVisible = true>
		<cfset used_activities += 1>
		<div class="col-md-12 pad_10 clearfix">
					
					<div class="col-xs-1 sublegend text-align-right" >
					
					<input type="checkbox" 
						name="subevent#guestsuffix#"
						id="subevent#guestsuffix#_#subeventid#"
						value ="#subeventid#"
						class="sub_event_checkbox"
						data-subeventid = "#subeventid##guestsuffix#"
						   <cfif subevent_required eq '1'>disabled</cfif>
						<cfif subevent_required eq '1'
						or listfindnocase(input_struct['subevent#guestsuffix#'], subeventid)
							>
							<cfset activity_chosen = true>
							checked="true"
							<cfset request.runningTotal += val(subevent_price)>
							<cfset request.total_items['subevent_#val(guest)#'] = {id = subeventid, price=val(subevent_price), guest=val(guest)}>
						</cfif>
					/>
					<cfif subevent_required eq '1'>
						<input type="hidden" name="subevent#guestsuffix#" value ="#subeventid#">
						
					</cfif>
							</div><div class="col-xs-10">
							
					<label for="subevent#guestsuffix#_#subeventid#">
						#subevent_name#  
							<cfif val(subevent_price) gt 0>
								
							<cfelse>

							</cfif>
						<div class="pull-right">&nbsp;
						#dateformat(subevent_start, 'long')# #timeformat(subevent_startTime, 'short')# 
								to 
								#timeformat(subevent_endtime, 'short')#
						</div>
								</label>
								</div>
					</div>


		
	
		<div id="sub_event_options_#subevent##guestsuffix#">
			<cfset lastgroup = "">
			<cfoutput group="optiongroupid">
				<cfset optiongroup_chosen = false>
				<cfif  (
						( guestsuffix eq '_0' and 
							(optiongroup_available_to eq 3 
							or ( optiongroup_available_to eq 2 and not session.isMember)
							or ( optiongroup_available_to eq 1 and session.isMember)
							)
						) or (
							guestsuffix neq '' and listfindnocase('2,3', optiongroup_available_to)
						))


						>

				<cfif lastgroup neq field_group>
					<cfset lastgroup = field_group>									
					<cfif field_group neq "">
						<div class="form-group row">
							<div class="col-sm-11 col-sm-push-1">
								<legend class="sublegend">#field_group#</legend>
							</div>
						</div>
					</cfif>
						
				</cfif>
							
				<div class="form-group row">
					<div class="col-md-12 ">
						<label for="optiongroup#subeventid##guestsuffix#" class="control-label col-sm-3 text-align-right
																				 <cfif required eq 1> required <cfelse>  </cfif> ">
							
							<cfif required eq 1>
								<!---   
								<input type="checkbox" disabled id="optiongroup#subeventid#" name='optiongroup#guestsuffix#' value='#subeventid#'
										 checked readonly='true'>
										--->
				
								<input type="hidden" id="optiongroup#guestsuffix#" name="optiongroup#guestsuffix#" value="#optiongroupid#" />
								<cfset optiongroup_chosen = true>
							<cfelse>
								<input type="checkbox"  
								<cfif listfindnocase(input_struct['optiongroup#guestsuffix#'], optiongroupid)>
									checked
									<cfset optiongroup_chosen = true>
								</cfif>
									id="optiongroup#optiongroupid##guestsuffix#" name='optiongroup#guestsuffix#' value='#optiongroupid#' 
									class="no_visible"
								>
							</cfif>
							<cfif group_name eq "">
								#subevent_name#
							<cfelse>
								#group_name#
							</cfif>




						</label>
							
						<div class="col-sm-9">
				

							<div class="flexparent">

								<div class="flexchild">
										
									<cfif require_data neq "">
										<cfquery name="thisGroupData" dbtype="query">
											select require_data, field_group, group_description, optiongroupid
											from getChosenSubData
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

										<select name="option#guestsuffix#"  class="form-control" onchange="updateCheckbox(this, #optiongroupid#);">
												<cfif required neq 1>
													<option value="">Make a selection..</option>
												</cfif>
												<cfoutput>
													<cfset cnt += 1>
													<cfif not structkeyexists(usedOptions, option_id)
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
															<cfif optiongroup_chosen and activity_choseN>
																<cfset request.runningTotal += val(price)>
																<cfset request.total_items['option_#option_id#_#val(guest)#'] = {id = option_id, price=val(price), guest=val(guest)}>
															</cfif>
															selected
															
														</cfif>
														>
															#name#
															#dollarformat(price)#
														</option>
														
													</cfif>
												</cfoutput>
										</select>							
										<p>Make a selection above for <em>#group_name#</em></p>
									</div>
								<cfelse>
									<cfset cnt += 1>
								</cfif>
							</div>
						</div>
					</div>
					<cfif cnt neq getChosenSubData.recordcount>
					<!---   
						<div class="form-group row">
							<div class="hide-sm col-sm-10 col-sm-push-1"><hr></div>
						</div>--->
					<cfelse>

					</cfif>
				</div>
				
				<cfelse>
					<cfoutput>
						<cfset cnt += 1>
					</cfoutput>
				</cfif>	
			</cfoutput>
		</div>
		
		
	<cfelse>
		<cfoutput>
			<cfset cnt += 1>
		</cfoutput>
	</cfif>
		<cfif cnt neq getChosenSubData.recordcount and eventWasVisible>
			<cfset eventWasVisible = false>
			<div class="form-group row hideiflast">
				<div class="hide-sm col-sm-10 col-sm-push-1"><hr></div>
			</div>
		</cfif>
</cfoutput>
<cfif used_activities eq 0>
	<div class="col-md-12">
	
		<h4>No Activities Available</h4>
		
	</div>
</cfif>
					</fieldset>