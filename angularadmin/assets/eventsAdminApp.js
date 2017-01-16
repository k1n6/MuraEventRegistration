var app = angular.module('eventsadmin', ['ui.bootstrap',  'formly', 'formlyBootstrap', 'ngTouch', 'ngAnimate', 'ngSanitize','ui.router', 'ui.bootstrap.datetimepicker'], function($httpProvider){

  delete $httpProvider.defaults.headers.common['X-Requested-With'];
})

app 
.config(function($stateProvider) {
  var eventListState = {
    name: 'eventlist',
    url: '/eventlist',
    templateUrl: 'templates/eventList.html'
  }
  var eventDetails = {
	 abstract: true,
    name: 'eventDetails',
    url: '/eventDetails/:eventid',
    templateUrl: 'templates/eventdetails.html'
  }
  
  var eventDetailseventinformation = {
    name: 'eventDetails.eventinformation',
    //url: '/eventDetails/:eventid/eventinformation',
	  url: '',
    templateUrl: 'templates/eventdetails.eventinformation.html'
  }
   
  var eventDetailseventoptiongroups = {
    name: 'eventDetails.eventoptiongroups',
    url: '/eventoptions/:subevent',
    templateUrl: 'templates/eventDetails.eventoptiongroups.html'
  }
  var singleeventDetailseventoptiongroup = {
    name: 'eventDetails.singleoptiongroup',
    url: '/optiongroup/:optiongroup/subevent/:subevent',
    templateUrl: 'templates/eventDetails.singleoptiongroup.html'
  }
  var singleOption = {
    name: 'eventDetails.singleoptiongroup.singleoption',
    url: '/optionid/:optionid',
    templateUrl: 'templates/single-option.html'
  }
	
  
  var singleOptionGroup = {
    name: 'eventDetails.eventoptiongroups.option',
    url: '/optiongroup/:optiongroup',
    templateUrl: 'templates/eventDetails.eventoptiongroups.option.html'
  }
	
 var eventDetailsactivities = {
    name: 'eventDetails.activities',
    url: '/activities',
    templateUrl: 'templates/eventdetails.activities.html'
  }
 var singleactivityDetailseventoptiongroup = {
    name: 'eventDetails.subeventsingleoptiongroup',
    url: '/optiongroup/:optiongroup/subevent/:subevent',
    templateUrl: 'templates/eventDetails.singleoptiongroup.html'
  }
 var eventActivityForm = {
	 name: 'eventDetails.subeventdetails',
	 url: '/subevent/:subevent',
	 templateUrl: 'templates/activity-form.html'
	 
 }
 var eventDetailsReporting = {
	 name: 'eventDetails.reporting',
	 url: '/reporting/:subevent',
	 templateUrl: 'templates/eventdetails.reporting.html'
	 
 }
 
  var administrationState = {
    name: 'administration',
    url: '/administration',
    templateUrl: 'templates/administration.html'
  }
  
  var singlePrice = {
    name: 'eventDetails.singleeventprice',
    url: '/priceid/:priceid',
    templateUrl: 'templates/eventdetails.singleeventprice.html'
  }
  var eventDetailsPriceList = {
    name: 'eventDetails.eventpricelist',
    url: '/pricelist/:subevent',
    templateUrl: 'templates/eventdetails.eventprices.html'
  }
  
  
   var singleCoordinator = {
    name: 'eventDetails.singlecoordinator',
    url: '/coordinator/:coordinator_id',
    templateUrl: 'templates/single-coordinator.html'
  }
  var coordinatorList = {
    name: 'eventDetails.coordinatorlist',
    url: '/coordinatorlist/:subevent',
    templateUrl: 'templates/coordinator-list.html'
  }
  
    var singleConfigState = {
		name: 'singleConfig',
		url: '/singleConfig/:siteid', 
		templateUrl: 'templates/single-config.html'
  }

  
  

	$stateProvider.state(eventListState);
	$stateProvider.state(administrationState);
	$stateProvider.state(eventDetails);
	$stateProvider.state(eventDetailseventinformation);
	$stateProvider.state(eventDetailseventoptiongroups);
	$stateProvider.state(eventDetailsactivities);
	$stateProvider.state(singleeventDetailseventoptiongroup);
	$stateProvider.state(singleOption);
	$stateProvider.state(eventActivityForm);
	$stateProvider.state(singleactivityDetailseventoptiongroup);
	
	$stateProvider.state(singlePrice);
	$stateProvider.state(eventDetailsPriceList);
	
	$stateProvider.state(singleCoordinator);
	$stateProvider.state(coordinatorList);
	
	$stateProvider.state(eventDetailsReporting);
	
	$stateProvider.state(singleConfigState);
})





;









/*
 * The following compatibility check is from:
 *
 * Bootstrap Customizer (http://getbootstrap.com/customize/)
 * Copyright 2011-2014 Twitter, Inc.
 *
 * Licensed under the Creative Commons Attribution 3.0 Unported License. For
 * details, see http://creativecommons.org/licenses/by/3.0/.
 */
var isOldBrowser;
(function () {

    var supportsFile = (window.File && window.FileReader && window.FileList && window.Blob);
    function failback() {
        isOldBrowser = true;
    }
    /**
     * Based on:
     *   Blob Feature Check v1.1.0
     *   https://github.com/ssorallen/blob-feature-check/
     *   License: Public domain (http://unlicense.org)
     */
    var url = window.URL;
    var svg = new Blob(
        ['<svg xmlns=\'http://www.w3.org/2000/svg\'></svg>'],
        { type: 'image/svg+xml;charset=utf-8' }
    );
    var objectUrl = url.createObjectURL(svg);

    if (/^blob:/.exec(objectUrl) === null || !supportsFile) {
      // `URL.createObjectURL` created a URL that started with something other
      // than "blob:", which means it has been polyfilled and is not supported by
      // this browser.
      failback();
    } else {
      angular.element('<img/>')
          .on('load', function () {
              isOldBrowser = false;
          })
          .on('error', failback)
          .attr('src', objectUrl);
    }

  })();



angular.module('eventsadmin')

.controller('MainsCtrl', function($scope, $http, $document, $uibModal, orderByFilter, $rootScope, $window, $timeout) {
  // Grab old version docs
	//this gets our site id from index.cfm
 	$scope.siteid = $window.siteid;

	$rootScope.$on('$stateChangeSuccess', 
	function(event, toState, toParams, fromState, fromParams){ 
		console.log('changing state to: ' + toState.name);
	});
	
	$scope.$on('$viewContentLoaded', function(){
		
			$timeout(function(){
				jQuery('textarea:visible').not('.ckeditoradded').addClass('ckeditoradded').each(function(){
					try{
						$(this).ckeditor(
						
							{ toolbar :
									[
										{ name: 'basicstyles', items : [ 'Bold','Italic' ] },
										{ name: 'paragraph', items : [ 'NumberedList','BulletedList' ] },
										{ name: 'tools', items : [ 'Maximize','-','About' ] },
										{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
										{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] }
									],
							customConfig : 'config.js.cfm'}
							,
							function(editorInstance){
								htmlEditorOnComplete(editorInstance);
								
							}

						);
					
					
						
				
						
					}catch(e){
						console.log('error: ');
						console.log(e);
					}
				}
				);
				 for (var i in CKEDITOR.instances) {
                	try{
						CKEDITOR.instances[i].on('change', function(d) { 
							try{
								var useid = d.editor.name;							
								mys = angular.element($("#" + useid)).scope();
								mys.model[mys.options.key] = $('.cke_editor_' + useid + ' iframe').contents().find('body').html();
							}catch(e){
								console.log("Unable to update instance of ckeditor: " + e.message);
							}
							
						});
					}catch(e){
						console.log("Unable to update instance of ckeditor: " + e.message);
					}

				}
			}, 300);
			
	});
	$http.get('/bootstrap/versions-mapping.json')
	.then(function(result) {
		$scope.oldDocs = result.data;
	});
	
	$scope.setActiveTab = function( index ){
		localStorage.setItem("CurrentActiveHome", parseInt(index));
		$scope.activeMain = index;
		activeMain = index;
		cur_active_home = index;
		
	};
	
	$scope.getStoredActive = function(){
		var cur_active_home = localStorage.getItem("CurrentActiveHome");
		if (cur_active_home != null){
			$scope.setActiveTab(parseInt(cur_active_home));
		}else{
			$scope.setActiveTab(parseInt(0));
		}
	}
	
})


.controller('AccordionDemoCtrl', function ($scope) {
  $scope.oneAtATime = true;

  $scope.groups = [
    {
      title: 'Dynamic Group Header - 1',
      content: 'Dynamic Group Body - 1'
    },
    {
      title: 'Dynamic Group Header - 2',
      content: 'Dynamic Group Body - 2'
    }
  ];

  $scope.items = ['Item 1', 'Item 2', 'Item 3'];

  $scope.addItem = function() {
    var newItemNo = $scope.items.length + 1;
    $scope.items.push('Item ' + newItemNo);
  };

  $scope.status = {
    isCustomHeaderOpen: false,
    isFirstOpen: true,
    isFirstDisabled: false
  };
})


.config(function($httpProvider) {

	$httpProvider.interceptors.push(function($q, $rootScope) {
		return {
			'request': function(config) {
				$rootScope.$broadcast('loading-started');
				return config || $q.when(config);
			},
			'response': function(response) {
				$rootScope.$broadcast('loading-complete');
				return response || $q.when(response);
			}
		};
	});

})



.directive("loadingIndicator", function() {
	return {
		restrict : "A",
		template: "<div>Loading...</div>",
		link : function(scope, element, attrs) {
			scope.$on("loading-started", function(e) {
				element.css({"opacity" : "1"});
			});

			scope.$on("loading-complete", function(e) {
				element.css({"opacity": "0"});
			});

		}
	};
})


 .run(function(formlyConfig) {
	
	var attributes = [
    'date-disabled',
    'custom-class',
    'show-weeks',
    'starting-day',
    'init-date',
    'min-mode',
    'max-mode',
    'format-day',
    'format-month',
    'format-year',
    'format-day-header',
    'format-day-title',
    'format-month-title',
    'year-range',
    'shortcut-propagation',
    'datepicker-popup',
    'show-button-bar',
    'current-text',
    'clear-text',
    'close-text',
    'close-on-date-selection',
    'datepicker-append-to-body'
  ];

  var bindings = [
    'datepicker-mode',
    'min-date',
    'max-date'
  ];

  var ngModelAttrs = {};

  angular.forEach(attributes, function(attr) {
    ngModelAttrs[camelize(attr)] = {attribute: attr};
  });

  angular.forEach(bindings, function(binding) {
    ngModelAttrs[camelize(binding)] = {bound: binding};
  });

  
  formlyConfig.setType({
      name: 'datetimepicker',
      template: '<br><datetimepicker ng-model="model[options.key]" show-spinners="true" date-format="M/d/yyyy" date-options="dateOptions"></datetimepicker>',
      wrapper: ['bootstrapLabel'],
      defaultOptions: {
        ngModelAttrs: ngModelAttrs,
        templateOptions: {
          label: 'Time',
          minDate: '04/01/2016'
        }
      }
    });
	
  formlyConfig.setType({
    name: 'datepicker',
    templateUrl:  'datepicker.html',
    wrapper: ['bootstrapLabel', 'bootstrapHasError'],
    defaultOptions: {
      ngModelAttrs: ngModelAttrs,
      templateOptions: {
        datepickerOptions: {
          format: 'MM/dd/yyyy',
          initDate: new Date()
        }
      }
    }
	  ,
    link: function(scope){
      var model = scope.model[scope.options.key]
      var isDate = (model instanceof Date)
      if(!isDate){
        scope.model[scope.options.key] = new Date(model)
      }
    }
	  ,
	  
    controller: ['$scope', function ($scope) {
      $scope.datepicker = {};

      $scope.datepicker.opened = false;

      $scope.datepicker.open = function ($event) {
        $scope.datepicker.opened = !$scope.datepicker.opened;
      };
    }]
  });

  function camelize(string) {
    string = string.replace(/[\-_\s]+(.)?/g, function(match, chr) {
      return chr ? chr.toUpperCase() : '';
    });
    // Ensure 1st char is always lowercase
    return string.replace(/^([A-Z])/, function(match, chr) {
      return chr ? chr.toLowerCase() : '';
    });
  }
	/*
  timepicker
  */
    
  ngModelAttrs = {};

  // attributes
  angular.forEach([
    'meridians',
    'readonly-input',
    'mousewheel',
    'arrowkeys'
  ], function(attr) {
    ngModelAttrs[camelize(attr)] = {attribute: attr};
  });
  
  // bindings
  angular.forEach([
    'hour-step',
    'minute-step',
    'show-meridian'
  ], function(binding) {
    ngModelAttrs[camelize(binding)] = {bound: binding};
  });
  
  formlyConfig.setType({
    name: 'timepicker',
    template: '<div uib-timepicker ng-model="model[options.key]"></div>',
    wrapper: ['bootstrapLabel', 'bootstrapHasError'],
    defaultOptions: {
      ngModelAttrs: ngModelAttrs,
      templateOptions: {
        datepickerOptions: {}
      }
    }
  });
	
	
});


