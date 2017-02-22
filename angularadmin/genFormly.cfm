<cftry><cfparam name="url.table" default="">
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
	$ = get$();
</cfscript>

<cfparam name="request.dsn" default="#$.siteConfig('datasource')#">
<cfif len(url.table) eq 0>


<cfquery name="getTables" datasource="#request.dsn#">
	select distinct table_name from INFORMATION_SCHEMA.columns
	where table_catalog = '#$.siteConfig('datasource')#'
	order by table_name asc
</cfquery>
<form method="get">
	<select name="table">
		<cfoutput query="getTables">
			<option value="#table_name#" <cfif url.table eq table_name> selected </cfif>> #table_name#</option>
		</cfoutput>
	</select>
	<input type="submit">
</form>

	
<cfelseif len(url.table) gt 0>
	<cfquery name="getColumns" datasource="#request.dsn#">
		select distinct i.column_name, meta_id,  data_type, character_maximum_length, form_meta.sort_order, form_group, required, friendly_label, place_holder, label, value, f.sort_order as dropdown_sort, dropdown_id
		 from INFORMATION_SCHEMA.columns i
		 inner join form_meta
		 on form_meta.table_name = i.table_name
		 and form_meta.column_name = i.column_name
		 left join form_meta_dropdown f
		 on form_meta.meta_id = f.form_meta_id
		 where table_catalog = '#$.siteConfig('datasource')#'
		 and i.table_name = '#url.table#'
		order by form_meta.sort_order, f.sort_order
	</cfquery>
	
	<cfset lastGroup =  "">
	<cfset count = 0>
	[
       <cfoutput query="getColumns" group="form_group">
        {
        "className": "section-label panel-default",
		   "template": "<div class='row  panel-heading'><h4 class='panel-title'>#form_group#</h4></div>"
      },
			{
				"className": "row group_row ",
				"fieldGroup": [
					<cfoutput group="meta_id">
						
						<cfif lastGroup eq form_group>,</cfif>
						{
							"key": "#column_name#",
							<cfif listfindnocase('text,ntext', data_type)
								or (listfindnocase('varchar,nvarchar', data_type) and character_maximum_length eq '-1') >
								"className" : "col-sm-12",
							<cfelse>
								"className" : "col-sm-6",
							</cfif>
							<cfif dropdown_id eq "">
								<cfswitch expression="#data_type#">
									<cfcase value="varchar,nvarchar">
										<cfif character_maximum_length eq '-1'>
											"type": "textarea",
										<cfelse>
											"type": "input",
											</cfif>
									</cfcase>
									<cfcase value="int,decimal,money,float">
										"type": "input",
									</cfcase>
									<cfcase value="date">
										"type": "datepicker",
									</cfcase>
									<cfcase value="datetime">
										"type": "datetimepicker",
									</cfcase>
									<cfcase value="time">
										"type": "timepicker",
									</cfcase>
									<cfcase value="smallint,tinyint">
										"type": "checkbox",
										
									</cfcase>
									<cfdefaultcase>
										"type" : "input",
									</cfdefaultcase>
								</cfswitch>
							<cfelse>
							
								"type": "select",
							</cfif>
							"templateOptions": {
								<cfif dropdown_id eq "">
									<cfset count += 1>
									<cfswitch expression="#data_type#">
										<cfcase value="varchar,nvarchar">
										
										</cfcase>


										<cfcase value="int,decimal,money,float">
											
										</cfcase>
										<cfcase value="smallint,tinyint">
											
										</cfcase>
										<cfcase value="datetime">
     										 "datepickerPopup": "dd-MMMM-yyyy",
										</cfcase>
										<cfcase value="date">
											
											"datepickerPopup" : "dd/mm/yyyy",
										</cfcase>
										<cfdefaultcase>
										
										</cfdefaultcase>
									</cfswitch>
								<cfelse>
									
									"options": [
										{ "name": "Make a Selection",
										"value" : ""}
										<cfoutput>
											<cfset count += 1>
											,{"name" : "#label#",
											"value" : 
												<cfif val(value) eq value>
													#value#
												<cfelse>
													"#replacenocase(value, '"', "'", 'all')#"
												</cfif>
											}
										</cfoutput>
									],
								
								
								</cfif>
								"label": "#friendly_label#",
								"placeholder": "#place_holder#",
								
							   "required": <cfif val(required) eq 1>true<cfelse>false</cfif>
							}
						}
						<cfset lastGroup = form_group>
					</cfoutput>		
				]
			}
		   <cfif count neq getColumns.recordcount>,</cfif>
		</cfoutput>
		]
	
</cfif>	




	<cfcatch type="any">
		<cfdump var="#cfcatch#">
		<cfabort>
	</cfcatch>
</cftry>