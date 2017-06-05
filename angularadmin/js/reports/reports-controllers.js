angular.module('eventsadmin')
	
.controller('singleReportController', 
			['reportsServices','$scope','$state','$stateParams', '$element', '$timeout','$compile', 'RegistrationDetails', '$uibModal', 'Flags', 'SimplePopup', 
			function (reportsServices,  $scope, $state, $stateParams, $element, $timeout, $compile, RegistrationDetails, $uibModal, Flags, SimplePopup){
	
	$scope.reportHTML = "";
	$scope.data = {};
	$scope.test = 'test message';
	$scope.selectedTransactions = [1,2,3];
	$scope.underpayment 	= 1;
	$scope.overpayment 		= 2;
	$scope.exactlypayment 	= 3;
	$scope.filteredReports = {};
	$scope.loading = true;
	console.log($stateParams);
	
				
			
	$scope.toggleFilterFlag = function(flag, $e){
		if(typeof $scope.filteredReports[flag] == 'undefined')
			$scope.filteredReports[flag] = 1;
		else
			delete $scope.filteredReports[flag];
		
		$($e.target).toggleClass('btn-primary');
		
		if($.fn.dataTableExt.afnFiltering.length == 0)
			$.fn.dataTableExt.afnFiltering.push(
				function( oSettings, aData, iDataIndex ) {
					var value = aData[8];
					var valueArr = value.split('|');
					
					if(Object.keys($scope.filteredReports).length == 0){
						
						return true;
					}else{
						for(i in $scope.filteredReports){
							var matcher = function(d){
								if (d == i)
									return true;
								else
									return false;
							}
							if(typeof valueArr.find(matcher) != 'undefined'){
								
								return true;
							}

						}
					}
					
					return false;
				}
			);
			$('.tablesorter').DataTable().draw();
			setTimeout(function(){$('.tablesorter').DataTable().draw();}, 250);

		/*
		var filteredData = $('.tablesorter').DataTable()
			.column( 8 )
			.data()
			.filter( function ( value, index ) {
				if(Object.keys($scope.filteredReports).length == 0){
					console.log("no flags selected returning true");
					return true;
				}else{
					for(i in $scope.filteredReports){
						if(value.indexOf('>' + i + '<') != -1){
							console.log(i + ":flag found");
							return true;
						}
							
					}
				}
				console.log("no flag found");
				return false;
			} );
		*/

	}
	
	$scope.addPayment = function(source_registration){
		$state.go('eventDetails.reporting.payment', {payment_id: -1, targetRegistration: source_registration});
	}
	$scope.addFlags = function(){
			
			var searchIDs = $('input.action_checkbox:checked').map(function(){

			  return $(this).val();

			});
			
			$scope.checked_boxes = searchIDs.get();
			$scope.flags = [];
			$scope.message="";
			$scope.selected_flags = [];
			$scope.extra_flag = "";
			if($scope.checked_boxes.length == 0){
				//user needs to select one or more registrations before adding flags
				 
					SimplePopup.showSimplePopup('Select A Registration First', 'Select registrations by checking their coresponding checkboxes under the ACTION column.');
					
				
			}else{
				$scope.modalInstance = $uibModal.open({
					templateUrl: 'templates/registration-flags.html',
					scope: $scope,
					controller : ['$scope', '$timeout', '$http',  function($scope, $timeout, $http){
						Flags.getFlags().then(function(response){
							$scope.flags = response.data;
						
						});
						$scope.saveFlags = function(checked_boxes, flags, extra_flag){
							var use_flags = [];
							for(d in flags)
								use_flags[d] = flags[d];

							if(extra_flag)
									use_flags.push(extra_flag);


							if(use_flags.length == 0){
								$scope.message="Please select at least one flag or enter a new flag.";
								return;
							}
							Flags.saveFlags(checked_boxes, use_flags).then(function(resp){
								if(resp){
									$scope.modalInstance.close('');
									$scope.updateReportData();
								}

							});
						}
					}],
					windowClass: 'app-modal-window narrow-dialog'
				});
			}
	}
	//this grabs the HTML from the server, loads in the data, loads in the HTML and then compiles it.
	$scope.updateReportData = function(){

		$scope.loading = true;
		var promise = reportsServices.getReport($stateParams.eventid, '_' + $stateParams.type + '_');
		promise.then(function(d){
			$element.find('.report-htmlclass').html(d.REPORTHTML);

			for(i in d.RETURNDATA)
				$scope.data[i] = d.RETURNDATA[i];

			$timeout(function(){
				//$compile($element)($scope);
				$compile($element.find('.report-htmlclass'))($scope);
				$scope.loading = false;
			}, 10)
		});
	}
	$scope.updateReportData();
	console.log('Reports Controller Completed'); 
	
	$scope.viewRegistration = function(regid){
		RegistrationDetails.showDetailsPopup(regid, $scope);
	}
	
	$scope.updateFooter = function(){
		$timeout(function(){
			$(".tablesorter").DataTable().draw();	
		}, 50)
		
	}
	$scope.FilterTo = function(mode, target){
		console.log('filter to: ' + mode + '/ ' + target);
		var promise = reportsServices.getFilteredReport(target, mode + '-filter');
		promise.then(function(d){
			$element.find('.report-htmlclass').html('').append(d.REPORTHTML);
		
			for(i in d.RETURNDATA)
				$scope.data[i] = d.RETURNDATA[i];

			$timeout(function(){
				//$compile($element)($scope);
				$compile($element.find('.report-htmlclass'))($scope);

			}, 10)
		});
		
		
	}
}])



.controller('customreportsListController', ['$element', '$scope','$timeout', '$compile', 'reportsServices', '$stateParams', '$state', 'SimplePopup','$uibModal', '$window',
												function($element, $scope, $timeout, $compile, reportsServices, $stateParams, $state, SimplePopup, $uibModal, $window){
	$scope.customreportss = [];
	$scope.eventid = $stateParams.eventid;
	$scope.subevent = $stateParams.subevent;
	$scope.data = {};
	$scope.loading = true;

	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}

	
	
	$scope.editcustomreport = function (reportid){
		
	}
	$scope.deletecustomreports = function(reportid, $event){
		reportsServices.deletecustomreports(reportid).then(function(res){
			data = reportsServices.getcustomreportss('',$scope.eventid);
			data.then(function(resp){
				$scope.customreportss = resp;
			});
		});
		
		$event.stopPropagation();
		$event.preventDefault();
		
	}
	$scope.displayReport = function(report_name){
		var promise = reportsServices.getCustomReportoutput($scope.eventid, report_name);
		promise.then(function(d){
			//$element.find('.single-custom-report-content').html('').append(d.REPORTHTML);
			
			$scope.contents = d.REPORTHTML;
			
			var x = new Date();
			$scope.useid = 'modalid' + x.getTime();
			$scope.title = 'Report Details';
			var modalInstance = $uibModal.open({
				templateUrl: 'templates/blank.html',
				scope: $scope,
				controller : ['$scope', '$timeout',  function($scope, $timeout){
					$timeout(function(){
						
						var $e = $(document.getElementById($scope.useid)).html($scope.contents);
						$timeout(function(){
							//$compile($element)($scope);
							$compile($(document.getElementById($scope.useid)))($scope);

						}, 10);

						$window.updateTables();
					}
					, 500);
					
				}],
				windowClass: 'app-modal-window'
			});
			$scope.modalInstance = modalInstance;

			return;
			for(i in d.RETURNDATA)
				$scope.data[i] = d.RETURNDATA[i];

			$timeout(function(){
				//$compile($element)($scope);
				$compile($element.find('.report-htmlclass'))($scope);
					$timeout(function(){
								$('.csv-button').remove();

								$('table.hascsv').each(function () {
									var $table = $(this);

									var $button = $("<button type='button' class='btn btn-primary csv-button'>");
									$button.text("Export to spreadsheet");

									$button.insertAfter($table.parent());
									$button.click(function () {

										window.buildCSV($(this).prev().find('table.hascsv'));
									});
									$(".tablesorter").tablesorter( );
								});



							}, 1000)
			}, 10)
		});
		
	}
	data = reportsServices.getcustomreportss('', $stateParams.eventid);
	data.then(function(resp){
		$scope.customreportss = resp;
		$scope.loading = false;
	});
}])

.controller('singlecustomreportsController', ['$scope', 'reportsServices', '$stateParams', '$state', function($scope, reportsServices, $stateParams, $state){
	$scope.customreportss = [];
	//we need to figure out / decide if we are viewing a main events options for an acitivities events
	$scope.eventid = $stateParams.eventid;
	$scope.reportid = $stateParams.reportid;
	$scope.subevent = $stateParams.subevent;
	
	
	if(typeof $scope.subevent == 'undefined' || $scope.subevent == null){
		$scope.subevent = -1;
		$stateParams.subevent = -1;
	}
	
	//here we load our form variables
	$scope.customreportsFields = 	[];
	reportsServices.getFormData('p_eventregistration_customreportss').then(function(d){
		$scope.customreportsFields = d;
	});
	

	
	$scope.updatecustomreportsData= function(){

			data = reportsServices.getcustomreportss($scope.eventid, $scope.reportid, $scope.subevent );
			data.then(function(resp){
				$scope.customreportss = resp;
			});
		}
	$scope.updatecustomreportsData();
	
	/*
	$scope.savecustomreports = function(customreports){
		
		customreports.reportid = $scope.reportid;
		customreports.subevent = $scope.subevent;
		customreports.mainevent = $scope.eventid;
		
		reportsServices.savecustomreports($scope.eventid, customreports.reportid, customreports, customreports.subevent ).then(function(d){

				$state.go('eventDetails.reporting.customreports', 
					
						  {reload: true}
						);
		});
	};	
	*/
	
}])

		
.controller('customReportsController', ['reportsServices', '$scope', '$state', '$stateParams', function(reportsServices, $scope, $state, $stateParams){
	//this is the controller for parent view ofthe custom reports screen
	
	$scope.test = 'true';
	$scope.eventData = {};
	$scope.report_name = "";
	//selected report options
	
	$scope.selectedOptionGroups = [];
	$scope.selectedPrices = [];
	$scope.selectedActivities = [];
	$scope.selectedFlags = [];
	$scope.addReportFormVisible = false;
	
	var promise = reportsServices.getAllEventData($stateParams.eventid);
	promise.then(function(d){
		
		$scope.eventData = d;
	});
	$scope.addNewReportForm = function(){
		$scope.addReportFormVisible = true;
	}
	$scope.buildReport = function(){
		$scope.addReportFormVisible = false;
		if($scope.report_name != "")
			$scope.saveCustomReport();
	}
	$scope.checkSubs = function(subeventid){
		var targetOptiongroups = [];
		var oneChecked = false;
		$('.checklist-' + subeventid).each(function(){
			//console.log($(this).prop("checked"));
			if($(this).prop("checked"))
				oneChecked = true;
			targetOptiongroups.push($(this).val());
		});
		//console.log($scope.selectedOptionGroups);
		if(oneChecked){
			//console.log('unchecking');
			//we need to uncheck them all
			for (i in targetOptiongroups){
				var target = parseInt(targetOptiongroups[i]);
				if($scope.selectedOptionGroups.indexOf(target) != -1){
					delete $scope.selectedOptionGroups[$scope.selectedOptionGroups.indexOf(target)];
				}
			}
		}else{
			//console.log('checking');
			// we need to check them all
			for (i in targetOptiongroups){
				var target = parseInt(targetOptiongroups[i]);
				if($scope.selectedOptionGroups.indexOf(target) == -1){
					$scope.selectedOptionGroups.push(parseInt(target));
				}
			}
		}
		//console.log($scope.selectedOptionGroups);
	}
	$scope.checkFlags = function(flag){
		var targetFlags = [];
		var oneChecked = false;
		$('.custom_flag').each(function(){
			//console.log($(this).prop("checked"));
			if($(this).prop("checked"))
				targetFlags.push($(this).val());
		});
		$scope.selectedFlags = targetFlags;
		
	}
	$scope.checkPrices = function(){
		var targetPrices = [];
		var oneChecked = false;
		$('.priceChecklist').each(function(){
			//console.log($(this).prop("checked"));
			if($(this).prop("checked"))
				oneChecked = true;
			targetPrices.push($(this).val());
		});
		//console.log($scope.selectedPrices);
		if(oneChecked){
			//console.log('unchecking');
			//we need to uncheck them all
			for (i in targetPrices){
				var target = parseInt(targetPrices[i]);
				if($scope.selectedPrices.indexOf(target) != -1){
					delete $scope.selectedPrices[$scope.selectedPrices.indexOf(target)];
				}
			}
		}else{
			//console.log('checking');
			// we need to check them all
			for (i in targetPrices){
				var target = parseInt(targetPrices[i]);
				if($scope.selectedPrices.indexOf(target) == -1){
					$scope.selectedPrices.push(parseInt(target));
				}
			}
		}
		//console.log($scope.selectedPrices);
	}
	$scope.saveCustomReport = function(){
		var promise = reportsServices.saveCustomReport($scope.selectedPrices, $scope.selectedActivities, $scope.selectedOptionGroups, $scope.report_name,
													   $stateParams.eventid, $scope.selectedFlags);
		
		promise.then(function(d){
			
			$state.go('eventDetails.reporting.customreports', {eventid: $stateParams.eventid}, {reload: true});			
		})
	}
}])

.controller('reportsController', ['reportsServices','$scope','$state','$stateParams', function (reportsServices, $scope, $state, $stateParams){

	$scope.eventid = $stateParams.eventid;
	
	$scope.setActiveTab = function( index ){
	
		localStorage.setItem("CurrentActiveReport", parseInt(index));
		$scope.activeReport = index;
		activeReport = index;
		cur_active_report = index;
		
	};
	
	$scope.getStoredActive = function(){
		var cur_active_report = localStorage.getItem("CurrentActiveReport");
		if (cur_active_report != null){
			$scope.setActiveTab(parseInt(cur_active_report));
		}else{
			$scope.setActiveTab(parseInt(0));
		}
	};
	
	
}])

