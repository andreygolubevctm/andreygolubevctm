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

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}_startDate_row">

		<form:row label="Type of Cover" id="${xpath}_coverType_row">
			<field:import_select xpath="${xpath}/coverType"
				required="true"
				title="the type of cover"
				url="/WEB-INF/option_data/home_contents_cover_type.html"/>
		</form:row>

		<form:row label="Start Date" id="${xpath}_startDate_row" helpId="500">
			<field:commencement_date xpath="${xpath}/startDate" required="true" title="start date for your policy"/>
		</form:row>

	</form:fieldset>

	<form:fieldset legend="Address" className="${className}" id="${name}_property_address_row">
		<group:address xpath="${xpath}/property/address" type=""/>
	</form:fieldset>

	<core:clear />
</div>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var CoverType = new Object();
	CoverType = {

		coverType: '',

		init: function(){

			<%-- Toggle fields in property feature depending on covertype select value --%>
			$('#${name}_coverType').on('change', function(){
				CoverType.coverType = $(this).val();
				CoverAmounts.toggleCoverAmountsFields();
				CoverAmounts.togglePersonalEffectsFields();
				<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY HOLLARD  --%>
<!-- 				PropertyFeature.toggleSecurityFeatures(); -->
				Summary.setVerticalName( CoverType.coverType.replace(" Cover", "").replace(" Only", "") );
				//Set the pageName
				Track.nextClicked($.address.parameter("stage"));

				var $propertyFeatures = $('.securityFeatures').parents('#home_property');
				if($propertyFeatures.length && this.value === "Home Cover Only") {
					$propertyFeatures.slideUp();
				} else {
					$propertyFeatures.slideDown();
				}
			});

			<%-- initialise page layout  --%>
			$('#${name}_coverType').trigger("change");

		}

	}
</go:script>

<go:script marker="onready">
	CoverType.init();
</go:script>