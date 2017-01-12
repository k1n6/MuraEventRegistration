<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>Untitled Document</title>
</head>
<cfoutput>
<body>
	<h1>Code Creator</h1>
	<p>This script creates  the services code, controller code, Taffy resources, and html templates to edit a list of objects in angular / taffy / formly using the genFormly.cfm script to build the form.</p>
	<p>It is dependent on form meta data existing 
	<cfparam name="form.mode" default="">
	<cfparam name="form.taffyResourceName" default="">
	<cfparam name="form.objectName" default="">
	<cfparam name="form.tableName" default="">
	<cfparam name="form.friendlyName" default="">
	<cfparam name="form.objectNamefield" default="">
	<cfparam name="form.tableId" default="">
	
	<form method="post">
	
		Taffy Resource Name: <input type="text" name="taffyResourceName" value="#form.taffyResourceName#"><br>
		Object Name: <input type="text" name="objectName" value="#form.objectName#"><br>
		Table Name: <input type="text" name="tableName" value="#form.tableName#"><br>
		Friendly Name: <input type="text" name="friendlyName" value="#form.friendlyName#"><br>
		Object Name Field: <input type="text" name="objectNamefield" value="#form.objectNamefield#"><br>
		Table ID: <input type="text" name="tableId" value="#form.tableId#"><br>
		<input type="hidden" name="mode" value="gen">
		
		<input type="submit">
	</form>
	<cfif form.mode eq "gen">




		<br>
		<h4>ListHtmlTemplate</h4><br />
		<cfsavecontent variable="listHtmlTemplate">
<div ng-controller="#form.objectName#ListController" ng-show="eventid != -1">
	<h2>Event #form.friendlyName#</h2>
	<div ng-if="#form.objectName#s.length == 0"><h2>No #form.friendlyName#s Present</h2></div>
	
	<div class="input-group col-centered custom-list-item " ng-repeat="#form.objectName# in #form.objectName#s">
		<a  class="form-control"  ui-sref="eventDetails.single#form.objectName#({eventid: eventid, #form.tableId#: #form.objectName#.#form.tableId#, subevent : #form.objectName#.subevent})">
				{{#form.objectName#.#form.objectNamefield#}}

		</a>
		 <span class="input-group-btn">
			<button id="delete#form.objectName#button" ng-click="delete#form.objectName#(#form.objectName#.#form.tableId#, $event);" type="button" class="btn btn-danger"><span class="glyphicon glyphicon-remove"></span> Delete</button>
		</span>
	</div>

		

	<br>
	<button id="AddA#form.objectName#Button" class="btn btn-primary ng-scope" ui-sref="eventDetails.single#form.objectName#({eventid: eventid, #form.tableId#: -1, subevent : subevent})">Add A #form.objectName#</button>


</div>		

		</cfsavecontent>
		
		<textarea rows=30 cols=150>#HTMLEditFormat(listHTMLTemplate)#</textarea><br>
		<br>








		<br>
			<h4>SingleHtmlTemplate</h4><br />
		<cfsavecontent variable="singleHtmlTemplate">
<div ng-controller="single#form.objectName#Controller">
	
	<form  name="#form.objectName#Form" novalidate>
		<formly-form model="#form.objectName#s[0]" fields="#form.objectName#Fields" form="#form.objectName#Form">
			<button id="save#form.objectName#Button" type="button" ng-click="save#form.objectName#(#form.objectName#s[0]);" class="btn btn-primary" ng-disabled="#form.objectName#Form.$invalid">Save #form.friendlyName#</button>
		</formly-form>
	</form>
	<!--
		Here we need to list the existing option for this option group, and provide an add feature.	
	-->
		
	</div>
</div>
		</cfsavecontent>
	
		<textarea rows=30 cols=150>#HTMLEditFormat(singleHtmlTemplate)#</textarea><br>
		<br>

		
		
		
		
		
		
		
		
		
		<br>
			<h4>servicesCode</h4><br />
		<cfsavecontent variable="servicesCode">
			,
			get#form.objectName#s : function(eventid, #form.tableId#, subevent){
				var promise;
				 var url = '/Taffy/index.cfm/#form.objectName#/' + #form.tableId# + '/eventid/' + eventid + '/subevent/' + subevent;
					promise = $http.get(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;

			},
			save#form.objectName# : function(eventid, #form.tableId#, #form.objectName#, subevent){
				var promise;
				var url = '/Taffy/index.cfm/#form.objectName#/'+#form.tableId#+'/eventid/' + eventid + '/subevent/' + subevent;
				var wrapped_#form.objectName# = {};
				wrapped_#form.objectName#.input_data = #form.objectName#;
				wrapped_#form.objectName#.input_data.#form.tableId# = #form.tableId#;
				wrapped_#form.objectName#.input_data.eventid = eventid;
				wrapped_#form.objectName#.input_data.subevent = subevent;
				var input_data = JSON.stringify(wrapped_#form.objectName#);
				promise = $http.put(url, input_data).then(function(response){
					response = setBooleans(response);
					return response.data;
				});
				return promise;

			},
			delete#form.objectName# : function(#form.tableId#){
				var promise;
				var eventid = 0;
				var subevent = 0;
				 var url = '/Taffy/index.cfm/#form.objectName#/'+#form.tableId# + '/eventid/' + eventid + '/subevent/' + subevent;
					promise = $http.delete(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;	

			}



		</cfsavecontent>
	
		<textarea rows=30 cols=150>#HTMLEditFormat(servicesCode)#</textarea><br>
		<br>
		
		
		
		<br>
				<h4>taffyResource</h4><br />
		<cfsavecontent variable="taffyResource">
		
&lt;cfcomponent extends="taffy.core.resource" taffy_uri="/#form.objectName#/{#form.tableId#}/eventid/{eventid}/subevent/{subevent}" >

	&lt;cffunction name="get">
		&lt;cfargument name="#form.tableId#">
		&lt;cfargument name="eventid">
		&lt;cfargument name="subevent">
		
		
		&lt;cfreturn representationOf(queryToArray(get#form.objectName#s(arguments.#form.tableId#, arguments.eventid, arguments.subevent))).withStatus(200)>
	&lt;/cffunction>
	&lt;cffunction name="delete">
		&lt;cfargument name="#form.tableId#">
		&lt;cfargument name="eventid">
		&lt;cfargument name="subevent">
	
		
		&lt;cfquery name="deleteit" datasource="##request.dsn##" result="r">
			delete from #form.tableName#
			where #form.tableId# = &lt;cfqueryparam value="##arguments.#form.tableId###" cfsqltype="CF_SQL_INTEGER">
		&lt;/cfquery>
		&lt;cfreturn representationof(r)>
	&lt;/cffunction>
	
	&lt;cffunction name="get#form.objectName#s">
		&lt;cfargument name="#form.tableId#">
		&lt;cfargument name="eventid">
		&lt;cfargument name="subevent">
		
	
		&lt;cfset var table_list = '#form.tableName#'>
		&lt;cfset var table_list = '(' & listqualify(table_list, "'") & ')'>
		&lt;cfquery name="getMetaData" datasource="##request.dsn##">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name in ##table_list##
			order by sort_order asc
		&lt;/cfquery>
		
		&lt;cfquery name="q_get#form.objectName#s" datasource="##request.dsn##">
				--##getTickCount()##
				
				&lt;cfif arguments.#form.tableId# lt 0>
					--this is place holder data for an empty form
					select
					##val(arguments.#form.tableId#)## as #form.tableId#,
					##val(arguments.eventid)## as mainevent,
					##val(arguments.subevent)## as subevent
					
					&lt;cfloop query="getMetaData">
						,
						&lt;cfswitch expression="##data_type##">
							&lt;cfcase value="smallint,bit,tinyint">
								 'false' as ##column_name##
							&lt;/cfcase>
							&lt;cfcase value="date">
								convert(varchar, getDate(), 101) as ##column_name##
							&lt;/cfcase>
							&lt;cfcase value="time">
								convert(varchar, getdate(), 101) + ' ' + convert(varchar, getDate(), 108) as ##column_name##
							&lt;/cfcase>
							&lt;cfcase value="datetime">
								convert(varchar, getDate(), 101) + ' ' + convert(varchar, getDate(), 108) as ##column_name##
							&lt;/cfcase>
							&lt;cfdefaultcase>
								'' as ##column_name##
							&lt;/cfdefaultcase>
						&lt;/cfswitch>
					&lt;/cfloop>
				&lt;cfelse>
					--this is non-placeholder data and must come from the database
					select
					mainevent as eventid, 
					#form.tableId#, 
					subevent
					
					&lt;cfloop query="getMetaData">
						,
						&lt;cfswitch expression="##data_type##">
							&lt;cfcase value="smallint,bit,tinyint">
								case when ##column_name## = 1 then 'true' else 'false' end as ##column_name##
							&lt;/cfcase>
							
							&lt;cfcase value="date">
								convert(varchar, ##column_name##, 101) as ##column_name##
							&lt;/cfcase>
							&lt;cfcase value="time">
								convert(varchar, getdate(), 101) + ' ' + convert(varchar, ##column_name##, 108) as ##column_name##
							&lt;/cfcase>
							&lt;cfcase value="datetime">
								convert(varchar, ##column_name##, 101) + ' ' + convert(varchar, ##column_name##, 108) as ##column_name##
							&lt;/cfcase>
							&lt;cfdefaultcase>
								##column_name##
							&lt;/cfdefaultcase>
						&lt;/cfswitch>
					&lt;/cfloop>
					from
					#form.tableName#
					
					where
					 	1=1
					 	&lt;cfif val(arguments.#form.tableId#) gt 0>
							and #form.tableId# = &lt;cfqueryparam value="##arguments.#form.tableId###" cfsqltype="CF_SQL_INTEGER">		
						&lt;/cfif>
					and subevent = &lt;cfqueryparam value="##arguments.subevent##" cfsqltype="CF_SQL_INTEGER">

				
					and mainevent = &lt;cfqueryparam value="##arguments.eventid##" cfsqltype="CF_SQL_INTEGER">
				&lt;/cfif>
			
		&lt;/cfquery>
		&lt;cfreturn q_get#form.objectName#s>
	&lt;/cffunction>
	
	&lt;cffunction name="put">
		&lt;cfargument name="#form.tableId#">
		&lt;cfargument name="eventid">
		&lt;cfargument name="subevent">
		&lt;cfargument name="input_data">
		&lt;cfset input_data.#form.tableId# = arguments.#form.tableId#>
		&lt;cfset input_data.eventid = arguments.eventid>
		&lt;cfset input_data.subevent = arguments.subevent>
		&lt;cfset x = this.save#form.objectName#(input_data)>
		&lt;cfreturn representationOf(x).withStatus(200)>
	&lt;/cffunction>
	
	
	&lt;cffunction name="save#form.objectName#">
		&lt;cfargument name="data_struct">
		
		&lt;cfquery name="getMetaData" datasource="##request.dsn##">

			select distinct i.column_name, data_type, character_maximum_length, sort_order, form_group, required, friendly_label, place_holder
			 from INFORMATION_SCHEMA.columns i
			 inner join form_meta
			 on form_meta.table_name = i.table_name
			 and form_meta.column_name = i.column_name
			 where table_catalog = 'mura_events'
			 and i.table_name = '#form.tableName#'
			order by sort_order asc
		&lt;/cfquery>
		&lt;cfif arguments.data_struct.#form.tableId# eq '-1'>
			&lt;cfquery name="u" datasource="##request.dsn##">
				insert into  #form.tableName#
				(
					subevent,
					mainevent, 
				&lt;cfloop query="getMetaData">
					##column_name## &lt;cfif currentrow neq getMetaData.recordcount>,&lt;/cfif>
				&lt;/cfloop>
				)
				values
				(
					&lt;cfqueryparam value="##val(arguments.data_struct.subevent)##" cfsqltype="CF_SQL_INTEGER">, 
					&lt;cfqueryparam value="##val(arguments.data_struct.eventid)##" cfsqltype="CF_SQL_INTEGER">, 
				&lt;cfloop query="getMetaData">

						&lt;cfswitch expression="##data_type##">
							&lt;cfcase value="smallint,bit,tinyint">
								&lt;cfif val(data_struct[column_name]) eq 1 or data_struct[column_name] eq "true">1&lt;cfelse>0&lt;/cfif>
							&lt;/cfcase>
							&lt;cfcase value="date,datetime">
								 &lt;cfqueryparam value="##ISOToDateTime(data_struct[column_name])##" cfsqltype="cf_sql_varchar">
							&lt;/cfcase>
							
							&lt;cfcase value="time">
								 &lt;cfqueryparam value="##timeformat(data_struct[column_name], 'short')##" cfsqltype="CF_SQL_TIME">
							&lt;/cfcase>

							&lt;cfcase value="decimal,int,float,money">
							 &lt;cfqueryparam value="##val(data_struct[column_name])##" cfsqltype="cf_sql_varchar">
							&lt;/cfcase>

							&lt;cfdefaultcase>
								 &lt;cfqueryparam value="##data_struct[column_name]##" cfsqltype="cf_sql_varchar">
							&lt;/cfdefaultcase>
						&lt;/cfswitch>
							&lt;cfif currentrow neq getMetaData.recordcount>,&lt;/cfif>
					&lt;/cfloop>
					)

				select @@IDENTITY as new_value

				&lt;/cfquery>
				&lt;cfreturn u.new_value>
		
		&lt;cfelse>

			&lt;cfquery name="u" datasource="##request.dsn##">
				Update #form.tableName#
				set
				&lt;cfloop query="getMetaData">

						&lt;cfswitch expression="##data_type##">
							
							&lt;cfcase value="smallint,bit,tinyint">
								##column_name## =&lt;cfif val(data_struct[column_name]) eq 1 or data_struct[column_name] eq "true">1&lt;cfelse>0&lt;/cfif>
							&lt;/cfcase>
							&lt;cfcase value="date,datetime">
								##column_name## = &lt;cfqueryparam value="##ISOToDateTime(data_struct[column_name])##" cfsqltype="cf_sql_varchar">
							&lt;/cfcase>
							&lt;cfcase value="time">
								##column_name## = &lt;cfqueryparam value="##timeformat(data_struct[column_name], 'short')##" cfsqltype="CF_SQL_TIME">
							&lt;/cfcase>
							
							&lt;cfcase value="decimal,int,float,money">
								##column_name## = 	 &lt;cfqueryparam value="##val(data_struct[column_name])##" cfsqltype="cf_sql_varchar">
							&lt;/cfcase>
							&lt;cfdefaultcase>
								##column_name##  = &lt;cfqueryparam value="##data_struct[column_name]##" cfsqltype="cf_sql_varchar">
							&lt;/cfdefaultcase>
						&lt;/cfswitch>
							&lt;cfif currentrow neq getMetaData.recordcount>,&lt;/cfif>
					&lt;/cfloop>


				where #form.tableId# = ##val(arguments.data_struct.#form.tableId#)##

				&lt;/cfquery>
				&lt;cfreturn arguments.data_struct.#form.tableId#>
		&lt;/cfif>
			
	
			
	&lt;/cffunction>
	 &lt;cffunction
		name="ISOToDateTime"
		access="public"
		returntype="string"
		output="false"
		hint="Converts an ISO 8601 date/time stamp with optional dashes to a ColdFusion date/time stamp.">

		&lt;!--- Define arguments. --->
		&lt;cfargument
			name="Date"
			type="string"
			required="true"
			hint="ISO 8601 date/time stamp."
			/>

		&lt;!---
			When returning the converted date/time stamp,
			allow for optional dashes.
		--->
		&lt;cfreturn ARGUMENTS.Date.ReplaceFirst(
			"^.*?(\d{4})-?(\d{2})-?(\d{2})T([\d:]+).*$",
			"$1-$2-$3 $4"
			) />
	&lt;/cffunction>

&lt;/cfcomponent>		
		
		</cfsavecontent>

		<textarea rows=30 cols=150>#HTMLEditFormat(replacenocase(taffyResource, '&lt;', '<', 'all'))#</textarea><br>
		<br>
		







		<br>
			<h4>controllerCode</h4><br />
		<cfsavecontent variable="controllerCode">

.controller('#form.objectName#ListController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.#form.objectName#s = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	console.log($scope.subevent);
	
	$scope.delete#form.objectName# = function(#form.tableId#, $event){
		eventServices.delete#form.objectName#(#form.tableId#).then(function(res){
			$state.go('eventDetails.#form.objectName#list', {eventid: $stateParams.eventid, subevent: $scope.subevent}, {reload: true});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.get#form.objectName#s($stateParams.eventid,0, $scope.subevent);
	data.then(function(resp){
		$scope.#form.objectName#s = resp;
	});
}])

.controller('single#form.objectName#Controller', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.#form.objectName#s = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.#form.tableId# = $stateParams.#form.tableId#;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	
	//here we load our form variables
	$scope.#form.objectName#Fields = 	[];
	eventServices.getFormData('p_eventregistration_#form.objectName#s').then(function(d){
		$scope.#form.objectName#Fields = d;
	});
	
	
	$scope.update#form.objectName#Data= function(){

			data = eventServices.get#form.objectName#s($scope.eventid, $scope.#form.tableId#, $scope.subevent );
			data.then(function(resp){
				$scope.#form.objectName#s = resp;
			});
		}
	$scope.update#form.objectName#Data();
	
	$scope.save#form.objectName# = function(#form.objectName#){
		
		#form.objectName#.#form.tableId# = $scope.#form.tableId#;
		#form.objectName#.subevent = $scope.subevent;
		#form.objectName#.mainevent = $scope.eventid;
		
		eventServices.save#form.objectName#($scope.eventid, #form.objectName#.#form.tableId#, #form.objectName#, #form.objectName#.subevent ).then(function(d){

				$state.go('eventDetails.#form.objectName#list', 
					{eventid: $scope.eventid, 
					 subevent : $scope.subevent, 
					 }	,
						  {reload: true}
						);
		});
	};	
	
}])

		</cfsavecontent>
	
		<textarea rows=30 cols=150>#HTMLEditFormat(controllerCode)#</textarea><br>
		<br>
		
		
		
		<br>

		
			
	</cfif>	

</body>
</html>
	</cfoutput>