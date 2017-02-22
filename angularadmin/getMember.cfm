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
<cfquery name="getMember" datasource="#$.siteConfig('fcadsn')#">
	select top 1 membernumber, password
	from members
	where 
									expiration_date > getdate()
								and status <> 'deceased'
								and status <> 'expelled'
						and isnull(state, '') <> ''
	order by newid()
</cfquery>

<cfoutput>
	<span id="membernumber">#getMember.membernumber#</span>
	<span id="password">#getMember.password#</span>
</cfoutput>