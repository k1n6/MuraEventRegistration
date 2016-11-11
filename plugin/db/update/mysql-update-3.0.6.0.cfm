<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'created'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `created` datetime NOT NULL AFTER School_District
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameTeachingGrade" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'TeachingGrade'
</cfquery>
<cfif CheckColumnNameTeachingGrade.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `TeachingGrade` int(11) DEFAULT NULL AFTER lastUpdated
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameTeachingSubject" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'TeachingSubject'
</cfquery>
<cfif CheckColumnNameTeachingGrade.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `TeachingSubject` int(11) DEFAULT NULL AFTER TeachingGrade
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameReceiveMarketingFlyers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'ReceiveMarketingFlyers'
</cfquery>
<cfif CheckColumnNameReceiveMarketingFlyers.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `ReceiveMarketingFlyers` bit(1) NOT NULL DEFAULT b'0'' AFTER TeachingSubject
	</cfquery>
</cfif>

<cfquery name="ShowGradeLevelsTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_GradeLevels'
</cfquery>
<cfif ShowGradeLevelsTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_GradeLevels` (
			`TContent_ID` int(11) NOT NULL, `Site_ID` tinytext NOT NULL, `GradeLevel` tinytext NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>

<cfquery name="ShowGradeSubjectsTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_GradeSubjects'
</cfquery>
<cfif ShowGradeSubjectsTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_GradeSubjects` (
			`TContent_ID` int(11) NOT NULL, `Site_ID` tinytext NOT NULL, `GradeLevel` int(11) NOT NULL, `GradeSubject` tinytext NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameEventHasDailySessions" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'EventHasDailySessions'
</cfquery>
<cfif CheckColumnNameEventHasDailySessions.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `EventHasDailySessions` bit(1) NOT NULL DEFAULT b'0' AFTER PostedTo_Twitter
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession1BeginTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session1BeginTime'
</cfquery>
<cfif CheckColumnNameSession1BeginTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session1BeginTime` time DEFAULT NULL AFTER EventHasDailySessions
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession1EndTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session1EndTime'
</cfquery>
<cfif CheckColumnNameSession1EndTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session1EndTime` time DEFAULT NULL AFTER Sesson1BeginTime
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession2BeginTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session2BeginTime'
</cfquery>
<cfif CheckColumnNameSession2BeginTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session2BeginTime` time DEFAULT NULL AFTER Sesson1EndTime
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession2EndTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session2EndTime'
</cfquery>
<cfif CheckColumnNameSession2EndTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session2EndTime` time DEFAULT NULL AFTER Sesson2BeginTime
	</cfquery>
</cfif>

