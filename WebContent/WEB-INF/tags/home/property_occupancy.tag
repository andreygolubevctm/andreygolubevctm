<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Select box built comma separated values."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"
	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"
	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"
	description="title of the select box"%>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="xpathOwnProperty" value="${xpath}/ownProperty" />
<c:set var="nameOwnProperty" value="${go:nameFromXpath(xpathOwnProperty)}" />

<c:set var="xpathWhenMovedInYear" value="${xpath}/whenMovedIn/year" />
<c:set var="nameWhenMovedInYear" value="${go:nameFromXpath(xpathWhenMovedInYear)}" />

<c:set var="xpathWhenMovedInMonth" value="${xpath}/whenMovedIn/month" />
<c:set var="nameWhenMovedInMonth" value="${go:nameFromXpath(xpathWhenMovedInMonth)}" />

<c:set var="xpathPrincipalResidence" value="${xpath}/principalResidence" />
<c:set var="namePrincipalResidence" value="${go:nameFromXpath(xpathPrincipalResidence)}" />

<%-- Use the server date to discourage the user from doing naughty things --%>
<c:set var="currentYear"
	value="<%=Calendar.getInstance().get(Calendar.YEAR)%>" />

<c:set var="items" value="=Please Select...,${currentYear} = This Year (${currentYear})" />
<c:set var="items"
	value="${items},${currentYear - 1}=Last Year (${currentYear - 1})" />

<c:forEach var="num" begin="2" end="5" step="1">
	<c:set var="items"
		value="${items},${currentYear - num}=${num} Years Ago (${currentYear - num})" />
</c:forEach>

<c:set var="items"
	value="${items},${currentYear - 6}=More than 5 years,NotAtThisAddress=Not yet living at this address" />


<form:fieldset legend="Occupancy" className="${className}" id="${name}">
	<form:row label="Do you own the home?" helpId="502">
		<field:array_radio xpath="${xpathOwnProperty}" className="ownProperty pretty_buttons"
			required="true" items="Y=Yes,N=No" title="if you own the home" />
	</form:row>

	<form:row label="Is it your principal place of residence?" helpId="503">
		<field:array_radio xpath="${xpathPrincipalResidence}" className="principalResidence pretty_buttons"
			required="true" items="Y=Yes,N=No" title="if this is your principal place of residence" />
	</form:row>

	<div class="howOccupied">
		<form:row label="How is the home occupied?">
			<field:import_select xpath="${xpath}/howOccupied"
				required="true"
				title="how the home is occupied"
				url="/WEB-INF/option_data/occupied_type.html"/>
		</form:row>
	</div>

	<div class="whenMoveIn">
		<form:row label="When did you move into the home?">
			<field:array_select
				className="left"
				items="${items}"
				xpath="${xpathWhenMovedInYear}"
				title="when you moved into the home"
				required="true" />

			<field:array_select
				className="left"
				items=""
				xpath="${xpathWhenMovedInMonth}"
				title="the month you moved into the home"
				required="true"
				helpId="504"/>
		</form:row>
	</div>

	<core:clear />
</form:fieldset>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	var PropertyOccupancy = new Object();
	PropertyOccupancy = {

		principalResidence: false,

		months: ["January","February","March","April","May","June","July","August","September","October","November","December"],
		currentYear: ${currentYear},
		currentMonth: <%=Calendar.getInstance().get(Calendar.MONTH) + 1%>, <%-- Use the server date to discourage the user from doing naughty things --%>

		init: function(){

			$('#${nameWhenMovedInYear}').on('change', function() {
				PropertyOccupancy.yearSelected();
			});

			$('input[name=${name}_ownProperty], #${name}_howOccupied').on('change', function() {
				PropertyOccupancy.togglePropertyOccupancyFields();
			});

			$('input[name=${name}_principalResidence]').on('change', function() {
				PropertyOccupancy.togglePropertyOccupancyFields();
				PolicyHolder.togglePolicyHolderFields();
				CoverAmounts.togglePersonalEffectsFields();
			});

			$('input[name=${name}_occupiedDuringWorkHours]').on('change', function(){
				PropertyOccupancy.toggleOccupiedRowVisibility();
			});

			$('input[name=${name}_currentlyOccupied]').on('change', function(){
				PropertyOccupancy.toggleOccupiedStartDateRowVisibility();
			});

			PropertyOccupancy.yearSelected();
			PropertyOccupancy.togglePropertyOccupancyFields();
			PropertyOccupancy.toggleOccupiedRowVisibility();
			PropertyOccupancy.toggleOccupiedStartDateRowVisibility();

		},

		togglePropertyOccupancyFields: function() {

			var ownProperty = $('input:radio[name=${nameOwnProperty}]:checked').val();
			var howOccupied =  $('#${name}_howOccupied').find('option:selected').val();
			var principalResidence = $('input:radio[name=${namePrincipalResidence}]:checked').val();

			if(principalResidence == "Y"){
				PropertyOccupancy.principalResidence = 'Y';
			} else {
				PropertyOccupancy.principalResidence = 'N';
			}

			<%-- if property not owned, deselect and remove the owner occupancy options --%>
<!-- 			if( ownProperty == 'N' ){ -->
<!-- 				if(howOccupied == "Owner Occupied" || howOccupied == "Owner Occupied and sub-let"){ -->
<!-- 					$('#${name}_howOccupied').val(''); -->
<!-- 				} -->
<!-- 				$('#${name}_howOccupied option[value="Owner Occupied"]').hide(); -->
<!-- 				$('#${name}_howOccupied option[value="Owner Occupied and sub-let"]').hide(); -->
<!-- 			} else { -->
<!-- 				$('#${name}_howOccupied option[value="Owner Occupied"]').show(); -->
<!-- 				$('#${name}_howOccupied option[value="Owner Occupied and sub-let"]').show(); -->
<!-- 			} -->

			<%-- show move in date field only if it is their main residence --%>
			if(ownProperty == "Y" && PropertyOccupancy.principalResidence == "Y"){
				$('.howOccupied').slideUp();
				$('.whenMoveIn').slideDown();
			}
			else if(ownProperty == "N" && PropertyOccupancy.principalResidence == "Y"){
				$('.howOccupied').slideUp();
				$('.whenMoveIn').slideDown();
			}
			else if(ownProperty == "Y" && PropertyOccupancy.principalResidence == "N"){
				$('.howOccupied').slideDown();
				$('.whenMoveIn').slideUp();
			} else {
				$('.howOccupied').slideUp();
				$('.whenMoveIn').slideUp();
			}

			PolicyHolder.togglePolicyHolderFields();
			CoverAmounts.togglePersonalEffectsFields();
		},

		yearSelected: function() {
			var selectedMonth = $('select[name="${nameWhenMovedInMonth}"]').val();
			var selectedYear = $('select[name="${nameWhenMovedInYear}"]').val();

			var monthField = $('#${nameWhenMovedInMonth}');
			var monthHelpId = $('#help_504');
			var numberOfMonths = 12;

			monthField.empty();

			monthField.append($('<option>', { value : "" }).text("Please Select..."));

			if(selectedYear == PropertyOccupancy.currentYear) {
				numberOfMonths = PropertyOccupancy.currentMonth;
			}

			if(selectedYear >= (PropertyOccupancy.currentYear - 2)) {
				monthField.slideDown();
				monthHelpId.slideDown();
				for(var i = 1; i <= numberOfMonths ; i++) {
					monthField.append($('<option>', { value : i }).text(PropertyOccupancy.months[i-1]));
				}
				if(selectedMonth <= PropertyOccupancy.numberOfMonths) {
					$('select[name="${nameWhenMovedInMonth}"]').val(selectedMonth);
				} else {
					$('select[name="${nameWhenMovedInMonth}"]').val("");
				}
			} else {
				monthField.slideUp();
				monthHelpId.slideUp();
			}
		},

		toggleOccupiedRowVisibility: function(){
			if( $('input[name=${name}_occupiedDuringWorkHours]:checked').val() == "Y" ){
				$('#${name}_occupied_row').slideDown();
			} else {
				$('#${name}_occupied_row').slideUp();
			}
		},

		toggleOccupiedStartDateRowVisibility: function(){
			if( $('input[name=${name}_currentlyOccupied]:checked').val() == "Y" ){
				$('.occupStartDate').slideDown();
			} else {
				$('.occupStartDate').slideUp();
			}
		},
	};

</go:script>

<go:script marker="onready">
	PropertyOccupancy.init();
</go:script>
