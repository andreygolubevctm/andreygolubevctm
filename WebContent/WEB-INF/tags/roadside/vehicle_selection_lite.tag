<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="nonStandardRow" value="${name}_nonStandardRow" />
<c:set var="commercialRow" 	value="${name}_commercialRow" />
<c:set var="stateRow"  value="${name}_stateRow" />
<c:set var="paramState"		value="${param.state}" />

<%-- HTML --%>
<div id="vehicle-selection">
	<form:fieldset legend="Please tell us about your car">
		<form:row label="Year of manufacture">
			<field:vehicle_year xpath="${xpath}/year" required="true" className="${firstFour}"/>
		</form:row>
		<form:row label="Make of car">
			<field:make_select xpath="${xpath}/make" title="vehicle manufacturer" type="make" className="${firstFour}" required="true" />	
			<field:hidden xpath="${xpath}/makeDes"></field:hidden>
		</form:row>
		<form:row label="Is the car used for private and <br /> commuting purposes only?<br>(i.e. not commercial business use)" id="${commercialRow}" helpId="201">
		<field:array_radio xpath="${xpath}/vehicle/commercial"
						   required="true"
						   className="car_commercial" 
						   items="N=Yes,Y=No"
						   id="car_commercial"
						title="if anyone will use the car for private and commuting purposes"
						defaultValue="N"/>
		</form:row>
		<form:row label="Does the car have less than <br />250,000 kms on the odometer?" id="${odometerRow}" helpId="202">
			<field:array_radio xpath="${xpath}/vehicle/odometer"
							   required="true"
							   className="car_odometer" 
							   items="N=Yes,Y=No"
							   id="car_odometer"
						title="if the vehicle has less than 250,000 kilometres on the odomoter"
						defaultValue="N"/>
		</form:row>
		<form:row label="In which state do you use your car?" id="${stateRow}" className="hidden">
			<field:state_select xpath="roadside/riskAddress/state" title="State"  required="true" className="${firstFour}"/>	
		</form:row>			
				
	</form:fieldset>
	
	<div class="clear"></div>
		<a href="javascript:;" class="cancelbtn"><span>Cancel</span></a>
		<a href="javascript:;" class="updatebtn"><span>Update</span></a>
	<div class="clear"></div>
		
</div>



<%-- CSS --%>
<go:style marker="css-head">
</go:style>

<%-- JAVASCRIPT --%>
<go:script href="common/js/car/dialog_controller.js" marker="js-href" />
<go:script href="common/js/utils.js" marker="js-href" />

<go:script marker="onready">
	<%-- Case insensitive search for the state parameter --%>
	if(!$('#roadside_riskAddress_state option').val()){
		var error = true;
		$('#roadside_riskAddress_state option').each( function() {		
			if( ( String('${paramState}') != '' )  && ( String($(this).val()).toLowerCase() == String('${paramState}').toLowerCase() ) ) {
				$(this).attr('selected', 'selected');
				error = false;
			} else {
				$(this).removeAttr('selected');
			};
		});
		//if there is 'no match'
		if(error) {
			$('#roadside_vehicle_stateRow').removeClass('hidden');
		};	
	};
</go:script>