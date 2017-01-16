<cfsilent>
	<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

	<cfif Session.getActiveMembership.RecordCount EQ 1>
		<cfif Session.getActiveMembership.Active EQ 1>
			<cfset UserActiveMembership = "Yes">
		<cfelse>
			<cfset UserActiveMembership = "No">
		</cfif>
	<cfelse>
		<cfset UserActiveMembership = "No">
	</cfif>
</cfsilent>
<cfoutput>
	<cfform action="?EventRegistrationaction=public%3Aregisterevent.default" method="post" id="RegisterAccountForm" class="form-horizontal">
	<cfif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
		
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#Session.FormInput.EventID#">
				<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information to Register for Event</h3>
								</div>
								<div class="modal-body">
									<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
								</div>
								<div class="modal-footer">
									<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
								</div>
							</div>
						</div>
					</div>
					<script type='text/javascript'>
						(function() {
							'use strict';
							function remoteModal(idModal){
								var vm = this;
								vm.modal = $(idModal);

								if( vm.modal.length == 0 ) { return false; } else { openModal(); }

								if( window.location.hash == idModal ){ openModal(); }

								var services = { open: openModal, close: closeModal };
								return services;
								///////////////

								// method to open modal
								function openModal(){
									vm.modal.modal('show');
								}

								// method to close modal
								function closeModal(){
									vm.modal.modal('hide');
								}
							}
							Window.prototype.remoteModal = remoteModal;
						})();

						$(function(){
							window.remoteModal('##modelWindowDialog');
						});
					</script>
					</cfif>
				</cfif>
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="UserAlreadyRegistered">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Account Already Registered for Event</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-danger">You are already registered for this event. If you would like to register additional individuals, simply select the option to Register Additional Indivduals. If you would like to cancel your registration you can do that from the User Menu and select Manage Registrations.</div>
										</div>
										<div class="modal-footer">
											<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
										</div>
									</div>
								</div>
							</div>
							<script type='text/javascript'>
								(function() {
									'use strict';
									function remoteModal(idModal){
										var vm = this;
										vm.modal = $(idModal);

										if( vm.modal.length == 0 ) { return false; } else { openModal(); }

										if( window.location.hash == idModal ){ openModal(); }

										var services = { open: openModal, close: closeModal };
										return services;
										///////////////

										// method to open modal
										function openModal(){
											vm.modal.modal('show');
										}

										// method to close modal
										function closeModal(){
											vm.modal.modal('hide');
										}
									}
									Window.prototype.remoteModal = remoteModal;
								})();

								$(function(){
									window.remoteModal('##modelWindowDialog');
								});
							</script>
						</cfcase>
					</cfswitch>
				</cfif>
				
		</cfif>
		<div class="panel panel-default">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#Session.UserRegistrationInfo.EventID#">
				<div class="panel-body">
					<fieldset>
						<legend>Registering for Event: #Session.getSelectedEvent.ShortTitle#</legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to register for this event. All electronic communication from this system will be sent to the Participant's Email Address
					<cfif Session.getSelectedEvent.EventHasDailySessions EQ 1><p align="center"><hr>
					<strong>Session 1:</strong> #timeFormat(Session.getSelectedEvent.Session1BeginTime, "hh:mm tt")# till #timeFormat(Session.getSelectedEvent.Session1EndTime, "hh:mm tt")#<br>
					<strong>Session 2:</strong> #timeFormat(Session.getSelectedEvent.Session2BeginTime, "hh:mm tt")# till #timeFormat(Session.getSelectedEvent.Session2EndTime, "hh:mm tt")#<br>
					</p></cfif>
					</div>
					
					<div class="form-group">
						<label for="RegistrationName" class="control-label col-sm-3">Your Name:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.Mura.FName# #Session.Mura.LName#</p></div>
					</div>
					<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">Your Email:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.Mura.Email#</p></div>
					</div>
					<cfif Session.getSelectedEvent.PGPAvailable EQ 1>
						<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">PGP Points:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#NumberFormat(Session.getSelectedEvent.PGPPoints, "999.99")#</p></div>
						</div>
					</cfif>
					
					<div class="form-group">
						<label for="RegisterAdditionalIndividuals" class="control-label col-sm-3">Register Additional Individuals?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							
								<select name="RegisterAdditionalIndividuals" 
										class="form-control" Required="Yes" 
										>
											<option value="----">Do you want to Register Additional Individuals</option>
											<option value="0">No  additional people</option>
											<cfloop from=1 to=8 index='i'>
												<option value="#i#">#i# additional people</option>
											</cfloop>
								</select>
							
						</div>
					</div>
					
					<cfinput type="hidden" name="stayformeal" value='0'>
					
					
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Begin Registration"><br /><br />
				</div>
			</cfform>
		</div>
	

</cfoutput>