<cfmail To="#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# <#getRegisteredUserInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Registration Cancelled: #GetRegisteredEvent.ShortTitle#" server="127.0.0.1">
<cfmailpart type="text/plain">
#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,

Here is a copy of your registration cancellation for your records. 

Event Title: #GetRegisteredEvent.ShortTitle#
Event Date: #DateFormat(GetRegisteredEvent.EventDate, "full")#


This event has been cancelled from your account. If this was done in error you will need to reregister for this event if space is available.


Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is a copy of your registration cancellation for your records. </td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Title: #GetRegisteredEvent.ShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Date: #DateFormat(GetRegisteredEvent.EventDate, "full")#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">This event has been cancelled from your account. If this was done in error you will need to reregister for this event if space is available.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>