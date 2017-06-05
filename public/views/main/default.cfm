<cfparam default="0" name="regcount">
<cfset session.reg_completed = false>
		<!---
		This file is part of MuraFW1

		Copyright 2010-2015 Stephen J. Withington, Jr.
		Licensed under the Apache License, Version v2.0
		http://www.apache.org/licenses/LICENSE-2.0
	--->
	<cfinclude template="createMuraUserIfneeded.cfm">
	
<cfoutput>

	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="PasswordChanged">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Changed Successfully</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The password on the selected account has been changed sucessfully. You can now login with the username and new password to register for upcoming events/workshops.</p>
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
			<cfcase value="UserProfileUpdated">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>User Account Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The account changed which you have made where updated successfully. We appriciate you keeping your information up to date and current.</p>
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
			<cfcase value="PasswordNotChanged">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Not Changed</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The password on the selected account has not been changed due to an error.</p>
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
			<cfcase value="PasswordTimeExpired">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Reset Request Expired</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">Time has expired on the password reset request and no changes to the account has been done.</p>
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
			<cfcase value="WrongInformationRequest">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Invalid Information Passed</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">Something went wrong with the Link which was clicked on. Please visit the link again</p>
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
			<cfcase value="PasswordRequestSent">
				<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Password Request Sent</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-success">The special link to request password request has been sent to the email address we have on file for the account you entered.</p>
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
			<cfcase value="UserRegistration">
				<cfif URL.Successfull EQ "true">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Successfully Created</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-success">You have successfully registered an account on this system. Within a few minutes, you will receive an email with a link to activate your account. You will not be able to login to this system or register for events until your account has been activated.</p>
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
				<cfelse>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Error - Not Created</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</p>
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
			</cfcase>
			<cfcase value="UserActivated">
				<cfif URL.Successfull EQ "true">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Activated</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-success">You have successfully activated your account on this system. You may now login and register for any upcoming events or workshops.</p>
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
				<cfelse>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Error - Not Activated</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</p>
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
			</cfcase>
			<cfcase value="UserRegistered">
				<cfif isDefined("URL.SingleRegistration")>
					<cfif URL.SingleRegistration EQ "True">
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>Account Registered Successfully</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-success">You have successfully registered for '#Session.getSelectedEvent.ShortTitle#' (#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#) . You will receive a registration confirmation email shortly.</p>
									</div>
									<div class="modal-footer">
										<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
									</div>
								</div>
							</div>
						</div>
					</cfif>
				</cfif>
				<cfif isDefined("URL.MultipleRegistration")>
					<cfif URL.MultipleRegistration EQ "True">
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>Selected Individual(s) Registered Successfully</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-success">You have successfully registered the selected individual(s) for '#Session.getSelectedEvent.ShortTitle#' (#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#). Each individual will receive a registration confirmation email shortly.</p>
									</div>
									<div class="modal-footer">
										<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
									</div>
								</div>
							</div>
						</div>
					</cfif>
				</cfif>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
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
	<div class="panel panel-default no-border">
		<div class="panel-body no-border">
			<fieldset>
				<legend><h2>Calendar of Events</h2></legend>
			</fieldset>
			<cfif Session.getFeaturedEvents.RecordCount>
				<div class="alert alert-featured">
					<fieldset>
						<legend><h2>Featured Events</h2></legend>
					</fieldset>
                    <cfloop query="Session.getFeaturedEvents">
                    
                        <!--- Bld Date Txt --->
                        <cfset dtTxt = DateFormat(Session.getFeaturedEvents.EventDate,"mmmm dd, yyyy") >
                        
                         <div class="row events-row">
							 <div class="col-sm-2">
							 	<span class="hdrDt">#dtTxt#</span>
							 </div>
							
							<div class="col-sm-10">
								 <cfif Len(Session.getFeaturedEvents.longDescription) >
									<span ><a class="event-title" href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getFeaturedEvents.TContent_ID#">#Session.getFeaturedEvents.ShortTitle#</a></span> 
									#Session.getFeaturedEvents.longDescription# &nbsp;<span class="calTitle"><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getFeaturedEvents.TContent_ID#" class="btn btn-primary" >More Info</a></span> 
									<cfif  DateDiff("d", Now(), Session.getFeaturedEvents.Registration_Deadline) GTE 0>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:ferrarireg.default&EventID=#Session.getFeaturedEvents.TContent_ID#" class="btn btn-primary btn-red pull-right" title="Signup for Event" id="register_#regcount++#" alt="Register Event">Register</a>
									</cfif>
								<cfelse>
									<strong>#Session.getFeaturedEvents.ShortTitle#.</strong>
								</cfif>
							</div>
						 </div>
                    </cfloop>
				</div>
			</cfif>
			<cfif Session.getNonFeaturedEvents.RecordCount>
			
			<div class="well">
         
					<fieldset>
						<legend><h2>Upcoming Events</h2></legend>
					</fieldset>
                    <cfloop query="Session.getNonFeaturedEvents">
                    
                        <!--- Bld Date Txt --->
                        <cfset dtTxt = DateFormat(Session.getNonFeaturedEvents.EventDate,"mmmm dd, yyyy") >
                        
                         <div class="row events-row <cfif Session.getNonFeaturedEvents.recordcount eq currentrow>no-border</cfif> ">
							 <div class="col-sm-2">
							 	<span class="hdrDt">#dtTxt#</span>
							 </div>
							
							<div class="col-sm-10">
								 <cfif Len(Session.getNonFeaturedEvents.longDescription) >
									<span ><a class="event-title" href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#">#Session.getNonFeaturedEvents.ShortTitle#</a></span> 
									#Session.getNonFeaturedEvents.longDescription# &nbsp;<span class="calTitle"><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary" >More Info</a></span> 
									<cfif  DateDiff("d", Now(), Session.getNonFeaturedEvents.Registration_Deadline) GTE 0>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:ferrarireg.default&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-red pull-right" title="Signup for Event" id="register_#regcount++#" alt="Register Event">Register</a>
									</cfif>
								<cfelse>
									<strong>#Session.getNonFeaturedEvents.ShortTitle#.</strong>
								</cfif>
							</div>
						 </div>
                    </cfloop>
				</div>
              
			</cfif>
		</div>
		
	</div>

	<div id="eventPGPCertificate" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
					<h3>Event Attribute</h3>
				</div>
				<div class="modal-body">
					<p>Upon successfull completion of this event, Professional Growth Certificates will be sent to you via the registered email address this system has on file for you.</p>
				</div>
				<div class="modal-footer">
					<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
				</div>
			</div><!-- /.modal-content -->
		</div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
</cfoutput>