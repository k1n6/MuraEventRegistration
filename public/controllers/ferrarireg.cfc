/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">

		<cfscript>
		 private struct function get$() {
				if ( !StructKeyExists(arguments, '$') ) {
					var siteid = StructKeyExists(session, 'siteid') ? session.siteid : 'default';

					arguments.$ = StructKeyExists(request, 'murascope')
						? request.murascope
						: StructKeyExists(application, 'serviceFactory')
							? application.serviceFactory.getBean('$').init(siteid)
							: {};
				}

				return arguments.$;
			}
			$ = this.get$();
		</cfscript>


	

	<cffunction name="default" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfset rc.counts = fr.getEventcounts(rc.eventid)>

		<cfset session.event_config = fr.getAdminConfig()>
		<cfset rc.FERRARI_REG = fr>
		
		<cfif isdefined('url.registration_user') and isdefined('url.registration') and isdefined('url.eventid')
			and isdefined('url.eh') and url.eh eq hash(url.registration_user & url.registration & url.eventid & dateformat(now(), 'short'), 'md5')>
			<cfset session.admin_checkout = true>
			<cfobject name="em" component="cfcs.event_members">
			<cfset res = em.getRegistrationSessionFromMuraUser(url.registration_user)>
			<cfif not isstruct(res)>
				Error, unable to edit registration: #res#.<br />
				<cfthrow message="Error editing registration: #res#">
			</cfif>
			<cfset res.needed_session.admin_user = true>
			<cfset session.target_user_session = duplicate(res.needed_session)>
		

			<!---
				make a note that we are editing a registration
			--->
			<cfset session.target_user_session.editing_registration = url.registration>
						
			<!---   
				Now we need to load their data into the session for registration.
				Loadregistration also adds a variable that notes we are editing a registration.
			--->
			<cfset session.reg_options = FR.loadRegistration(url.registration)>
			<cfset session.target_user_session.reg_payments = FR.getPaymentTotal(url.registration)>
			<cfset session.target_user_session.mura_user = url.registration_user>

			<cfset url.goingback = true>
		
		<cfelse>	
			<cfset session.reg_payments = 0>
			<cfif isdefined("session.target_user_session.admin_user")>
				<cfset var was_admin_user = session.target_user_session.admin_user>
			<cfelse>
				<cfset var was_admin_user = false>
			</cfif>
			<cfif isdefined("session.target_user_session.reg_payments")>
				<cfset var reg_payments = session.target_user_session.reg_payments>
			<cfelse>
				<cfset var reg_payments = 0>
			</cfif>
			<cfif isdefined("session.target_user_session.admin_user")>
				<cfset var was_admin_user = session.target_user_session.admin_user>
			<cfelse>
				<cfset var was_admin_user = false>
			</cfif>
			
			<cfif isdefined("session.target_user_session.mura_user")>
				<cfset var mura_user = session.target_user_session.mura_user>
			<cfelse>
				<cfset var mura_user = false>
			</cfif>
			
			<cfif isdefined("session.target_user_session.editing_registration")>
				<cfset var editing_registration = session.target_user_session.editing_registration>
			<cfelse>
				<cfset var editing_registration = ''>
			</cfif>
			
			<cfset session.target_user_session = structnew()>
			
			<cfif structkeyexists(session, 'stmember')>
				<cfset session.target_user_session.stmember = duplicate(session.stmember)>
			</cfif>	
			<cfset session.target_user_session.admin_user = was_admin_user>
			<cfset session.target_user_session.editing_registration = editing_registration>
			<cfset session.target_user_session.reg_payments = reg_payments>
			<cfset session.target_user_session.mura_user = mura_user>
			
			
			
			<!---   
				This forces our admin control variables off if the user is logged into a mura session which is a public account, or if the mure memberships don't exist in the session.
			--->
			<cfif isdefined("session.mura.memberships")>
				<cfif session.mura.memberships contains "s2ispublic">
					<cfset session.target_user_session.admin_user = false>
					<cfset session.target_user_session.editing_registration = 0>
					<cfset  session.target_user_session.reg_payments = 0>
					<cfset session.target_user_session.mura_user = ''>
				<cfelse>
					<cfset session.target_user_session.admin_user = true>
				</cfif>
			<cfelse>
				<cfset session.target_user_session.admin_user = false>
				<cfset session.target_user_session.editing_registration = 0>
				<cfset  session.target_user_session.reg_payments = 0>
				<cfset session.target_user_session.mura_user = ''>
			</cfif>
			<cfset sessionTargets = "JoinCountry,Joinstate,renewal">
			<cfloop list="#sessionTargets#" index='i'>
				<cfif structkeyexists(session, i)>
					<cfset sesion.target_user_session[i] = session[i]>
				</cfif>
			</cfloop>
		</cfif>
		<cfif isdefined("session.target_user_session.stmember.ID")>
			<cfset rc.member_data = fr.getMemberData(session.target_user_session.stmember.ID)>
		<cfelse>
			<cfset rc.member_data = fr.getMemberData(-1)>
		</cfif>
		
		<cfset session.event_config = fr.getAdminConfig()>
		

	</cffunction>
	
	<cffunction name="steptwo" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		<cfset rc.FERRARI_REG = fr>
		<cfset rc.counts = fr.getEventcounts(rc.eventid)>
		<cfset session.event_config = fr.getAdminConfig()>
	</cffunction>
	
	<cffunction name="thankyou" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfset session.event_config = fr.getAdminConfig()>
		<cfset rc.FERRARI_REG = fr>
	</cffunction>
	
	<cffunction name="stepthree" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfset rc.FERRARI_REG = fr>
		<cfset rc.counts = fr.getEventcounts(rc.eventid)>
		<cfset session.event_config = fr.getAdminConfig()>
	</cffunction>
	
	<cffunction name="stepfour" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfset rc.counts = fr.getEventcounts(rc.eventid)>
		<cfif isdefined("session.target_user_session.stmember.ID")>
			<cfset rc.member_data = fr.getMemberData(session.target_user_session.stmember.ID)>
		<cfelse>
			<cfset rc.member_data = fr.getMemberData(-1)>
		</cfif>
		<cfset rc.FERRARI_REG = fr>
		<cfset session.event_config = fr.getAdminConfig()>
	</cffunction>
	
	<cffunction name="stepfive" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfset rc.counts = fr.getEventcounts(rc.eventid)>
		<cfif isdefined("session.target_user_session.stmember.ID")>
			<cfset rc.member_data = fr.getMemberData(session.target_user_session.stmember.ID)>
		<cfelse>
			<cfset rc.member_data = fr.getMemberData(-1)>
		</cfif>
		<cfset rc.FERRARI_REG = fr>
		<cfset session.event_config = fr.getAdminConfig()>
	</cffunction>
	

	<cffunction name="makeRandomString" ReturnType="String" output="False">
		<cfset var chars = "23456789ABCDEFGHJKMNPQRSTUVWXYZ">
		<cfset var length = RandRange(4,7)>
		<cfset var result = "">
		<cfset var i = "">
		<cfset var char = "">
		<cfscript>
			for (i = 1; i < length; i++) {
				char = mid(chars, randRange(1, len(chars)), 1);
				result &= char;
			}
		</cfscript>
		<cfreturn result>
	</cffunction>

</cfcomponent>