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


	

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfif isdefined("session.stmember.ID")>
			<cfset rc.member_data = fr.getMemberData(session.stmember.ID)>
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
	</cffunction>
	
	<cffunction name="thankyou" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		
	</cffunction>
	
	<cffunction name="stepthree" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		
	</cffunction>
	
	<cffunction name="stepfour" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfif isdefined("session.stmember.ID")>
			<cfset rc.member_data = fr.getMemberData(session.stmember.ID)>
		<cfelse>
			<cfset rc.member_data = fr.getMemberData(-1)>
		</cfif>
	</cffunction>
	
	<cffunction name="stepfive" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfobject name="fr" component="cfcs.ferrari_reg">
		<cfparam default="#fr.getAdminConfig()#" name="session.event_config">
		<cfset rc.event_data = fr.getFullEventData(rc.eventid)>
		<cfif isdefined("session.stmember.ID")>
			<cfset rc.member_data = fr.getMemberData(session.stmember.ID)>
		<cfelse>
			<cfset rc.member_data = fr.getMemberData(-1)>
		</cfif>
		
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