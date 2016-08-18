<cfsilent>
<!---

--->
</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Edit Account Holder Information</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="UserID" value="#URL.UserID#">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
					<cfcase value="PasswordChanged">
						<cfif URL.Successful EQ "true">
							<div class="alert alert-success">
								You have successfully changed this account holder's password in the database. If account is Activated, the user will be able to login with Username and the password which was just set
							</div>
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
				</cfswitch>
				</cfif>
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getSelectedUser.FName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.getSelectedUser.LName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getSelectedUser.Email#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getSelectedUser.Company#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.getSelectedUser.JobTitle#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.getSelectedUser.mobilePhone#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedUser.InActive#" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account Membership:&nbsp;</label>
						<div class="col-sm-8">
							<table class="table table-striped table-bordered">
								<thead class="thead-default">
									<tr>
										<th width="40%">Group Name</th>
										<th width="40%">Assign Group</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="Session.getEventGroups">
										<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select UserID, GroupID
											From tusersmemb
											Where UserID = <cfqueryparam value="#URL.UserID#" cfsqltype="cf_sql_varchar"> and
												GroupID = <cfqueryparam value="#Session.getEventGroups.UserID#" cfsqltype="cf_sql_varchar">
										</cfquery>
										<tr>
											<td>#Session.getEventGroups.GroupName#</td>
											<td><cfif getUserMembership.RecordCount>
													<input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#" checked>
												<cfelse>
													<input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#">
												</cfif>
											</td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Change Password">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Activate Account">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit Account Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Edit Account Holder Information</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="UserID" value="#URL.UserID#">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.FormInput.FName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.FormInput.LName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.FormInput.Email#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.FormInput.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.FormInput.Company#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.FormInput.JobTitle#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.FormInput.mobilePhone#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.InActive#" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account Membership:&nbsp;</label>
						<div class="col-sm-8">
							<table class="table table-striped table-bordered">
								<thead class="thead-default">
									<tr>
										<th width="40%">Group Name</th>
										<th width="40%">Assign Group</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="Session.getEventGroups">
										<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select UserID, GroupID
											From tusersmemb
											Where UserID = <cfqueryparam value="#URL.UserID#" cfsqltype="cf_sql_varchar"> and
												GroupID = <cfqueryparam value="#Session.FormInput.UserID#" cfsqltype="cf_sql_varchar">
										</cfquery>
										<tr>
											<td>#Session.getEventGroups.GroupName#</td>
											<td><cfif getUserMembership.RecordCount>
													<input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#" checked>
												<cfelse>
													<input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#">
												</cfif>
											</td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Change Password">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Activate Account">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit Account Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>