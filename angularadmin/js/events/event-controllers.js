angular.module('eventsadmin')
	
.controller('eventsListController', ['eventServices','$scope','$state', function (eventServices, $scope, $state){
	
	$scope.events = [];
	//pasing zero gets all events
	data = eventServices.getEvents(0);
	data.then(function(resp){
		$scope.events = resp;
	});
	localStorage.setItem("activeTab", parseInt(0));
	$scope.deleteEvent = function(eventid, $event){
		eventServices.deleteEvent(eventid).then(function(res){
			$state.go("eventlist", {}, {reload: true});	
		});
		$event.stopPropagation();
		$event.preventDefault();
	};
}])

.controller('eventDetailsController', ['eventServices','$scope','$stateParams', function (eventServices, $scope, $stateParams){
	
	$scope.event = [];
	
	data = eventServices.getEvents($stateParams.eventid);
	data.then(function(resp){
		$scope.event = resp[0];
	});
	
	
}])

.controller('singleEventEdit', ['eventServices','$scope','$stateParams', function (eventServices, $scope, $stateParams){
	
	$scope.event = [];
	
	data = eventServices.getEvents($stateParams.eventid);
	data.then(function(resp){
		$scope.event = resp[0];
	});
	
	
}])
.controller('optionGroupListController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.eventOptionGroups = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	
	
	
	$scope.deleteOptiongroup = function(optiongroupid, $event){
		eventServices.deleteOptionGroup(optiongroupid).then(function(res){
			$state.go('eventDetails.eventoptiongroups', {eventid: $stateParams.eventid, subevent: $scope.subevent}, {reload: true});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.getEventOptions($stateParams.eventid, $scope.subevent);
	data.then(function(resp){
		$scope.eventOptionGroups = resp;
	});
}])

.controller('singleOptionController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.eventOptions = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.optiongroup = $stateParams.optiongroup;
	$scope.optionid = $stateParams.optionid;
	console.log("single option controller option group: " + $scope.optiongroup);
	$scope.subevent = $stateParams.subevent;
	console.log("single option controller : Sub Event ID:" + $scope.subevent);
	console.log('single option controller : Scope eventid: ' + $scope.eventid);
	console.log('single option controller : optionid: ' + $scope.optionid);
	
	
	//here we load our form variables
	$scope.optionFields = 	[];
	eventServices.getFormData('p_eventregistration_options').then(function(d){
		$scope.optionFields = d;
	});
	
	
	$scope.updateOptionData= function(){

			data = eventServices.getOption($scope.eventid, $scope.optionid, $scope.subevent );
			data.then(function(resp){
				$scope.eventOptions = resp;
				console.log("event options: " );
				console.log($scope.eventOptions );
			});
		}
	$scope.updateOptionData();
	$scope.saveOption = function(option){
		console.log(option);
		option.option_id = $scope.optionid;
		option.subevent = $scope.subevent;
		
		eventServices.saveOption($scope.eventid, $stateParams.optiongroup, option, $scope.subevent).then(function(d){
			if($scope.subevent == -1)
				$state.go('eventDetails.singleoptiongroup', 
					{eventid: $scope.eventid, 
					 optiongroupid: $scope.optiongroup, 
					 subevent : $scope.subevent, 
					 optionid: $scope.optionid}	,
						  {reload: true}
						);
			else
				$state.go('eventDetails.subeventsingleoptiongroup', 
					{eventid: $scope.eventid, 
					 optiongroup: $scope.optiongroup, 
					 subevent : $scope.subevent, 
					 optionid: $scope.optionid}	,
						  {reload: true}
						);
				
			
		});
	};	
	$scope.deleteOption = function(optionid, $event){
		eventServices.deleteOption(optionid).then(function(res){
			if($scope.subevent == -1)
				$state.go('eventDetails.singleoptiongroup', {eventid: $scope.eventid, subevent : $scope.subevent, optiongroup: $scope.optiongroup},
					  {reload: true});
			else
				$state.go('eventDetails.subeventdetails', {eventid: $scope.eventid, subevent : $scope.subevent},
					  {reload: true});
		})
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	
	
}])


.controller('optionoractivitynameController', ['$scope', 'eventServices', function($scope, eventServices){
	$scope.optionoractivityname = '';
	$scope.showActivityName = false;
	eventServices.getSubEvents($scope.eventid, $scope.subevent).then(function(d){
		if(d.length > 0 && typeof d[0].subevent_name != 'undefined' && d[0].subevent_name != ''){
				$scope.showActivityName = true;
				$scope.optionoractivityname = d[0].subevent_name;
		}			
	});
}])

.controller('eventActivitiesController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.subEvents = [];
	

	//passing the eventid gets the sub events when the subeventid is zero
	data = eventServices.getSubEvents($stateParams.eventid, 0);
	data.then(function(resp){
		$scope.subEvents = resp;
	});
	
	$scope.deleteSubEvent = function(subeventid, $event){
		eventServices.deleteSubEvent(subeventid).then(function(res){
			$state.go('eventDetails.activities', {eventid: $stateParams.eventid}, {reload: true});
		});
		$event.stopPropagation();
		$event.preventDefault();
	};
	
}])
.controller('singleOptionGroupController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	
	//this is the single group information object
	$scope.eventOptionGroups = [];
	
	//this is the list of options in this group
	$scope.eventOptions = [];
	
	//this controls the visibility of the add an option button
	$scope.addAnOptionButtonVisible = true;
	$scope.hmmm = function(){
		$scope.addAnOptionButtonVisible = !$scope.addAnOptionButtonVisible;
	}
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.optiongroup = $stateParams.optiongroup;
	$scope.subevent = $stateParams.subevent;

	



	//this loads the single eventOptionGroup into eventOptionGroups
	var data = eventServices.getOptionGroup($stateParams.eventid, $stateParams.optiongroup, $scope.subevent);
	data.then(function(resp){
		$scope.eventOptionGroups = resp;
		console.log($scope.eventOptionGroups );
	});
	
	//this loads the list of options associated with this option group
	$scope.updateOptions = function(){
		var data_two = eventServices.getOptions($stateParams.eventid, 0, $scope.subevent, $scope.optiongroup);
		data_two.then(function(resp){
			$scope.eventOptions = [];
			for(i =0; i < resp.length; i++)
					if(resp[i].option_id != '')
						$scope.eventOptions.push(resp[i]);
			console.log($scope.eventOptions );
		});
	};
	
	$scope.updateOptions();
	
	
	
	//this loads the options for this group into eventOptions
	$scope.saveOptionGroup = function(optionGroup){
		eventServices.saveOptionGroup($scope.eventid, $stateParams.optiongroup, optionGroup, $scope.subevent).then(function(d){
			if($scope.subevent == -1)
				$state.go('eventDetails.eventoptiongroups', {eventid: $scope.eventid, subevent : $scope.subevent},
					  {reload: true});
			else
				$state.go('eventDetails.subeventdetails', {eventid: $scope.eventid, subevent : $scope.subevent},
					  {reload: true});
		});
	};
	
	$scope.deleteOption = function(optionid, $event){
		eventServices.deleteOption(optionid).then(function(res){
			if($scope.subevent == -1)
				$state.go('eventDetails.singleoptiongroup', {eventid: $scope.eventid, subevent : $scope.subevent, optiongroup: $scope.optiongroup},
					  {reload: true});
			else
				$state.go('eventDetails.subeventdetails', {eventid: $scope.eventid, subevent : $scope.subevent},
					  {reload: true});
		})
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	
	

}])




.controller("editActivityController", ['$scope', 'eventServices', '$stateParams','$state',  function($scope, eventServices, $stateParams, $state){
	
	//this fetches our form data
	$scope.activityFields = 	[];
	eventServices.getFormData('p_eventregistration_subevent').then(function(d){
		$scope.activityFields = d;
	});
	$scope.eventActivities = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	$scope.updateActivities = function(){
		var data_two = eventServices.getSubEvents($stateParams.eventid, $stateParams.subevent);
		data_two.then(function(resp){
			$scope.eventActivities = resp;
		});
	};
	
	$scope.updateActivities();
	
	$scope.saveActivity = function(subevent_struct){
		subevent_struct.eventid = $stateParams.eventid;
		subevent_struct.subevent_event = $stateParams.eventid;
		
		eventServices.saveSubEvent(subevent_struct).then(function(d){
			$state.go('eventDetails.activities', {eventid: $stateParams.eventid},
					  {reload: true});			
		});
	}
	
	//this fetches and manages our option groups for this subactivity
	
	$scope.deleteOptiongroup = function(optiongroupid, $event){
		eventServices.deleteOptionGroup(optiongroupid).then(function(res){
			if($scope.subevent == -1)
				$state.go('eventDetails.eventoptiongroups', {eventid: $stateParams.eventid, subevent: $scope.subevent}, {reload: true});
			else
				$state.go('eventDetails.subeventdetails', {eventid: $scope.eventid, subevent : $scope.subevent},
					  {reload: true});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.getEventOptions($stateParams.eventid, $stateParams.subevent);
	data.then(function(resp){
		$scope.eventOptionGroups = [];
		for(i = 0; i < resp.length; i++)
			if(resp[i].subevent == $scope.subevent)
				$scope.eventOptionGroups.push(resp[i]);
			else
				console.log(resp[i].subevent + '!=' + $scope.subevent);
		
	});
	
	
}])
	
.controller("eventEditController", ['$scope', 'eventServices', '$state',  function($scope, eventServices, $state){
	
	$scope.eventFields = 	[];
	eventServices.getFormData('p_eventregistration_events').then(function(d){
		$scope.eventFields = d;
	});

	$scope.optionGroupFields = [];
	eventServices.getFormData('p_eventregistration_optionGroups').then(function(d){
		$scope.optionGroupFields = d;
	});
	
	$scope.optionFields = [];
	eventServices.getFormData('p_eventregistration_options').then(function(d){
		$scope.optionFields = d;
	});
	
	$scope.saveEvent = function(){
		eventServices.saveEvent($scope.event).then(function(d){
			$state.go('eventlist');	
		});
		
	}
	
	// here I need to load event options and event activities / options into appropriate $scope vars and then render edit fields for those
	
	//this allows the correct tab to reloaded upon reload of the page
	$scope.setActiveTab = function( activeTab ){
		localStorage.setItem("activeTab", parseInt(activeTab));
		
	};
	$scope.getStoredTabSelection = function(){
		$scope.activeEventTab = $scope.getActiveTab();
		activeEventTab = $scope.activeEventTab;
	}
	$scope.getActiveTab = function(){
		
		var cur_act = localStorage.getItem("activeTab");
		if(cur_act == null)
			return parseInt(0);
		return parseInt(localStorage.getItem("activeTab"));
		
	};

	
		
}])




.controller('priceListController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.eventPrices = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	console.log($scope.subevent);
	
	$scope.deletePrice = function(priceid, $event){
		eventServices.deletePrice(priceid).then(function(res){
			$state.go('eventDetails.eventpricelist', {eventid: $stateParams.eventid, subevent: $scope.subevent}, {reload: true});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.getPrices($stateParams.eventid,0, $scope.subevent);
	data.then(function(resp){
		$scope.eventPrices = resp;
	});
}])





.controller('coordinatorListController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.coordinators = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	console.log($scope.subevent);
	
	$scope.deletecoordinator = function(coordinator_id, $event){
		eventServices.deletecoordinator(coordinator_id).then(function(res){
			$state.go('eventDetails.coordinatorlist', {eventid: $stateParams.eventid, subevent: $scope.subevent}, {reload: true});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.getcoordinators($stateParams.eventid,0, $scope.subevent);
	data.then(function(resp){
		$scope.coordinators = resp;
	});
}])

.controller('singlecoordinatorController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.coordinators = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.coordinator_id = $stateParams.coordinator_id;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	
	//here we load our form variables
	$scope.coordinatorFields = 	[];
	eventServices.getFormData('p_eventregistration_coordinator').then(function(d){
		$scope.coordinatorFields = d;
	});
	
	
	$scope.updatecoordinatorData= function(){

			data = eventServices.getcoordinators($scope.eventid, $scope.coordinator_id, $scope.subevent );
			data.then(function(resp){
				$scope.coordinators = resp;
			});
		}
	$scope.updatecoordinatorData();
	
	$scope.savecoordinator = function(coordinator){
		
		coordinator.coordinator_id = $scope.coordinator_id;
		coordinator.subevent = $scope.subevent;
		coordinator.mainevent = $scope.eventid;
		
		eventServices.savecoordinator($scope.eventid, coordinator.coordinator_id, coordinator, coordinator.subevent ).then(function(d){

				$state.go('eventDetails.coordinatorlist', 
					{eventid: $scope.eventid, 
					 subevent : $scope.subevent, 
					 }	,
						  {reload: true}
						);
		});
	};	
	
}])

		

.controller('configListController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.configs = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	console.log($scope.subevent);
	
	$scope.deleteconfig = function(config_id, $event){
		eventServices.deleteconfig(config_id).then(function(res){
			$state.go('eventDetails.configlist', {eventid: $stateParams.eventid, subevent: $scope.subevent}, {reload: true});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.getconfigs($stateParams.eventid,0, $scope.subevent);
	data.then(function(resp){
		$scope.configs = resp;
	});
}])

.controller('singleconfigController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.configs = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.siteid = $stateParams.siteid;
	

	
	//here we load our form variables
	$scope.configFields = 	[];
	eventServices.getFormData('p_eventregistration_configs').then(function(d){
		$scope.configFields = d;
	});
	
	
	$scope.updateconfigData= function(){
			
			data = eventServices.getconfigs($stateParams.siteid);
			data.then(function(resp){
				$scope.configs = resp;
			});
		}
	$scope.updateconfigData();
	
	$scope.saveconfig = function(config){
		
		config.siteid = $stateParams.siteid;
		eventServices.saveconfig(config.siteid, config ).then(function(d){

				$state.go('singleConfig', 
					{siteid: $scope.siteid
					 }	,
						  {reload: true}
						);
		});
	};	
	
}])

		


.controller('singlePriceController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.eventPrices = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.priceid = $stateParams.priceid;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	
	//here we load our form variables
	$scope.priceFields = 	[];
	eventServices.getFormData('p_eventregistration_prices').then(function(d){
		$scope.priceFields = d;
	});
	
	
	$scope.updatePriceData= function(){

			data = eventServices.getPrices($scope.eventid, $scope.priceid, $scope.subevent );
			data.then(function(resp){
				$scope.eventPrices = resp;
			});
		}
	$scope.updatePriceData();
	
	$scope.savePrice = function(price){
		
		price.priceid = $scope.priceid;
		price.subevent = $scope.subevent;
		price.mainevent = $scope.eventid;
		
		eventServices.savePrice($scope.eventid, price.priceid, price, price.subevent ).then(function(d){

				$state.go('eventDetails.eventpricelist', 
					{eventid: $scope.eventid, 
					 subevent : $scope.subevent, 
					 }	,
						  {reload: true}
						);
		});
	};	
	
}])



;