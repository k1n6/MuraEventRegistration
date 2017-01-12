<cfcomponent implements="taffy.bonus.ILogAdapter">

	<cffunction name="init">
		<cfargument name="config" />
		<cfargument name="tracker" hint="unused" default="" />
		<cfreturn this />
	</cffunction>

	<cffunction name="saveLog">
		<cfargument name="exception" />
		<cfcontent type="text/html" />
		<cfheader statuscode="500" statustext="Unhandled API Error" />
		<cfdump var="#arguments#" />
		<cfif isDefined('request.debugData')>
			<cfdump var="#request.debugData#" label="debug data" />
		</cfif>
		<cfsavecontent variable="t">

			<cfdump var="#arguments#" label="error">
			
			<cfdump var="#cgi#" label="cgi">
			<cfset data = GetHttpRequestData()>
			<cfdump var="#data#" label="HTTP Request Data">

		</cfsavecontent>

		<cffile action="write" output="#t#" file="#expandpath('/logs/ERROR-HANDLER-#dateformat(now(), 'mm_dd_yyyy')# #getTickCount()#.html')#">


		<cfabort />
	</cffunction>

</cfcomponent>
