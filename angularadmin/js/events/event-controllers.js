angular.module('eventsadmin')
	
.controller('eventsListController', ['eventServices','$scope','$state', '$timeout', 'modalService', function (eventServices, $scope, $state, $timeout, modalService){
	
	$scope.events = [];
	$scope.loading = true;
	//pasing zero gets all events
	data = eventServices.getEvents(0);
	
	$scope.selectedEvents = [1,2];
	$scope.pastevents 			= 1;
	$scope.futureevents 		= 2;
	$scope.current_date = new Date();
	
	data.then(function(resp){
		$scope.loading = false;
		$scope.events = resp;
	});
	$scope.getDateFromString = function(s){
		return new Date(s);
	}
	localStorage.setItem("activeTab", parseInt(0));
	$scope.deleteEvent = function(eventid, $event){
  		var modalOptions = {
            closeButtonText: 'Cancel',
            actionButtonText: 'Delete Event',
            headerText: 'Delete event?',
            bodyText: 'Are you sure you want to delete this event?'
        };

        modalService.showModal({}, modalOptions).then(function (result) {
			eventServices.deleteEvent(eventid).then(function(res){
				$state.go("eventlist", {}, {reload: true});	
			});
        });
		

		$event.stopPropagation();
		$event.preventDefault();
	};
	$scope.copyEvent = function(sourceEventID, $event){
		$state.go("eventDetails.eventinformation", {eventid : -1, sourceEventID : sourceEventID})
		$event.stopPropagation();
		$event.preventDefault();
	}
	$scope.updateFooter = function(){
		$timeout(function(){
			$(".tablesorter").DataTable().draw();	
		}, 50)
		
	}
		
}])

.controller('eventDetailsController', ['eventServices','$scope','$stateParams', function (eventServices, $scope, $stateParams){
	
	$scope.event = [];
	$scope.sourceEventID = $stateParams.sourceEventID;
	$scope.sourceEvent = {};
	$scope.loading = true;
	data = eventServices.getEvents($stateParams.eventid);
	data.then(function(resp){
		$scope.event = resp[0];
		if(typeof $scope.sourceEventID != 'undefined' && !isNaN($scope.sourceEventID) && $scope.sourceEventID > 0){
			var sourcedata = eventServices.getEvents($scope.sourceEventID);
			sourcedata.then(function(resp){
				console.log("source event fetched");
				$scope.sourceEvent = resp[0];
				for(i in $scope.event)
					if(i != 'TContent_ID')
						$scope.event[i] = $scope.sourceEvent[i];
				$scope.loading = false;

			})
		}else{
			$scope.loading = false;
		}

	});
	
	
}])

.controller('singleEventEdit', ['eventServices','$scope','$stateParams', function (eventServices, $scope, $stateParams){
	
	$scope.event = [];
	$scope.sourceEventID = $stateParams.sourceEventID;
	/*
	data = eventServices.getEvents($stateParams.eventid);
	data.then(function(resp){
		$scope.event = resp[0];
	});
	*/
	
	
}])
.controller('optionGroupListController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.eventOptionGroups = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	$scope.loading = true;
	$scope.loadCarIntoOptionGroup = function(source_event, source_subevent, target_event, target_subevent){
	
		var promise = eventServices.eventCopier(source_event, source_subevent, target_event, target_subevent, 'optionsonly');
		promise.then(function(d){
				$state.reload();
		});
	}
	$scope.loadTrackExperienceOption = function(source_event, source_subevent, target_event, target_subevent){
		
		var promise = eventServices.eventCopier(source_event, source_subevent, target_event, target_subevent, 'loadTrackExperience');
		promise.then(function(d){
				$state.reload();
		});
	}
	
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
		$scope.loading = false;
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
	
	$scope.loading = true;
	//passing the eventid gets the sub events when the subeventid is zero
	data = eventServices.getSubEvents($stateParams.eventid, 0);
	data.then(function(resp){
		$scope.loading = false;
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




.controller("editActivityController", ['$scope', 'eventServices', '$stateParams','$state', '$timeout', 'eventActivities', 'activityFields',
								function($scope, eventServices, $stateParams, $state, $timeout, eventActivities, activityFields){
	
	//this fetches our form data
	$scope.activityFields = activityFields;
	$scope.eventActivities = eventActivities;
	$scope.loading = true;
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	$scope.updateActivities = function(){
		var data_two = eventServices.getSubEvents($stateParams.eventid, $stateParams.subevent);
		data_two.then(function(resp){
			$scope.eventActivities = resp;
			$scope.$digest();
			$scope.loading = false;
		});
	};
	
	//$timeout($scope.updateActivities, 5000);
	
	
	$scope.loadCarIntoOptionGroup = function(source_event, source_subevent, target_event, target_subevent){
		data = {};
		var promise = eventServices.eventCopier(source_event, source_subevent, target_event, target_subevent, 'optionsonly');
		promise.then(function(d){
				$state.reload();
		});
	}
	$scope.loadTrackExperienceOption = function(source_event, source_subevent, target_event, target_subevent){
		
		var promise = eventServices.eventCopier(source_event, source_subevent, target_event, target_subevent, 'loadTrackExperience');
		promise.then(function(d){
				$state.reload();
		});
	}
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
	
.controller("eventEditController", ['$scope', 'eventServices', '$state', '$stateParams', function($scope, eventServices, $state, $stateParams){
	
	$scope.eventFields = 	[];
	$scope.sourceEventID = $stateParams.sourceEventID;
	$scope.targetEventID = $stateParams.eventid;
	$scope.loading = true;
	$scope.sourceTitle = $scope.event.ShortTitle;
	//if we have a source event, we copy that into the event object if we are creating an event
	//this basically allows us the "copy" event feature to pull in the event details
	$scope.creatingCopy = false;
	if($stateParams.eventid == -1 && typeof $scope.sourceEventID != 'undefined' && !isNaN($scope.sourceEventID) && $scope.sourceEventID > 0)
		$scope.creatingCopy = true;

	
	eventServices.getFormData('p_eventregistration_events').then(function(d){
		$scope.eventFields = d;
		$scope.loading = false;
	});

	$scope.optionGroupFields = [];
	eventServices.getFormData('p_eventregistration_optionGroups').then(function(d){
		$scope.optionGroupFields = d;
	});
	
	$scope.optionFields = [];
	eventServices.getFormData('p_eventregistration_options').then(function(d){
		$scope.optionFields = d;
	});
	
	$scope.saveEvent = function(event, creatingCopy){
		//if we are creating a copy, we set the type to be the source event
		if(!creatingCopy)
			creatingCopy = false;
		$scope.event.creatingCopy = creatingCopy;
		$scope.event.sourceEventID = $scope.sourceEventID;
		$scope.event.creatingCopy = creatingCopy;
		$scope.event.sourceEventID = $scope.sourceEventID;
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
		try{
			$event.stopPropagation();
			$event.preventDefault();
		}catch(e){}
		
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
	$scope.loading = true;
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
		$scope.loading = false;
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
	$scope.loading = true;

	
	//here we load our form variables
	$scope.configFields = 	[];
	eventServices.getFormData('p_eventregistration_configs').then(function(d){
		$scope.configFields = d;
	});
	
	
	$scope.updateconfigData= function(){
			
			data = eventServices.getconfigs($stateParams.siteid);
			data.then(function(resp){
				$scope.configs = resp;
				$scope.loading = false;
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

.controller('paymentsListController', ['$scope', 'eventServices', '$stateParams', '$state', 'RegistrationDetails','$mdDialog',
									   	function($scope, eventServices, $stateParams, $state, RegistrationDetails, $mdDialog){
	$scope.paymentss = [];
	$scope.eventid = $stateParams.eventid;
	$scope.loading = true;
	$scope.subevent = $stateParams.subevent;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	console.log($scope.subevent);
	
	$scope.deletepayments = function(payment_id, $event){
		 var confirm = $mdDialog.confirm()
				  .title('Are you sure you want to delete this payment?')
				  .textContent('Deletion is permanent')
				  .targetEvent($event)
				  .ok('Delete It')
				  .cancel('Cancel');

			$mdDialog.show(confirm).then(function() {
			 	eventServices.deletepayments(payment_id).then(function(res){
					$state.go('eventDetails.reporting.payments', {eventid: $stateParams.eventid}, {reload: true});
				});
			}, function() {
			 
			});

		return;
	
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	data = eventServices.getpaymentss($stateParams.eventid,0, $scope.subevent);
	data.then(function(resp){
		$scope.paymentss = resp;
		$scope.loading = false;
	});
	$scope.viewRegistration = function(regid){
		RegistrationDetails.showDetailsPopup(regid, $scope);
	}
	
}])

.controller('singlepaymentsController', ['$scope', 'eventServices', '$stateParams', '$state', function($scope, eventServices, $stateParams, $state){
	$scope.paymentss = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.payment_id = $stateParams.payment_id;
	$scope.subevent = $stateParams.subevent;
	$scope.registration_id = $stateParams.targetRegistration;
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	
	//here we load our form variables
	$scope.paymentsFields = 	[];
	eventServices.getFormData('p_eventregistration_payments').then(function(d){
		$scope.paymentsFields = d;
		
	});
	
	
	$scope.updatepaymentsData= function(){

			data = eventServices.getpaymentss($scope.eventid, $scope.payment_id, $scope.subevent );
			data.then(function(resp){
				$scope.paymentss = resp;
				if( $scope.payment_id == -1 &&  $stateParams.targetRegistration)
					$scope.paymentss[0].registration_id = $stateParams.targetRegistration;
			});
		}
	$scope.updatepaymentsData();
	
	$scope.savepayments = function(payments){
		
		payments.payment_id = $scope.payment_id;
		payments.subevent = $scope.subevent;
		payments.mainevent = $scope.eventid;
		
		eventServices.savepayments($scope.eventid, payments.payment_id, payments, payments.subevent ).then(function(d){

				$state.go('eventDetails.reporting.payments', {eventid: $stateParams.eventid}, {reload: true});
		});
	};	
	
}])

		


;