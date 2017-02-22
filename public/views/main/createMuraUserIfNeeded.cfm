<cfobject name="em" component="cfcs.event_members">
	
	
	<cfsavecontent variable="debug">
	<cfif isdefined("session.stmember.id") and session.stmember.id gt 0 and not Session.Mura.IsLoggedIn EQ True>
		<!---
			Here they are logged into as a ferrari member, so lets create the mura session
		--->
		Attempting mura login.<br>

		<!---
			First we just attempt to log them in
		--->
		<cfset userLogin = em.logUserInToMura(0, session.stmember.membernumber, session.stmember.id)>
		Initial login results: <cfoutput>#userLogin#</cfoutput><br>

		<!---   
			If the user doesn't exist (the above failed) then we'll create a mura user account for them
		--->
		<cfif userLogin contains "no matrix entry">
			Attempting to create user....
			<cfset res = em.createUserFromMember(session.stmember.membernumber, session.stmember.id)>
			User Creation results: <cfdump var="#res#"><br>
 
			<cfset userLogin = em.logUserInToMura(0, session.stmember.membernumber, session.stmember.id)>
		</cfif>
		
		<!---   Now they should be logged in either to their new mura account or an existing mura account --->
		<cfoutput>userLogin results: #userLogin#</cfoutput><br>
		Mura login results: <cfoutput>#Session.Mura.IsLoggedIn#</cfoutput><br>


		Done.
		
	</cfif>
	
	<cfif Session.Mura.IsLoggedIn EQ True>
		<cfset currentuser = $.currentUser().getUserid()>
		
		<!---   
			here we are log into the ferrari session to make sure they are synch'd
		 ---> 
		 <cfif isdefined('session.stmember.id') and val(session.stmember.id) gt 0>
			 <cfset t = em.createFerrariSession(0, session.stmember.id, session.stmember.membernumber, currentuser)>
			 <cfif t eq "true">

			 <cfelse>
				Error creating ferrari session: <cfoutput> #t#</cfoutput>.<br><br>

				<cfabort>
			</cfif>
		 </cfif>
			
		
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
		<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
		<cfloop query="#Variables.UserMembershipQuery#">
			<cfif UserMembershipQuery.GroupName EQ "Event Facilitator"><cfset Session.Mura.EventCoordinatorRole = true></cfif>
			<cfif UserMembershipQuery.GroupName EQ "Event Presentator"><cfset Session.Mura.EventPresenterRole = true></cfif>
		</cfloop>
		<cfif Session.Mura.Username EQ "admin"><cfset Session.Mura.SuperAdminRole = true></cfif>
	
		<!---   
				This was capturing front-end requests when the user was logged in whereas now the process is to log in through mura and use the plugins drop down
				<cfif Session.Mura.EventCoordinatorRole EQ "True">
					<cfoutput>#Variables.this.redirect(action = "eventcoord:main.default", path = cgi.path_info)#</cfoutput>
				</cfif>
				<cfif Session.Mura.SuperAdminRole EQ "true">
					<cfoutput>#Variables.this.redirect(action = "siteadmin:main.default", path = cgi.path_info)#</cfoutput>
				</cfif>
			--->

	<!---   
		<cfif isDefined("Session.UserRegistrationInfo")>
			<cfif DateDiff("n", Session.UserRegistrationInfo.DateRegistered, Now()) LTE 5>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			</cfif>
		</cfif>
		--->
	<cfelse>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
	</cfif>
	</cfsavecontent>

	<!---   
		TODO: Validate the mura user login state agains the members_x_users table by checking the mura user id against the member id 
	--->
	<cfif isdefined("url.debug") and url.debug eq "true">
			<h2>debug output</h2><br>

			<cfoutput>debug output: '<br>

				#debug#<br>
			'</cfoutput>
	</cfif>