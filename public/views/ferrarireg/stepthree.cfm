
<cfparam default="3" name="curstep">
<cfinclude template="stepSaver.cfm">
<cfparam name="input_struct.optiongroup" default="" >
<cfparam name="input_struct.option" default="" >
<cfparam name="input_struct.subevent" default="">
<cfloop from='0' to ='10' index='i'>
	<cfparam name="input_struct.optiongroup_#i#" default="" >
	<cfparam name="input_struct.option_#i#" default="" >
	<cfparam name="input_struct.subevent_#i#" default="">
</cfloop>

<cfparam name="session.reg_options[2].subevent" default='-1'>

<cfquery name="getChosenSubData" dbtype='query'>
	select * from rc.event_data.sub_data
	
</cfquery>
<cfparam default="false" name="reviewmode">
<cfif getChosenSubData.recordcount eq 0  and reviewmode neq "true">
	<script>
		$(function(){
			<cfif isdefined("url.goingback") and url.goingback eq 'true'>
				$("#prev_page_button_for_stepthree").click();
			<cfelse>
				$('#next_page_button_for_stepthree').click();
			</cfif>
		})	 
	</script>
<cfelse>

	<!---   
		This prevents the back button / reload page confirmation prompt to users.
	--->

	<cfset req = getHTTPRequestData()>
	<cfif req.method eq "POST" and reviewmode neq "true">
		<script>
			window.location.href = window.location.href;
		</script>
		<cfabort>
	</cfif>
	<script>
		$(function(){
			 $(' label.required').each(function(){
				 if($(this).find('.help-block').length ==0)
					 $(this).next().find('input,select').after('<div class="help-block with-errors"></div>');
			 })
			 $('.required_data_field').on('keyup', requiredChange);
		});
		function requiredChange(){
			var targid = $(this).attr('data-optiongroupid');
			if($(this).val() != '')
				$('#optiongroup' + targid).prop('checked', true);
			else
				$('#optiongroup' + targid).prop('checked', false);
		}
		$(function(){
			$('.sub_event_checkbox').on('change', function(){
				var targsub = $(this).attr('data-subeventid');
				if($(this).prop('checked')){
					$('#sub_event_options_' + targsub).show()
					.find('.wasRequired').removeClass('wasRequired').addClass('required')
							.next()
							.find('input,select').attr('required', 'true');
					
					
				}else{
					$('#sub_event_options_' + targsub).hide()
							.find('.required').removeClass('required').addClass('wasRequired')
							.next()
							.find('input,select').removeAttr('required');
					
				}
				$('.validated_form').validator()
			}).change();
		})
	</script>
</cfif>
<cfif reviewmode neq 'true'>
	<script>
		 $(function(){
			 $('.form-group.required').each(function(){
				 if($(this).find('.help-block').length ==0)
					 $(this).find('input,select').after('<div class="help-block with-errors"></div>');
			 })
		 });
		
	</script>
</cfif>

<cfparam name="request.runningTotal" default="0">

	<div class="" <cfif  getChosenSubData.recordcount eq 0 and reviewmode eq "true"> style="display: none !important;"</cfif> >
	<div class="row">
		<div class="col-md-12">
			<h2>Registration Options - Activities</h2>		
			<p>Select the activities you and/or your guests would like to participate in at thise event.</p>
		</div>
	</div> 
		<div class="panel panel-default">
			<form class="validated_form" method="post" action="?EventRegistrationaction=public:ferrarireg.stepfour&EventID=<cfoutput>#rc.eventid#</cfoutput>" role="form" data-toggle="validator">
				<div class="panel-body">
				
					<cfset guest ="">
					<cfset guestName = session.reg_options[2].full_name>	
					<div class="panel panel-default ">	
						<fieldset>		
							<cfinclude template="stepThreeOptions.cfm">
						</fieldset>
					</div>
				
					<cfloop from='0' to ="#session.reg_options[2].nonMemberGuests - 1#" index='i'>
						<cfset guest = i>
						<cfset guestLabel = i + 1>
						<cfset guestName = session.reg_options[2]['guest#i#first'] & " " & session.reg_options[2]['guest#i#last']>
						<div class="panel panel-default ">
							<fieldset>		
								<cfinclude template="stepThreeOptions.cfm">
							</fieldset>
						</div>
					</cfloop>
				</fieldset>
				<cfif reviewmode neq 'true'>
					<fieldset>
						<div class="form-group row">
							<div class="col-sm-6 pull-left">
								<button id="prev_page_button_for_stepthree" class="btn btn-primary" onclick="window.location.href = '?EventRegistrationaction=public:ferrarireg.steptwo&EventID=<cfoutput>#rc.eventid#</cfoutput>&goingback=true';  return false;">&lt;- Return to Previous Step</button>
							</div>

							<div class="col-sm-6 pull-right text-align-right">
								<button id="next_page_button_for_stepthree" class="btn btn-primary" type="submit">Proceed To Next Step -></button>
							</div>

						</div>
					</fieldset>
									</cfif>				
				</div>
			</form>
		</div>
					
</div>
	
	
	
		<script>
	
	function updateCheckbox(ele, optiongroupid){
		if($(ele).val() != '')
				$('#optiongroup' + optiongroupid).prop('checked', true);
		else
				$('#optiongroup' + optiongroupid).prop('checked', false);
	}
</script>
		

