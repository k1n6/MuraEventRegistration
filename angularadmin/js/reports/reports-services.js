angular.module('eventsadmin')

.factory('reportsServices', ['$http', '$window', function($http, $window){
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
	
		getCustomReportoutput : function(eventid, report_name){
			var promise;
			var url= '/Taffy/index.cfm/reports/'+eventid+'/type/'+report_name;
			promise = $http.get(url).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
			
		},
		getReport : function(eventid, type){
			var promise;
			var url= '/Taffy/index.cfm/reports/'+eventid+'/type/'+type;
			promise = $http.get(url).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
		},
		getFilteredReport : function(id, type){
			var promise;
			var url= '/Taffy/index.cfm/filteredreports/'+id+'/type/'+type;
			promise = $http.get(url).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;
		},
		getRegistration : function(regid){
			var promise;
			var url= '/Taffy/index.cfm/registrations/'+regid+'/summary/1';
			promise = $http.get(url).then(function(response){
				response = setBooleans(response);
				return response.data;
			});
			return promise;			
		},
		buildCSV : function(table){ 
            var csv = $(table).table2CSV({
                delivery: 'data'
            });
			$('#csvdata').value(csv);
			$('#csvform').submit();
		}
		,
			saveCustomReport : function(target_prices, target_activities, target_options, report_name, eventid){
				var promise;
				 var url = '/Taffy/index.cfm/customreports/' + $window.siteid + '/' + eventid;
					promise = $http.put(url, 
											{
												target_prices: target_prices,
												target_options : target_options,
												target_activities : target_activities,
												report_name : report_name,
												userid : ""}
									  )
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;
				
			}
		, 
			getAllEventData : function(eventid){
				var promise;
				 var url = '/Taffy/index.cfm/customreports/' + $window.siteid + '/' + eventid;
					promise = $http.post(url, {eventid: eventid})
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;
				
			}
		,
			getcustomreportss : function(report_name, eventid){
				var promise;
				 var url = '/Taffy/index.cfm/customreports/' + $window.siteid + '/' + eventid;
					promise = $http.get(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;

			},
			savecustomreports : function(type, report_name, targetid, userid, eventid){
				var promise;
				var url = '/Taffy/index.cfm/customreports/'+$window.siteid + '/' + eventid;
				var wrapped_customreports = {};
				wrapped_customreports.input_data = customreports;
				wrapped_customreports.input_data.type = type;
				wrapped_customreports.input_data.report_name = report_name;
				wrapped_customreports.input_data.userid = userid;
				wrapped_customreports.input_data.eventid = eventid;
				var input_data = JSON.stringify(wrapped_customreports);
				promise = $http.put(url, input_data).then(function(response){
					response = setBooleans(response);
					return response.data;
				});
				return promise;

			},
			deletecustomreports : function(reportid){
				var promise;
				var eventid = 0;
				var subevent = 0;
				 var url = '/Taffy/index.cfm/customreports/'+$window.siteid + '/0' + '?reportid=' + reportid;
					promise = $http.delete(url)
					 .then(function (response) {
						response = setBooleans(response);
						return response.data;
					});
				return promise;	

			}

		
    };

				  
		
	
	
}]);