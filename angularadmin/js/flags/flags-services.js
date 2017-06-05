angular.module('eventsadmin')

.factory('Flags', ['$http', '$window', function($http, $window){
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
		
		
		
	
		getFlags : function (eventid){
			var promise;
			 var url = '/Taffy/index.cfm/flags';
                promise = $http.get(url);
			return promise;
		}
		,
		removeFlags : function (registrations, use_flags){
			var promise;
			if(registrations && use_flags && registrations.length > 0 && use_flags.length > 0){
			 	var url = '/Taffy/index.cfm/flags';
				promise = $http.delete(url, {flags: use_flags, objects : registrations});
				return promise;
			}else{
				//nothing to save
			}			 
			return promise;
		}
		,
		removeFlag : function (registrations, use_flags){
			var promise;
			var flags_arr = [];
			var regs_arr = [];
			regs_arr[0] = registrations;
			flags_arr[0] = use_flags;
			if(registrations && use_flags ){
			 	var url = '/Taffy/index.cfm/flags';
				promise = $http({
					url: url,
					method: 'DELETE',
					data: 
						{flags: flags_arr, objects : regs_arr}
					,
					headers: {
						"Content-Type": "application/json;charset=utf-8"
					}
				});

				return promise;
			}else{
				//nothing to save
			}			 
			return promise;
		}
		,
		saveFlags : function (registrations, use_flags){
			var promise;
			if(registrations && use_flags && registrations.length > 0 && use_flags.length > 0){
			 	var url = '/Taffy/index.cfm/flags';
				promise = $http.put(url, {flags: use_flags, objects : registrations});
				return promise;
			}else{
				//nothing to save
			}
		}
		
		
	}
	
}]);