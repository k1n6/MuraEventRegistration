		
<cfcomponent extends="taffy.core.resource" taffy_uri="/coordinator/{coordinator_id}/eventid/{eventid}/subevent/{subevent}" >

	<cffunction name="get">
		<cfargument name="coordinator_id">
		<cfargument name="eventid">
		<cfargument name="subevent">
		
		
		<cfreturn representationOf(queryToArray(getcoordinators(arguments.coordinator_id, arguments.eventid, arguments.subevent))).withStatus(200)>
	</cffunction>
	<cffunction name="delete">
		<cfargument name="coordinator_id">
		<cfargument name="eventid">
		<cfargument name="subevent">
	
		
		<cfquery name="deleteit" datasource="#request.dsn#" result="r">
			delete from p_eventregistration_coordinator
			where coordinator_id = <cfqueryparam value="#arguments.coordinator_id#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfreturn representationof(r)>
	</cffunction>
	
	<cffunction name="getcoordinators">
		<cfargument name="coordinator_id">
		<cfargument name="eventid">
		<cfargument name="subevent">
		
	
		<cfset var table_list = 'p_eventregistration_coordinator'>
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
		
		<cfquery name="q_getcoordinators" datasource="#request.dsn#">
				--#getTickCount()#
				
				<cfif arguments.coordinator_id lt 0>
					--this is place holder data for an empty form
					select
					#val(arguments.coordinator_id)# as coordinator_id,
					#val(arguments.eventid)# as mainevent,
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
					mainevent as eventid, 
					coordinator_id, 
					subevent
					
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
					p_eventregistration_coordinator
					
					where
					 	1=1
					 	<cfif val(arguments.coordinator_id) gt 0>
							and coordinator_id = <cfqueryparam value="#arguments.coordinator_id#" cfsqltype="CF_SQL_INTEGER">		
						</cfif>
					and subevent = <cfqueryparam value="#arguments.subevent#" cfsqltype="CF_SQL_INTEGER">

				
					and mainevent = <cfqueryparam value="#arguments.eventid#" cfsqltype="CF_SQL_INTEGER">
				</cfif>
			
		</cfquery>
		<cfreturn q_getcoordinators>
	</cffunction>
	
	<cffunction name="put">
		<cfargument name="coordinator_id">
		<cfargument name="eventid">
		<cfargument name="subevent">
		<cfargument name="input_data">
		<cfset input_data.coordinator_id = arguments.coordinator_id>
		<cfset input_data.eventid = arguments.eventid>
		<cfset input_data.subevent = arguments.subevent>
		<cfset x = this.savecoordinator(input_data)>
		<cfreturn representationOf(x).withStatus(200)>
	</cffunction>
	
	
	<cffunction name="savecoordinator">
		<cfargument name="data_struct">
		
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = 'p_eventregistration_coordinator'
			order by sort_order asc
		</cfquery>
		<cfif arguments.data_struct.coordinator_id eq '-1'>
			<cfquery name="u" datasource="#request.dsn#">
				insert into  p_eventregistration_coordinator
				(
					subevent,
					mainevent, 
				<cfloop query="getMetaData">
					#column_name# <cfif currentrow neq getMetaData.recordcount>,</cfif>
				</cfloop>
				)
				values
				(
					<cfqueryparam value="#val(arguments.data_struct.subevent)#" cfsqltype="CF_SQL_INTEGER">, 
					<cfqueryparam value="#val(arguments.data_struct.eventid)#" cfsqltype="CF_SQL_INTEGER">, 
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
				Update p_eventregistration_coordinator
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


				where coordinator_id = #val(arguments.data_struct.coordinator_id)#

				</cfquery>
				<cfreturn arguments.data_struct.coordinator_id>
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
		
		