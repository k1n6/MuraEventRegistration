<cfparam default="" name="session.lastRegistration">
<cfif session.lastREgistration eq "">
	<cflocation url="/event-registration/public-registration-page/" addtoken="false">
</cfif>
<cfoutput>#session.lastRegistration#</cfoutput>