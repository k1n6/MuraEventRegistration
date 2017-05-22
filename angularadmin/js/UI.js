angular.module('eventsadmin')

.factory('RegistrationDetails', ['$uibModal', 'reportsServices', function($uibModal, reportsServices){
	return {
		
		showDetailsPopup : function(regid, $scope){
			reportsServices
			.getRegistration(regid)
			.then(function(d){
			    $scope.summary_html = d.data[0].summary_html;
			    $scope.flags = [];
			    $scope.reg_id = regid;
			    for (x in d.flags)
			        if (d.flags[x].reg_id == regid)
			            $scope.flags.push(d.flags[x]);
				var x = new Date();
				$scope.useid = 'modalid' + x.getTime();
				var modalInstance = $uibModal.open({
					templateUrl: 'templates/registrationDetails.html',
					scope: $scope,
					controller : ['$scope', '$timeout',  function($scope, $timeout){
						
						$timeout(function(){
							var $e = $(document.getElementById($scope.useid)).html($scope.summary_html);
							$timeout(function(){
								//this tidies up our summary HTML
								$e.find('input, select').attr('disabled',true);
								$e.find('.help-block.with-errors').remove();
								$e.find('h2').next('p').remove();
							}, 100);
						}, 300);
						$scope.removeFlag = function (flag, regid) {

						}
						
						
					}],
					windowClass: 'app-modal-window'
				});
				$scope.modalInstance = modalInstance;
			});
			
			
		}
	}
	
	
}])
.factory('SimplePopup', ['$uibModal', 'reportsServices' , function($uibModal, reportsServices){
	return {
		
		showPopup : function(popupcontents){
			var thisscope = {};
			thisscope.popupcontents = popupcontents;
			var modalInstance = $uibModal.open({
				templateUrl: 'templates/registrationDetails.html',
				scope: thisscope
			});
			
		}
		,
		showSimplePopup : function(popupcontents){
			var thisscope = {};
			thisscope.popupcontents = popupcontents;
			var modalInstance = $uibModal.open({
				templateUrl: 'templates/blank.html',
				scope: thisscope
			});
			
		}
	}
	
	
}])