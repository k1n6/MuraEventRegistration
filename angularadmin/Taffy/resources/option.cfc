<cfcomponent extends="taffy.core.resource" taffy_uri="/option/{optionid}/eventid/{eventid}/subevent/{subevent}/optiongroup/{optiongroup}" >

	<cffunction name="get">
		<cfargument name="optionid">
		<cfargument name="eventid">
		<cfargument name="subevent">
		<cfargument name="optiongroup">
		
		<cfreturn representationOf(queryToArray(getEventOptions(arguments.optionid, arguments.eventid, arguments.subevent, arguments.optiongroup))).withStatus(200)>
	</cffunction>
	<cffunction name="delete">
		<cfargument name="optionid">
		<cfargument name="eventid">
		<cfargument name="subevent">
		<cfargument name="optiongroup">
		
		<cfquery name="deleteit" datasource="#request.dsn#" result="r">
			delete from p_eventregistration_options
			where option_id = <cfqueryparam value="#arguments.optionid#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfreturn representationof(r)>
	</cffunction>
	
	<cffunction name="getEventOptions">
		<cfargument name="optionid">
		<cfargument name="eventid">
		<cfargument name="subevent">
		<cfargument name="optiongroup">
	
		<cfset var table_list = 'p_eventregistration_events,p_eventregistration_optiongroups,p_eventregistration_options,p_eventregistration_optionattributes'>
		<cfset var table_list = '(' & listqualify(table_list, "'") & ')'>
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name in #table_list#
			order by sort_order asc
		</cfquery>
		
		<cfquery name="q_getOptions" datasource="#request.dsn#">
				--#getTickCount()#
				
				<cfif arguments.optionid lt 0>
					--this is place holder data for an empty form
					select
					#val(arguments.optionid)# as option_id,
					#val(arguments.eventid)# as eventid,
					#val(arguments.eventid)# as TContent_id,
					#val(arguments.subevent)# as subevent
					
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
					--this is non-placeholder data and must come from the database
					select
					TContent_id as eventid, option_id, subevent, TContent_id
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
					from
					<cfif arguments.subevent eq '-1'>
					 	--this is a main event options set
						 v_main_event_data
					<cfelse>
						-- this is sub event data
						v_events_options
					</cfif>
					
					where TContent_id = <cfqueryparam value="#arguments.eventid#" cfsqltype="CF_SQL_INTEGER">		
					<cfif val(arguments.optionid) gt 0>
						and option_id = <cfqueryparam value="#arguments.optionid#" cfsqltype="CF_SQL_INTEGER">
					</cfif>
					<cfif val(arguments.optiongroup) gt 0>
						and optiongroupid = <cfqueryparam value="#arguments.optiongroup#" cfsqltype="CF_SQL_INTEGER">
					</cfif>
					and subevent = <cfqueryparam value="#arguments.subevent#" cfsqltype="CF_SQL_INTEGER">
				</cfif>
			
		</cfquery>
		<cfreturn q_getOptions>
	</cffunction>
	
	<cffunction name="put">
		<cfargument name="optionid"> 
		<cfargument name="eventid">
		<cfargument name="subevent">
		<cfargument name="input_data">
		<cfset input_data.optionid = arguments.optionid>
		<cfset input_data.eventid = arguments.eventid>
		<cfset input_data.subevent = arguments.subevent>
		<cfset x = this.saveOption(input_data)>
		<cfreturn representationOf(x).withStatus(200)>
	</cffunction>
	
	
	<cffunction name="saveOption">
		<cfargument name="data_struct">
		
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = 'p_eventregistration_options'
			order by sort_order asc
		</cfquery>
		<cfif arguments.data_struct.optionid eq '-1'>
			<cfquery name="u" datasource="#request.dsn#">
				insert into  p_eventregistration_options
				(
					groupid, 
				<cfloop query="getMetaData">
					#column_name# <cfif currentrow neq getMetaData.recordcount>,</cfif>
				</cfloop>
				)
				values
				(
					<cfqueryparam value="#val(arguments.data_struct.optiongroupid)#" cfsqltype="CF_SQL_INTEGER">, 
				<cfloop query="getMetaData">

						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								<cfif val(data_struct[column_name]) eq 1 or data_struct[column_name] eq "true">1<cfelse>0</cfif>
							</cfcase>
							
							<cfcase value="date,datetime,time">
								 <cfqueryparam value="#ISOToDateTime(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
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
				Update p_eventregistration_options
				set
				<cfloop query="getMetaData">

						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								#column_name# =<cfif val(data_struct[column_name]) eq 1 or data_struct[column_name] eq "true">1<cfelse>0</cfif>
							</cfcase>
							
							<cfcase value="date,datetime,time">
								#column_name# = <cfqueryparam value="#ISOToDateTime(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>

							<cfdefaultcase>
								#column_name#  = <cfqueryparam value="#data_struct[column_name]#" cfsqltype="cf_sql_varchar">
							</cfdefaultcase>
						</cfswitch>
							<cfif currentrow neq getMetaData.recordcount>,</cfif>
					</cfloop>


				where option_id = #val(arguments.data_struct.optionid)#

				</cfquery>
				<cfreturn arguments.data_struct.optionid>
		</cfif>
			
	
			
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