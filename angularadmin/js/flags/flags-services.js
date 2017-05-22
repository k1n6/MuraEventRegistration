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
		saveFlags : function (checked_boxes, use_flags){
			var promise;
			if(checked_boxes && use_flags && checked_boxes.length > 0 && use_flags.length > 0){
			 	var url = '/Taffy/index.cfm/flags';
				promise = $http.put(url, {flags: use_flags, objects : checked_boxes});
				return promise;
			}else{
				//nothing to save
			}
		}
		
		
	}
	
}]);