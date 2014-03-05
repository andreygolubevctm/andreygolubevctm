<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Business Activity group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"
	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"
	description="title of the select box"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<%--<c:set var="value" value="${data[xpath]}" /> --%>

<div class="${className}">

	<form:fieldset legend="Business Activity" className="${className}" id="${name}">

		<form:row label="Is there any business activity conducted from the home?" id="${name}_conducted_row">
			<field:array_radio xpath="${xpath}/conducted"
				required="true"
				className="pretty_buttons"
				title="if there is any business activity"
				items="Y=Yes,N=No"
				id="" />
		</form:row>

		<div class="businessType">
			<form:row label="What type of business is it?" id="${name}_businessType_row">
				<field:import_select xpath="${xpath}/businessType"
					required="true"
					title="the type of business activity"
					url="/WEB-INF/option_data/business_type.html"/>
			</form:row>
		</div>

		<div class="businessRooms">
			<form:row label="How many rooms are used for business?" id="${name}_rooms_row">
				<field:array_select xpath="${xpath}/rooms"
					required="true"
					title="how many rooms are used for business"
					items="=Please select...,1=1,2=2,3=3,4=4,5=5,6=6,7=7+"
					/>
			</form:row>
		</div>

		<div class="hasEmployees">
			<form:row label="Are there any employees (other than household members) who work at the home?" id="${name}_employees_row">
				<field:array_radio xpath="${xpath}/employees"
					required="true"
					className="pretty_buttons"
					title="if there any other employees (other than household members) who work at the home"
					items="Y=Yes,N=No" />
			</form:row>
		</div>

		<div class="dayCareChildren">
			<form:row label="How many children are cared for at any one time?" id="${name}_children_row">
				<field:array_select
					xpath="${xpath}/children"
					required="true"
					title="how many children are cared for at any one time"
					items="=Please select...,1=1,2=2,3=3,4=4,5=5,6=6,7=7+"
					/>
			</form:row>
		</div>

		<div class="registeredDayCare">
			<form:row label="Is the day care registered with an organisation?" id="${name}_registeredDayCare_row">
				<field:array_radio xpath="${xpath}/registeredDayCare"
					required="true"
					className="pretty_buttons"
					title="if the day care is registered with an organisation"
					items="Y=Yes,N=No" />
			</form:row>
		</div>

		<div class="employeeAmount">
			<form:row label="How many employees?" id="${name}_employeeAmount_row">
				<field:array_select
					xpath="${xpath}/employeeAmount"
					required="true"
					title="how many employees work at the home"
					items="=Please select...,1=1,2=2,3=3,4=4,5=5,6=6,7=7+"
					/>
			</form:row>
		</div>

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var BusinessActivity = new Object();
	BusinessActivity = {

		init: function(){

			<%-- Event Handling --%>
			$('input[name=${name}_conducted]').on('change', function(){
				BusinessActivity.toggleBusinessType();
			});

			$('#${name}_businessType').on('change', function() {
				BusinessActivity.toggleBusinessFields();
			});

			$('input[name=${name}_employees]').on('change', function(){
				BusinessActivity.toggleEmployeeAmount();
			});

			<%-- Trigger for preload --%>
			BusinessActivity.toggleBusinessFields();
			BusinessActivity.toggleEmployeeAmount();
			BusinessActivity.toggleBusinessType();

		},

		<%-- Visibility Toggles --%>
		toggleBusinessFields: function(businessType){

			var businessType = $('#${name}_businessType').find('option:selected').text().toLowerCase();

			if ( businessType == 'home office') {
				$('.businessRooms').slideDown();
				$('.hasEmployees').slideDown();
				$('.dayCareChildren').slideUp();
				$('.registeredDayCare').slideUp();
				BusinessActivity.toggleEmployeeAmount();
			} else if ( businessType == 'surgery/consulting rooms') {
				$('.businessRooms').slideDown();
				$('.hasEmployees').slideDown();
				$('.dayCareChildren').slideUp();
				$('.registeredDayCare').slideUp();
				BusinessActivity.toggleEmployeeAmount();
			} else if ( businessType == 'day care') {
				$('.dayCareChildren').slideDown();
				$('.registeredDayCare').slideDown();
				$('.businessRooms').slideUp();
				$('.hasEmployees').slideUp();
				$('.employeeAmount').slideUp();
			} else {
				$('.businessRooms').slideUp();
				$('.hasEmployees').slideUp();
				$('.employeeAmount').slideUp();
				$('.dayCareChildren').slideUp();
				$('.registeredDayCare').slideUp();
			}

		},

		toggleBusinessType: function(){

			if( $('input[name=${name}_conducted]:checked').val() == 'Y' ){
				$('.businessType').slideDown();
				BusinessActivity.toggleBusinessFields();
			} else {
				BusinessActivity.hideBusinessActivityFields();
			}

		},

		toggleEmployeeAmount: function(){

			if( $('input[name=${name}_employees]:checked').val() == 'Y' ){
				$('.employeeAmount').slideDown();
			} else {
				$('.employeeAmount').slideUp();
			}

		},

		hideBusinessActivityFields: function(){
			$('.businessType').slideUp();
			$('.businessRooms').slideUp();
			$('.hasEmployees').slideUp();
			$('.employeeAmount').slideUp();
			$('.dayCareChildren').slideUp();
			$('.registeredDayCare').slideUp();
		}

	}
</go:script>

<go:script marker="onready">
	BusinessActivity.init();
</go:script>