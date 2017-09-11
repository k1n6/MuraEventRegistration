<cfoutput>

	<div class="panel panel-default no-border">
	
		<div class="panel-body event-info-body no-border">
			<div class="well">
				<fieldset>
					<legend>
						<cfif DateDiff("d", Now(), Session.EventInfo.SelectedEvent.Registration_Deadline) GTE 0>
							<cfif Session.EventInfo.ParticipantRegistered EQ false>
								<a href="/event-registration/public-registration-page/?EventRegistrationaction=public:ferrarireg.default&EventID=#URL.EventID#"
									class="small-hide btn btn-primary btn-red top-event-button top-fivepx">Register</a>
							</cfif>
						</cfif>
						<h3 align="center">
							#Session.EventInfo.SelectedEvent.ShortTitle#
						</h3>
						<cfif DateDiff("d", Now(), Session.EventInfo.SelectedEvent.Registration_Deadline) GTE 0>
							<cfif Session.EventInfo.ParticipantRegistered EQ false>
								<a href="/event-registration/public-registration-page/?EventRegistrationaction=public:ferrarireg.default&EventID=#URL.EventID#" 
									class="small-only btn btn-primary btn-red top-event-button top-fivepx">Register</a>
							</cfif>
						</cfif>
					</legend>
				</fieldset>
				<cfif isDefined("URL.SentInquiry")>
					<div id="contactFormSuccessfull" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Contact Inquiry Sent Successfull</h3>
								</div>
								<div class="modal-body">
									<p>This website is in the process of sending your contact inquiry to a person that would be able to answer your inquiry. They will be contacting you at the Best Contact Method you chose when completing the form.</p>
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
							window.remoteModal('##contactFormSuccessfull');
						});
					</script>
				</cfif>

				<div class="row">
					<div class="col-sm-2">
						<span class="event-info-header larger">
							<cfif LEN(Session.EventInfo.SelectedEvent.EventDate1) or LEN(Session.EventInfo.SelectedEvent.EventDate2) or LEN(Session.EventInfo.SelectedEvent.EventDate3) or LEN(Session.EventInfo.SelectedEvent.EventDate4)>
								Event Dates:
							<cfelse>
								Event Date:
							</cfif>
						</span>
					</div>
					<div class="col-sm-4">
							#DateFormat(Session.EventInfo.SelectedEvent.EventDate, "m/dd/yyyy")# 
							<cfif LEN(Session.EventInfo.SelectedEvent.EventDate1)>
								, #DateFormat(Session.EventInfo.SelectedEvent.EventDate1, "m/dd/yyyy")#
							</cfif>
							<cfif LEN(Session.EventInfo.SelectedEvent.EventDate2)>
								, #DateFormat(Session.EventInfo.SelectedEvent.EventDate2, "m/dd/yyyy")#
							</cfif>
							<cfif LEN(Session.EventInfo.SelectedEvent.EventDate3)>
								, #DateFormat(Session.EventInfo.SelectedEvent.EventDate3, "m/dd/yyyy")#
							</cfif>
							<cfif LEN(Session.EventInfo.SelectedEvent.EventDate4)>
								, #DateFormat(Session.EventInfo.SelectedEvent.EventDate4, "m/dd/yyyy")#
							</cfif>
					</div>
					<div class="col-sm-6">
							All times reflect local time at Event Location
					</div>
				</div>

				<div class="row">
					<div class="col-sm-2"><span class="event-info-header larger">Main Event Time:</span></div>
					<div class="col-sm-4">#TimeFormat(Session.EventInfo.SelectedEvent.Event_StartTime, "h:mm tt")# to #TimeFormat(Session.EventInfo.SelectedEvent.Event_EndTime, "h:mm tt")#</div>
					<div class="col-sm-3"><span class="event-info-header larger">Registration Deadline:</span></div>
					<div class="col-sm-3">#DateFormat(Session.EventInfo.SelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</div>
				</div>

				<div class="row">
					<div class="col-sm-2"><span class="event-info-header larger">Description:</span></div>
					<div class="col-sm-10"><cfif Session.EventInfo.SelectedEvent.LongDescription neq "<p><br></p>">#Session.EventInfo.SelectedEvent.LongDescription#</cfif></div>
				</div>

				<cfset used_subEvents = {}>
				<cfif rc.event_data.sub_data.recordcount gt 0>
					<div class="row">
						<div class="col-sm-2"><span class="event-info-header larger">Event Activities:</span></div>
						<div class="col-sm-10">
							<cfloop query="rc.event_data.sub_data">
								<cfif not structkeyexists(used_subEvents, rc.event_data.sub_data.subeventid)>
									<cfset used_subEvents[rc.event_data.sub_data.subeventid] = 1>
									<h5 class="event-info-header ">#subevent_name# <cfif subevent_price gt 0> / #dollarformat(subevent_price)#</cfif> <cfif subevent_required eq 1>(required)</cfif>
										<cfif subevent_address neq "">(<a href="https://www.google.com/maps/place/#urlencodedformat(subevent_address)#" target="_blank">map</a>)</cfif>
									</h5>
									<div>
										#dateformat(subevent_start, 'long')# #timeformat(subevent_startTime, 'short')# 
										to 
										#timeformat(subevent_endtime, 'short')#
									</div><br>
									<cfif subevent_description neq "<p><br></p>">
										#subevent_description#
									</cfif>

								</cfif>	
							</cfloop>
						</div>
					</div>
				</cfif>
				<cfif len(Session.EventInfo.SelectedEvent.location)>

					<div class="row" id="eventLocationRow">

						<div class="col-sm-2">
							<span class="event-info-header larger">Event Location:</span>
						</div>
						<div class="col-sm-3">
							<address>
								<strong>#Session.EventInfo.SelectedEvent.location#</strong><br>
							</address>
							<cfif len(Session.EventInfo.EventFacility.PrimaryVoiceNumber) gt 0>
								<abbr title="Phone">P:</abbr> #Session.EventInfo.EventFacility.PrimaryVoiceNumber#
							</cfif>
						</div>

						<div class="col-sm-7">
							<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
							<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
							<div id="no-location-notice" style="display: none;">No location set</div>
							<script async defer
								src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBJQDNJTahP-R4mVSsySxNfrsNJTZI4-ok&callback=initMap">
								</script>

							<div id="map" style="width: 100%; height: 300px;"></div>
							<script>
								var facilitymarker;
								var geocoder;
								var map;
								var event_location = ["#rereplacenocase(Session.EventInfo.SelectedEvent.location, '[^0-9a-zA-Z \. \-]', ' ', 'all')#"];
								var pos;
								//var map = L.map('map');
								//map.setView(new L.LatLng(#Session.EventInfo.EventFacility.GeoCode_Latitude#, #Session.EventInfo.EventFacility.GeoCode_Longitude#), 12);
								//L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
								//var FacilityMarker = L.icon({
								//	iconUrl: '/global/small_logo.png'
								//});
								function getGeoCode()
								{
									var geocoder = new google.maps.Geocoder();
									geocoder.geocode({'address': event_location[0]}, function(results, status){
									 	if(status == google.maps.GeocoderStatus.OK)
										{
											console.log("GeoCode Succeeds");
											pos = results[0].geometry.location;
											var mapOptions = {
											  zoom: 12,
											  center: pos,
											  mapTypeId: google.maps.MapTypeId.ROADMAP
											}
											//var map = L.map('map');
											map = new google.maps.Map(document.getElementById("map"), mapOptions);
											//map.setView(new L.LatLng(#Session.EventInfo.EventFacility.GeoCode_Latitude#, #Session.EventInfo.EventFacility.GeoCode_Longitude#), 12);
											//L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
											//var FacilityMarker = L.icon({
											//	iconUrl: '/global/small_logo.png'
											//});
											//var marker = L.marker(pos, {icon: FacilityMarker}).addTo(map);
											var iconBase = '//#cgi.server_name#';
											var icons = {
											  eventlocation: {
												icon: iconBase + '/global/small_logo_pin_marker3.png'
											  }
											};
											
											
											var features = [
											  {
												position: pos,
												type: 'eventlocation'
											  }
											];
											 // Create markers.
											features.forEach(function(feature) {
											  var marker = new google.maps.Marker({
												position: feature.position,
												icon: icons[feature.type].icon,
												map: map
											  });
											
											});

										}
									else
									{
										$('##no-location-notice').css('display', 'block');
										$('##map').remove();
									}
								  });
								}
								function initMap(){
									getGeoCode();
								}
								
							</script>
						</div>
					</div>


				</cfif>

				<div class="row  no-border">
					<div class="col-sm-12">
						<span class="event-info-header larger">
							Pricing Information:
						</span>
					</div>
				</div>
				<cfif rc.event_data.price_data.recordcount gt 0>

					<cfloop query="rc.event_data.price_data">
						<div class="row no-border">
							<div class="col-sm-2"></div>
							<div class="col-sm-10">
								<span class="event-info-header">
									#price_name# / <cfif val(price) gt 0>#dollarformat(price)#<cfelse>No Cost</cfif>
								</span>
							</div>

						</div><div class="row <cfif currentrow lt rc.event_data.price_data.recordcount>no-border </cfif> ">
							<div class="col-sm-2"></div>
							<div class="col-sm-2">Registration Deadline:</div>
							<div class="col-sm-2">#DateFormat(price_cutoff_date, "mm/dd/yyyy")#</div>

							<div class="col-sm-6">
								Available To
								<strong>
									<cfif available_to eq 1>
										Members
									<cfelseif available_to eq 2>
										Public
									<cfelse>
										Everyone
									</cfif>
								</strong>
							</div>
						</div>
					</cfloop>

				</cfif>
				<div class="row no-border">
					<div class="col-sm-12">
						<span class="event-info-header larger">Contact Information</span>
					</div>
				</div>
				<cfloop query="rc.event_data.coord_data">		
					<div class="row">
						<div class="col-sm-2"></div>
						<div class="col-sm-3">
						<span class="event-info-header">
							<cfif primary_coordinator eq 1>
								#coordinator_name#<cfif coordinator_title neq "">, #coordinator_title#</cfif> (primary)
							<cfelse>
								#coordinator_name#<cfif coordinator_title neq "">, #coordinator_title#</cfif>								
							</cfif>
							</span>
						</div>
						<div class="col-sm-7">
							#coordinator_phone# or email:
							<a href='mailto:#coordinator_email#'>#coordinator_email#</a>
						</div>
					</div>
				</cfloop>
				<div class="row no-border no-bottom-margin seventeen-margin-top">
					<cfif Session.EventInfo.SelectedEvent.AcceptRegistrations EQ 1>
						<div class="col-sm-6 text-align-left">
							<!--- 
								<cfswitch expression="#ListLast(CGI.HTTP_REFERER, '=')#">
									<cfcase value="public:usermenu.eventhistory">
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.eventhistory" class="btn btn-primary">My Past Events</a>
									</cfcase>
									<cfcase value="public:usermenu.upcomingevents">
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.upcomingevents" class="btn btn-primary">My Upcoming Events</a>
									</cfcase>

									<cfdefaultcase>
							--->
									<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" class="btn btn-primary">Return to Event Listing</a>
								<!---
									</cfdefaultcase>
								</cfswitch>
							--->
						</div>
						<div class="col-sm-6 text-align-right">
							<cfif DateDiff("d", Now(), Session.EventInfo.SelectedEvent.Registration_Deadline) GTE 0>
									<cfif Session.EventInfo.ParticipantRegistered EQ false>
										<a href="/event-registration/public-registration-page/?EventRegistrationaction=public:ferrarireg.default&EventID=#URL.EventID#" class="btn btn-primary btn-red">Register</a>
									</cfif>
							</cfif>
						</div>

					<cfelse>
						<div class="col-sm-6 text-align-left">
							<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" class="btn btn-primary pull-left">Return to Event Listing</a><br /><br />
						</div>
					</cfif>
				</div>				
			</div>
		</div>			
	</div>
</cfoutput>