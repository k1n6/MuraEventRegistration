<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<script type="text/javascript" src="/plugins/EventRegistration/library/tinymce/tinymce.min.js" />
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<script type="text/javascript">
	tinymce.init({
		selector: "textarea"
	});
</script>
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>

<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>

	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Sending an Email to Workshop/Event Attended Participants:<br>#DateFormat(Session.UserSuppliedInfo.EventDate, 'mm/dd/yyyy')# - #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete this form to send a message to those who attended  this event.<br><Strong>Number of Attended Participants: #Session.EventNumberAttended#</Strong></div>
			<hr>
			<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.emailattended&compactDisplay=false&EventID=#URL.EventID#&EventStatus=EmailParticipants" method="Post" id="EmailEventParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Email Event Participants" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="CancelEvent">
				<uForm:fieldset legend="Message to Participants">
					<uform:field label="Email Body Message" name="EmailMsg" isDisabled="false" type="textarea" hint="The Email Message Body for Participants" />
					<uform:field label="Include File Links" name="IncludeFileLinks" type="select" hint="Include Links to Event Documents in Email Message?">
						<uform:option display="Yes" value="1" isSelected="true" />
						<uform:option display="No" value="0" />
					</uform:field>
				</uForm:fieldset>
				<uForm:fieldset legend="Participant Materials">
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameSix)>
						<input type="Hidden" Name="FirstDocumentToSend" Value="">
						<uform:field label="First Document" name="FirstDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameSix#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="First Document" name="FirstDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameSix#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameSeven)>
						<input type="Hidden" Name="SecondDocumentToSend" Value="">
						<uform:field label="Second Document, if needed" name="SecondDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameSeven#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Second Document, if needed" name="SecondDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameSeven#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameEight)>
						<input type="Hidden" Name="ThirdDocumentToSend" Value="">
						<uform:field label="Third Document, if needed" name="ThirdDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameEight#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Third Document, if needed" name="ThirdDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameEight#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameNine)>
						<input type="Hidden" Name="FourthDocumentToSend" Value="">
						<uform:field label="Fourth Document, if needed" name="FourthDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameNine#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Fourth Document, if needed" name="FourthDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameNine#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameTen)>
						<input type="Hidden" Name="FifthDocumentToSend" Value="">
						<uform:field label="Fifth Document, if needed" name="FifthDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameTen#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Fifth Document, if needed" name="FifthDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameTen#" />
					</cfif>
				</uForm:fieldset>
				<cfif Session.EventNumberAttended GT 0>
					<uForm:fieldset legend="Send Email?">
						<uform:field label="Send Email Message" name="SendEmail" isDisabled="false" type="select" hint="Are you ready to send this email to participants?">
							<uform:option display="Yes, Send It" value="True" isSelected="true" />
							<uform:option display="No, Do not Send" value="False" />
						</uform:field>
					</uForm:fieldset>
				<cfelse>
					<input type="Hidden" Name="SendEMail" Value="False">
					<input type="Hidden" Name="EmailMsg" Value=" ">
				</cfif>
			</uForm:form>
		</div>
	</div>
</cfoutput>