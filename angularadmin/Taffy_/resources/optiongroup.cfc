<cfcomponent extends="taffy.core.resource" taffy_uri="/optiongroup/{optiongroupid}/event/{eventid}/subevent/{subevent}">

   	
   	<cffunction name="get">
   		<cfargument name="optiongroupid">
   		<cfargument name="eventid">
   		<cfargument name="subevent">
   		
		
		<cfreturn representationOf(queryToArray(getOptionGroup(arguments.optiongroupid, arguments.eventid, arguments.subevent))).withStatus(200)>  	
   	
   	
	</cffunction>
	
	<cffunction name="delete">
   		<cfargument name="optiongroupid">
   		<cfargument name="eventid">
   		<cfargument name="subevent">
		
		<cfquery name="deleteit" datasource="#request.dsn#" result="r">
			delete from p_eventregistration_optiongroups
			where optiongroupid = <cfqueryparam value="#arguments.optiongroupid#" cfsqltype="CF_SQL_INTEGER">
		</cfquery>
		<cfreturn representationof(r)>
	</cffunction>
	
	<cffunction name="put">
		<cfargument name="optiongroupid"> 
		<cfargument name="eventid">
		<cfargument name="input_data">

		<!---
			This function can get called for several modes
			
			1) Creating a new optiongroup for a main event
			2) Creating a new optiongroup for a subevent
			3) Saving an existing option group for a main event
			4) Saving an existing option group for a sub event
			
			The main difference is the subevent column is populated for a sub event.
		--->
		<cfif not structkeyexists(arguments.input_data, 'subevent')>
			<cfset arguments.input_data.subevent = -1>
		</cfif>
		<cfset arguments.input_data.eventid = arguments.eventid>
		<cfset arguments.input_data.optiongroupid = arguments.optiongroupid>
		<cfset x = this.saveOptionGroup(input_data)>
		<cfreturn representationOf(x).withStatus(200)>
	</cffunction>
	
	<cffunction name="saveOptionGroup">
		<cfargument name="data_struct">
		
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = 'p_eventregistration_optiongroups'
			order by sort_order asc
		</cfquery>
		<cfif arguments.data_struct.optiongroupid eq '-1'>
			<cfquery name="u" datasource="#request.dsn#">
				insert into  p_eventregistration_optiongroups
				(
					mainevent,
					subevent,
				<cfloop query="getMetaData">
					#column_name# <cfif currentrow neq getMetaData.recordcount>,</cfif>
				</cfloop>
					
				)
				values
				(
					<cfqueryparam value="#arguments.data_struct.eventid#" cfsqltype="CF_SQL_INTEGER">,
					<cfqueryparam value="#arguments.data_struct.subevent#" cfsqltype="CF_SQL_INTEGER">,
				<cfloop query="getMetaData">

						<cfswitch expression="#data_type#">
							<cfcase value="date,datetime,time">
								 <cfqueryparam value="#ISOToDateTime(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>

							<cfcase value="decimal,int,float,money">
							 <cfqueryparam value="#val(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>
							<cfcase value="smallint,tinyint">
								<cfset use_val = data_struct[column_name]>
								<cfif use_val eq "true" or use_val eq 'on'>
									<cfset use_val = 1>
								<cfelse>
									<cfset use_val = 0>
								</cfif>
									
								<cfqueryparam value="#use_val#" cfsqltype="cf_sql_varchar">
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
				Update p_eventregistration_optiongroups
				set
				<cfloop query="getMetaData">

						<cfswitch expression="#data_type#">
							<cfcase value="date,datetime,time">
								#column_name# = <cfqueryparam value="#ISOToDateTime(data_struct[column_name])#" cfsqltype="cf_sql_varchar">
							</cfcase>
							<cfcase value="smallint,tinyint">
								<cfset use_val = data_struct[column_name]>
								<cfif use_val eq "true" or use_val eq 'on'>
									<cfset use_val = 1>
								<cfelse>
									<cfset use_val = 0>
								</cfif>
									
								#column_name# =  <cfqueryparam value="#use_val#" cfsqltype="cf_sql_varchar">
							</cfcase>
							<cfdefaultcase>
								#column_name#  = <cfqueryparam value="#data_struct[column_name]#" cfsqltype="cf_sql_varchar">
							</cfdefaultcase>
						</cfswitch>
							<cfif currentrow neq getMetaData.recordcount>,</cfif>
					</cfloop>


				where optiongroupid = #val(arguments.data_struct.optiongroupid)#

				</cfquery>
				<cfreturn arguments.data_struct.optiongroupid>
		</cfif>
			
	
			
	</cffunction>
	
	
	
	<cffunction name='getOptionGroup'>
		<cfargument name="optiongroupid">
   		<cfargument name="eventid">
   		<cfargument name="subevent">
		<cfquery name="getMetaData" datasource="#request.dsn#">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = 'p_eventregistration_optiongroups'
			order by sort_order asc
		</cfquery>
			<cfquery name="qgetEvent" datasource="#request.dsn#">
				<cfif val(arguments.eventid) eq -1 or val(arguments.optiongroupid) eq -1>
					<!---
						In this case we just selecting blank / default values for the form
					--->
					select -1 as optiongroupid,
					#val(arguments.subevent)# as subevent
					<cfloop query="getMetaData">
						,
						<cfswitch expression="#data_type#">
							<cfcase value="smallint,bit,tinyint">
								'false'  as #column_name#
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

					select optiongroupid, subevent
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
					from p_eventregistration_optiongroups
					where 1 = 1
					<cfif val(arguments.optiongroupid) neq 0>
						and optiongroupid = #val(arguments.optiongroupid)#
					</cfif>
					<cfif val(arguments.eventid) neq 0>
						and mainevent = #val(arguments.eventid)#
					</cfif>
					<cfif val(arguments.subevent) neq 0>
						and subevent = #val(arguments.subevent)#
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
