angular.module('eventsadmin')

.factory('eventServices', ['$http', '$window', function($http, $window){
	function setBooleans(response){
		try{
		for(i = 0; i < response.data.length; i++)
			for (x in response.data[i])
				if(response.data[i][x] == 'true')
					response.data[i][x] = true;
				else if(response.data[i][x] == 'false')
					response.data[i][x] = false;
		}catch(e){};
		return response;
		
	}
	return {
		
		
		deleteEvent : function(eventid){
			var promise;
			 var url = '/Taffy/index.cfm/event/' + eventid;
                promise = $http.delete(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		eventCopier(source_event, source_subevent, target_event, target_subevent, mode){
			
			if(typeof $window.siteid == 'undefined' || $window.siteid == ''){
				console.log('Error siteid not defined, unable to copy event.');
				return;
			}
			var url= '/Taffy/index.cfm/eventcopier';
			var input_data = {};
			input_data.source_event = source_event;
			input_data.target_event = target_event;
			input_data.source_subevent = source_subevent;
			input_data.target_subevent = target_subevent;
			input_data.mode = mode;
			input_data.siteid = $window.siteid;
			var promise;
			
			promise = $http.post(url, input_data).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
			
				
			
		},
		deleteSubEvent : function(subeventid){
			var promise;
			var eventid = 0;
			var url = '/Taffy/index.cfm/subevent/' + eventid + '/subeventid/' + subeventid;
                promise = $http.delete(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		deleteOption : function(optionid){
			var promise;
			var eventid = 0;
			var subevent = 0;
			 var url = '/Taffy/index.cfm/option/'+optionid + '/eventid/' + eventid + '/subevent/' + subevent + '/optiongroup/' + 0;
                promise = $http.delete(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;	
			
		},
		deleteOptionGroup : function(optiongroupid){
			var promise;
			var eventid = 0;
			var subevent = 0;			
			var url = '/Taffy/index.cfm/optiongroup/'+optiongroupid+'/event/' + eventid + '/subevent/' + subevent;
                promise = $http.delete(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		getEvent : function (eventid){
			
			return;	
			
		},
		getEvents : function (eventid){
			
			var promise;
			 var url = '/Taffy/index.cfm/event/' + eventid;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		getSubEvents : function (eventid, subeventid){
			
			var promise;
			 var url = '/Taffy/index.cfm/subevent/' + eventid + '/subeventid/' + subeventid;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
	
		
		getEventOptions : function(eventid, subevent){
			var promise;
			 var url = '/Taffy/index.cfm/optiongroup/0/event/' + eventid + '/subevent/' + subevent;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
					
                    return response.data;
                });
			return promise;
			
		},
		getOptionGroup : function(eventid, optiongroupid, subevent){
			var promise;
			 var url = '/Taffy/index.cfm/optiongroup/'+optiongroupid+'/event/' + eventid + '/subevent/' + subevent;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		getOption : function(eventid, optionid, subevent){
			var promise;
			 var url = '/Taffy/index.cfm/option/'+optionid + '/eventid/' + eventid + '/subevent/' + subevent + '/optiongroup/' + 0;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		getOptions : function(eventid, optionid, subevent, optiongroupid){
			var promise;
			 var url = '/Taffy/index.cfm/option/' + optionid + '/eventid/' + eventid + '/subevent/' + subevent + '/optiongroup/' + optiongroupid;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		saveOptionGroup : function(eventid, optiongroupid, optionGroup, subevent){
			var promise;
			var url = '/Taffy/index.cfm/optiongroup/'+optiongroupid+'/event/' + eventid + '/subevent/' + subevent;
			var wrapped_group = {};
			wrapped_group.input_data = optionGroup;
			wrapped_group.input_data.optiongroupid = optiongroupid;
			wrapped_group.input_data.eventid = eventid;
			var input_data = JSON.stringify(wrapped_group);
			promise = $http.put(url, input_data).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
			
		},
		saveOption : function(eventid, optiongroupid, option, subevent){
			var promise;
			var url = '/Taffy/index.cfm/option/'+option.option_id+'/eventid/' + eventid + '/subevent/' + subevent + '/optiongroup/' + optiongroupid;
			var wrapped_group = {};
			wrapped_group.input_data = option;
			wrapped_group.input_data.optiongroupid = optiongroupid;
			wrapped_group.input_data.eventid = eventid;
			var input_data = JSON.stringify(wrapped_group);
			promise = $http.put(url, input_data).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
			
		},
		
		getFormData : function(table){
			var promise;
			 var url = '/plugins/EventRegistration/angularadmin/genFormly.cfm?table=' + table;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
		},
		saveEvent : function (event){
			
			var promise;
			var url = '/Taffy/index.cfm/event/' + event.TContent_ID;
			var wrapped_event = {};
			wrapped_event.event_data = event;

			var input_data = JSON.stringify(wrapped_event);
			promise = $http.put(url, input_data).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
		},
		saveSubEvent : function (event){
			
			var promise;
			var url = '/Taffy/index.cfm/subevent/' + event.subevent_event + '/subeventid/' + event.subeventid;
			var wrapped_event = {};
			wrapped_event.event_data = event;
			if(typeof wrapped_event.event_data.subevent_description == 'undefined')
				wrapped_event.event_data.subevent_description = '';
			
			var input_data = JSON.stringify(wrapped_event);
			promise = $http.put(url, input_data).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
		}
		,
		getPrices : function(eventid, priceid, subevent){
			var promise;
			 var url = '/Taffy/index.cfm/price/' + priceid + '/eventid/' + eventid + '/subevent/' + subevent;
                promise = $http.get(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;
			
		},
		savePrice : function(eventid, priceid, price, subevent){
			var promise;
			var url = '/Taffy/index.cfm/price/'+priceid+'/eventid/' + eventid + '/subevent/' + subevent;
			var wrapped_price = {};
			wrapped_price.input_data = price;
			wrapped_price.input_data.priceid = priceid;
			wrapped_price.input_data.eventid = eventid;
			wrapped_price.input_data.subevent = subevent;
			var input_data = JSON.stringify(wrapped_price);
			promise = $http.put(url, input_data).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
			
		},
		deletePrice : function(priceid){
			var promise;
			var eventid = 0;
			var subevent = 0;
			 var url = '/Taffy/index.cfm/price/'+priceid + '/eventid/' + eventid + '/subevent/' + subevent;
                promise = $http.delete(url)
                 .then(function (response) {
					response = setBooleans(response);
                    return response.data;
                });
			return promise;	
			
		}
					,
			getcoordinators : function(eventid, coordinator_id, subevent){
				var promise;
				 var url = '/Taffy/index.cfm/coordinator/' + coordinator_id + '/eventid/' + eventid + '/subevent/' + subevent;
					promise = $http.get(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;

			},
			savecoordinator : function(eventid, coordinator_id, coordinator, subevent){
				var promise;
				var url = '/Taffy/index.cfm/coordinator/'+coordinator_id+'/eventid/' + eventid + '/subevent/' + subevent;
				var wrapped_coordinator = {};
				wrapped_coordinator.input_data = coordinator;
				wrapped_coordinator.input_data.coordinator_id = coordinator_id;
				wrapped_coordinator.input_data.eventid = eventid;
				wrapped_coordinator.input_data.subevent = subevent;
				var input_data = JSON.stringify(wrapped_coordinator);
				promise = $http.put(url, input_data).then(function(response){
					response = setBooleans(response);
					return response.data;
				});
				return promise;

			},
			deletecoordinator : function(coordinator_id){
				var promise;
				var eventid = 0;
				var subevent = 0;
				 var url = '/Taffy/index.cfm/coordinator/'+coordinator_id + '/eventid/' + eventid + '/subevent/' + subevent;
					promise = $http.delete(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;	

			}
			,
			getconfigs : function(siteid){
				var promise;
				 var url = '/Taffy/index.cfm/config/' + siteid;
					promise = $http.get(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;

			},
			saveconfig : function(siteid, config){
				var promise;
				var url = '/Taffy/index.cfm/config/'+siteid;
				var wrapped_config = {};
				wrapped_config.input_data = config;
				wrapped_config.siteid = siteid;
				var input_data = JSON.stringify(wrapped_config);
				promise = $http.put(url, input_data).then(function(response){
					response = setBooleans(response);
					return response.data;
				});
				return promise;

			}

			,
			getpaymentss : function(eventid, payment_id, subevent){
				var promise;
				 var url = '/Taffy/index.cfm/payments/' + payment_id + '/eventid/' + eventid ;
					promise = $http.get(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;

			},
			savepayments : function(eventid, payment_id, payments, subevent){
				var promise;
				var url = '/Taffy/index.cfm/payments/'+payment_id+'/eventid/' + eventid;
				var wrapped_payments = {};
				wrapped_payments.input_data = payments;
				wrapped_payments.input_data.payment_id = payment_id;
				wrapped_payments.input_data.eventid = eventid;
				wrapped_payments.input_data.subevent = subevent;
				var input_data = JSON.stringify(wrapped_payments);
				promise = $http.put(url, input_data).then(function(response){
					response = setBooleans(response);
					return response.data;
				});
				return promise;

			},
			deletepayments : function(payment_id){
				var promise;
				var eventid = 0;
				var subevent = 0;
				 var url = '/Taffy/index.cfm/payments/'+payment_id + '/eventid/' + eventid;
					promise = $http.delete(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;	

			}



		

		


		
		
	}
	
}]);