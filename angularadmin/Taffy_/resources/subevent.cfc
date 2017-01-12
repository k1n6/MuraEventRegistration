<cfcomponent extends="taffy.core.resource" taffy_uri="/subevent/{eventid}/subeventid/{subeventid}">
	<cfscript>
	include "dataobject.cfm";
	</cfscript>
   <cfscript>
    function get(eventid, subeventid){
		return representationOf(  queryToArray( getSubEvent(arguments.eventid, arguments.subeventid) ) ).withStatus(200);
    }

	function put(eventid, subeventid, event_data){
		var input_data = event_data;
		input_data.subeventid = arguments.subeventid;
		input_data.subevent_event = arguments.eventid;
		p = saveSubEvent(arguments.eventid, arguments.subeventid, arguments.event_data);
		x = getSubEvent(p);
		return representationOf(x).withStatus(200);
	}
	</cfscript>
	<cffunction name="delete">
		<cfargument name="eventid">
		<cfargument name="subeventid">
		
		<cfquery name="deleteit" datasource="#request.dsn#" result="r">
			delete from p_eventregistration_subevent
			where subeventid = <cfqueryparam value="#arguments.subeventid#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfreturn representationof(r)>
	</cffunction>
	
	<cffunction name='saveSubEvent'>
		<cfargument name="eventid">
		<cfargument name="subeventid">
		<cfargument name="data_struct">
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = 'p_eventregistration_subevent'
			order by sort_order asc
		</cfquery>
		<cfif arguments.subeventid eq '-1'>
			<cfquery name="u" datasource="#request.dsn#">
				insert into  p_eventregistration_subevent
				(
					subevent_event, 
				<cfloop query="getMetaData">
					#column_name# <cfif currentrow neq getMetaData.recordcount>,</cfif>
				</cfloop>
				)
				values
				(
					<cfqueryparam value="#val(arguments.eventid)#" cfsqltype="CF_SQL_INTEGER">,
				<cfloop query="getMetaData">

						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								<cfif val(data_struct[column_name]) eq 1 or data_struct[column_name] eq "true">1<cfelse>0</cfif>
							</cfcase>
							
							<cfcase value="date,datetime">
								 <cfqueryparam value="#ISOToDateTime(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>
							
							<cfcase value="time">
								<cfqueryparam value="#timeformat(data_struct[column_name], 'short')#" cfsqltype="CF_SQL_TIME">
							</cfcase>

							<cfcase value="decimal,int,float,money">
							 <cfqueryparam value="#val(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>
								
							<cfdefaultcase>
								 <cfqueryparam value="#data_struct[column_name]#" cfsqltype="cf_sql_varchar">
							</cfdefaultcase>
						</cfswitch>
							<cfif currentrow neq getMetaData.recordcount>,</cfif>
					</cfloop>
					)

				select @@IDENTITY as new_value

				</cfquery>
				<cfreturn u.new_value>
		
		<cfelse>

			<cfquery name="u" datasource="#request.dsn#">
				Update p_eventregistration_subevent
				set
				<cfloop query="getMetaData">

						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								#column_name# =<cfif val(data_struct[column_name]) eq 1 or data_struct[column_name] eq "true">1<cfelse>0</cfif>
							</cfcase>
							
							<cfcase value="date,datetime">
								#column_name# = <cfqueryparam value="#ISOToDateTime(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>
							
							<cfcase value="time">
								#column_name# = <cfqueryparam value="#timeformat(data_struct[column_name], 'short')#" cfsqltype="CF_SQL_TIME">
							</cfcase>
							
							<cfcase value="decimal,int,float,money">
								#column_name# = 	 <cfqueryparam value="#val(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>
							
							<cfdefaultcase>
								#column_name#  = <cfqueryparam value="#data_struct[column_name]#" cfsqltype="cf_sql_varchar">
							</cfdefaultcase>
						</cfswitch>
							<cfif currentrow neq getMetaData.recordcount>,</cfif>
					</cfloop>


				where subeventid = #val(arguments.subeventid)#

				</cfquery>
				<cfreturn arguments.eventid>
		</cfif>
			
	</cffunction>
	
	<cffunction name='getSubEvent'>
		<cfargument name='eventid'>
		<cfargument name="subeventid">
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = 'p_eventregistration_subevent'
			order by sort_order asc
		</cfquery>
			<cfquery name="qgetEvent" datasource="#request.dsn#">
				<cfif val(arguments.subeventid) eq -1>
					<!---
						In this case we just selecting blank / default values for the form
					--->
					select -1 as subeventid,
					-1 as subevent_event
					<cfloop query="getMetaData">
						,
						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								 'false' as #column_name#
							</cfcase>
							
							<cfcase value="date">
								convert(varchar, getDate(), 101) as #column_name#
							</cfcase>
							<cfcase value="time">
								convert(varchar, getdate(), 101) + ' ' + convert(varchar, getDate(), 108) as #column_name#
							</cfcase>
							<cfcase value="datetime">
								convert(varchar, getDate(), 101) + ' ' + convert(varchar, getDate(), 108) as #column_name#
							</cfcase>
							<cfdefaultcase>
								'' as #column_name#
							</cfdefaultcase>
						</cfswitch>
					</cfloop>
					
					
					
				<cfelse>

					select subeventid,
					subevent_event
					<cfloop query="getMetaData">
						,
						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								case when #column_name# = 1 then 'true' else 'false' end as #column_name#
							</cfcase>
							
							<cfcase value="date">
								convert(varchar, #column_name#, 101) as #column_name#
							</cfcase>
							<cfcase value="time">
								convert(varchar, getdate(), 101) + ' ' + convert(varchar, #column_name#, 108) as #column_name#
							</cfcase>
							<cfcase value="datetime">
								convert(varchar, #column_name#, 101) + ' ' + convert(varchar, #column_name#, 108) as #column_name#
							</cfcase>
							<cfdefaultcase>
								#column_name#
							</cfdefaultcase>
						</cfswitch>
					</cfloop>
					from p_eventregistration_subevent
					where 1 = 1 
					<cfif val(arguments.eventid) neq 0>
						 and subevent_event = #val(arguments.eventid)#
					</cfif>
					<cfif val(arguments.subeventid) neq 0>
						 and subeventid = #val(arguments.subeventid)#
					</cfif>
					
				</cfif>
			</cfquery>
			<cfreturn qgetEvent>
		
		</cffunction>
		
		<cffunction
    name="ISOToDateTime"
    access="public"
    returntype="string"
    output="false"
    hint="Converts an ISO 8601 date/time stamp with optional dashes to a ColdFusion date/time stamp.">

    <!--- Define arguments. --->
    <cfargument
        name="Date"
        type="string"
        required="true"
        hint="ISO 8601 date/time stamp."
        />

    <!---
        When returning the converted date/time stamp,
        allow for optional dashes.
    --->
    <cfreturn ARGUMENTS.Date.ReplaceFirst(
        "^.*?(\d{4})-?(\d{2})-?(\d{2})T([\d:]+).*$",
        "$1-$2-$3 $4"
        ) />
</cffunction>
</cfcomponent>