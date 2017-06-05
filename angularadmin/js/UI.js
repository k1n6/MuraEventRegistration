angular.module('eventsadmin')

.service('modalService', ['$uibModal',
    function ($modal) {

        var modalDefaults = {
            backdrop: true,
            keyboard: true,
            modalFade: true,
            templateUrl: 'templates/modal.html'
        };

        var modalOptions = {
            closeButtonText: 'Close',
            actionButtonText: 'OK',
			 backdrop: true,
            headerText: 'Proceed?',
            bodyText: 'Perform this action?'
        };

        this.showModal = function (customModalDefaults, customModalOptions) {
            if (!customModalDefaults) 
				customModalDefaults = {};
            return this.show(customModalDefaults, customModalOptions);
        };

        this.show = function (customModalDefaults, customModalOptions) {
            //Create temp objects to work with since we're in a singleton service
            var tempModalDefaults = {};
            var tempModalOptions = {};

            //Map angular-ui modal custom defaults to modal defaults defined in service
            angular.extend(tempModalDefaults, modalDefaults, customModalDefaults);

            //Map modal.html $scope custom properties to defaults defined in service
            angular.extend(tempModalOptions, modalOptions, customModalOptions);

            if (!tempModalDefaults.controller) {
                tempModalDefaults.controller = function ($scope, $uibModalInstance) {
                    $scope.modalOptions = tempModalOptions;
                    $scope.modalOptions.ok = function (result) {
                        $uibModalInstance.close(result);
                    };
                    $scope.modalOptions.close = function (result) {
                        $uibModalInstance.dismiss('cancel');
                    };
                }
            }
			console.log(tempModalOptions);
            return $modal.open(tempModalDefaults).result;
        };

}])
.directive('confirmationNeeded', ['modalService', function (modalService) {
  return {
    priority: 1,
    terminal: true,
    link: function (scope, element, attr) {
      var msg = attr.confirmationNeeded || "Are you sure?";
      var clickAction = attr.ngClick;

      element.bind('click',function () {
			var modalOptions = {
				closeButtonText: 'Cancel',
			
				headerText: 'Confirm Action',
				bodyText: msg
			};

			modalService.showModal({}, modalOptions).then(function (result) {
				scope.$eval(clickAction)
			});
      });
    }
  };
}])
.factory('RegistrationDetails', ['$uibModal', 'reportsServices', 'Flags',  function($uibModal, reportsServices, Flags){
	return {
		
		showDetailsPopup : function(regid, $scope){
			reportsServices
			.getRegistration(regid)
			.then(function(d){
			    $scope.summary_html = d.data[0].summary_html;
				$scope.admin_notes = d.data[0].admin_notes;
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
							var $res = $($scope.summary_html);
							
							//this may break the visibility elements of the HTML which is rendered  as the script toggles visible elements
							//todo: debug this and make sure or fix it.
							$res.find("script").remove();
							var $e = $(document.getElementById($scope.useid)).html($res.html());
							var $x =  $(document.getElementById($scope.useid));
							
							$timeout(function(){
								//this tidies up our summary HTML
								$x.find('input, select').attr('disabled',true);
								$x.find('.help-block.with-errors').remove();
								$x.find('h2').next('p').remove();
							}, 100);
						}, 300);
						$scope.removeFlag = function (regid, flag) {
							console.log('b');
							Flags.removeFlag(regid, flag).then(function(){
								reportsServices
								.getRegistration(regid)		.then(function(d){
									$scope.flags = [];								
									for (x in d.flags)
										if (d.flags[x].reg_id == regid)
											$scope.flags.push(d.flags[x]);
								})
									
									
							});
						}
						
						
					}],
					windowClass: 'app-modal-window'
				});
				$scope.modalInstance = modalInstance;
			});
			
			
		}
	}
	
	
}])
.directive('ngConfirmClick', [
  function(){
    return {
      priority: -1,
      restrict: 'A',
      link: function(scope, element, attrs){
        element.bind('click', function(e){
          var message = attrs.ngConfirmClick;
          if(message && !confirm(message)){
            e.stopImmediatePropagation();
            e.preventDefault();
          }
        });
      }
    }
  }
])

.factory('SimplePopup', ['$uibModal', 'reportsServices' , 'modalService',  function($uibModal, reportsServices, modalService){
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
		showSimplePopup : function(title, body){
			if(!title)
				title = "";
			
			if(!body)
				body = 'default body';
			
			var modalOptions = {
				closeButtonText: 'Ok',
				actionButtonText: '',
				headerText: title,
				templateUrl: 'templates/blank-simple.html',
				bodyText: body
			};

			modalService.showModal({templateUrl: 'templates/blank-simple.html'}, modalOptions);
			
		}
	}
	
	
}])