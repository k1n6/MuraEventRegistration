<cfsavecontent variable="pluginContent">

    
    <script src="node_modules/api-check/dist/api-check.js"></script>
    
    
		
    <script src="//cdnjs.cloudflare.com/ajax/libs/fastclick/0.6.7/fastclick.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/FileSaver.js/1.0.0/FileSaver.min.js"></script>
    <script src="//cdnjs.cloudflare.com/ajax/libs/jszip/2.4.0/jszip.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular.min.js"></script>
   
	<script src="js/ng-http-loader.js"></script>
    <link rel="stylesheet" type="text/css" href="node_modules/angular-ui-grid/ui-grid.min.css">
	<script src="node_modules/angular-ui-grid/ui-grid.min.js"></script>
   
    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular-animate.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular-touch.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular-sanitize.js"></script>
	<script src="node_modules/angular-filter/dist/angular-filter.min.js"></script>
	<script src="node_modules/angular-ui-router/release/angular-ui-router.min.js"></script>
    <script src="node_modules/angular-ui-bootstrap-datetimepicker/datetimepicker.js"></script>
	<script src="node_modules/angular-scroll/angular-scroll.min.js"></script>
	<script src="js/checklist-model.js"></script>
    <script src="ui-bootstrap-tpls-2.4.0.min.js"></script>
   
    <script src="node_modules/angular-formly/dist/formly.js"></script>
    <script src="node_modules/angular-formly-templates-bootstrap/dist/angular-formly-templates-bootstrap.js"></script>
 	<script src="node_modules/angular-tablesort/js/angular-tablesort.js"></script>

   	<!-- angular material -->
   	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.8/angular-animate.min.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-route.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular-aria.min.js"></script>
	<script src="//ajax.googleapis.com/ajax/libs/angularjs/1.5.5/angular-messages.min.js"></script>
    <script src="//ajax.googleapis.com/ajax/libs/angular_material/1.0.7/angular-material.min.js"></script>
	<link rel="stylesheet" href="//ajax.googleapis.com/ajax/libs/angular_material/1.0.7/angular-material.min.css">

    <script src="assets/eventsAdminApp.js"></script>
    <script src="js/events/event-controllers.js"></script>
    <script src="js/events/event-services.js"></script>
    <script src="js/reports/reports-controllers.js"></script> 
    <script src="js/reports/reports-services.js"></script>
    <script src="js/directives.js"></script>
    <script src="js/UI.js"></script>
    <script src="js/table2csv.js"></script>
	 
   
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" />
    
    <link href="node_modules/angular-ui-bootstrap-datetimepicker/datetimepicker.css" rel="stylesheet" />
    <link rel="stylesheet" href="assets/rainbow.css"/>
    <link rel="stylesheet" href="assets/demo.css"/>
    <link rel="stylesheet" href="assets/style.css"/>
    <!--
    <link rel="stylesheet" href="js/tablesorter/tablesorter.css"/>
	<script src="js/tablesorter/tablesorter.js"></script>
 	-->

 	<link rel="stylesheet" type="text/css" href="//cdn.datatables.net/1.10.13/css/jquery.dataTables.css">
	<script type="text/javascript" charset="utf8" src="//cdn.datatables.net/1.10.13/js/jquery.dataTables.js"></script>

<div ng-controller="MainsCtrl" ng-init="getStoredActive();" id="top" ng-app="eventsadmin">

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
		<script>
			window.siteid = "<cfoutput>#$.siteConfig('siteid')#</cfoutput>";
			window.buildCSV = function(table){
				var csv = $(table).table2CSV({
					delivery: 'data'
				});
				console.log("csv: " + csv);
				$('#csvdata').val(csv);
				$('#csvform').submit();
			}
			$(function(){
				$('.block-constrain').addClass('plugin-container').removeClass('block-constrain');
			})
		</script>
<div role="main">
    <header class="bs-header text-center" id="overview">
        <div class="container">
            <h1>
               Ferrari Regional / Chapter Events Administration
            </h1>
            <div ng-http-loader  ttl="0.5" template="templates/loader.html">
        </div>
	
    </header>
    <div class="container-fluid main-container">

	  	
	  	
	  </div>
        <div class="row">
            <div class="col-md-12">
			   <style type="text/css">
					  form.tab-form-demo .tab-pane {
						margin: 20px 20px;
					  }
				</style>
				<uib-tabset active="activeMain">

		 			<uib-tab 
						ui-sref="eventlist" 
						index="0"
						ng-click="setActiveTab(0);"
						select = ""
						
						heading="Event List"></uib-tab>
				<uib-tab 
						 ui-sref="singleConfig({siteid : siteid })"
						ng-click="setActiveTab(1);"
						select = ""
						index="1"
					 	heading="Administration"></uib-tab>
					 	
						
				</ul>
			</div>
		</div>
		<div class="row">
            <div class="col-md-12">		
            	<div id="tabs-views-main" class="tabs-content-well" data-ui-view></div>
            	<!--
            	 <div class="tabcontent well-lg">	
					<ui-view></ui-view>
				 </div> 
				-->
			</div>
		</div>
	</div>
    
		
                    
                    
                    
    <!-- Put custom templates here -->
    <script type="text/ng-template" id="datepicker.html">
      <p class="input-group">
        <input  type="text"
                id="{{::id}}"
                name="{{::id}}"
                ng-model="model[options.key]"
                class="form-control"
                ng-click="datepicker.open($event)"
                uib-datepicker-popup="{{to.datepickerOptions.format}}"
                is-open="datepicker.opened"
                datepicker-options="to.datepickerOptions" />
        <span class="input-group-btn">
            <button type="button" class="btn btn-default" ng-click="datepicker.open($event)" ng-disabled="to.disabled"><i class="glyphicon glyphicon-calendar"></i></button>
        </span>
      </p>
    </script>
    <script type="text/ng-template" id="textarea-tinymce.html">
	  <textarea ui-tinymce="options.data.tinymceOption"  ng-model="model[options.key]" class="form-control">
	  </textarea>
    </script>
    
	
	<script src="assets/uglifyjs.js"></script>
	<form id="csvform" method="post" action="buildcsv.cfm" enctype="multipart/form-data">
		<textarea style="display: none;"  name="csvdata" id="csvdata"></textarea>
	</form>
</div>
</cfsavecontent>
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
<cfoutput>

	#$.getBean('pluginManager').renderAdminTemplate(
		body = plugincontent
		, pageTitle = ''
		, jsLib = ''
		, jsLibLoaded = true
	)#
</cfoutput>


