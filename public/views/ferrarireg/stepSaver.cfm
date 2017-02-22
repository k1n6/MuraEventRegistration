<cfif isdefined("session.reg_completed") and session.reg_completed  and curstep neq 1>
	<cfset session.reg_completed = false>
	<cflocation url="/public-registration-page/">
</cfif>

<cfparam default="false" name="reviewmode">
<cfif isdefined('url.goingback') and url.goingback eq 'true' and arraylen(session.reg_options) gte curstep +1 and isstruct(session.reg_options[curstep + 1])>
	
	<cfset input_struct = session.reg_options[curstep + 1]>
	<cfloop collection="#input_struct#" item='i'>
		<cfset rc[i] = input_struct[i]>	
	</cfloop>

<!--- this means we are gong forward but have stored values for this page --->
<cfelseif arraylen(session.reg_options) gte curstep +1 and isstruct(session.reg_options[curstep + 1])>
	
	<!--- first we load the values from the submitted page, then load the stored input values for this current page --->
	<!--- load previous values --->
	<cfset input_struct = session.reg_options[curstep + 1]>
	
	<!--- now we'll over ride any of the stored values with those we got from the form --->
	<cfset save_struct = {}>
	<cfif isdefined('rc.eventid')>
		<cfset save_struct.eventid = rc.eventid>
	</cfif>
	<cfparam name="rc.fieldnames" default="">
	<cfloop list="#rc.fieldnames#" index='i'>
		<cfset save_struct[i] = rc[i]>
	</cfloop>
	<!--- now store the saved values --->
	<cfset req = getHTTPRequestData()>
	
	<cfif req.method eq "POST" and reviewmode neq "true">
		<cfset session.reg_options[curstep] = save_struct>
	</cfif>
<cfelse>
	<!--- else this is the first time the user has visited this page and we just load the variables into the request context --->
	<cfset req = getHTTPRequestData()>
	<cfif req.method eq "POST" and reviewmode neq "true">
		<cfset save_struct = {}>
		<cfparam name='rc.fieldnames' default="">
		<cfloop list="#rc.fieldnames#" index='i'>
			<cfset save_struct[i] = rc[i]>
		</cfloop>
		<cfset session.reg_options[curstep] = save_struct>
	</cfif>
</cfif>
