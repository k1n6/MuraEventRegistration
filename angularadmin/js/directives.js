angular.module('eventsadmin')
.directive("optionoractivityname", function(){
	
	return{
		restrict: 'A',
		templateUrl: 'templates/optionoractivityname.html',
		scope: {
			eventid : '=eventid',
			subevent : '=subevent'
		}
	}
})
.directive("singleeventedit", function(){
	
	return{
		restrict: 'A',
		templateUrl: 'templates/single-event.html',
		scope: {
			event : '=event'
		}
	}
})
.directive("eventpricelist", function(){
	
	return{
		restrict: 'A',
		templateUrl: 'templates/eventPrices.html'
		
	}
})