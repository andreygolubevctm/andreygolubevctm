<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Property description group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the panel"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<go:style marker="css-head">
	.bestDescribesHome{
		display: none;
	}
	.heritage{
		display: none;
	}
	.mortgagee,
	.borderedBy{
		display: none;
	}
</go:style>

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">

		<form:row label="What type of property is the home?">
			<field:import_select xpath="${xpath}/propertyType"
				required="true"
				title="what type of property the home is"
				url="/WEB-INF/option_data/property_type.html"/>
		</form:row>

		<div class="bestDescribesHome">
			<form:row label="Which best describes the home?">
				<field:import_select xpath="${xpath}/bestDescribesHome"
					url="/WEB-INF/option_data/describe_home_type.html"
					title = "what type of property best describes the home"
					required="true" />
			</form:row>
		</div>

<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY HOLLARD  --%>
<%-- 		<div class="numberStoreys"> --%>
<%-- 			<form:row label="Number of storeys?"> --%>
<%-- 				<field:array_select --%>
<%-- 					xpath="${xpath}/numberStoreys" --%>
<%-- 					required="true" --%>
<%-- 					items="=Please select...,1=1,2=2,3=3+" --%>
<%-- 					title="how many storeys has the home"/> --%>
<%-- 			</form:row> --%>
<%-- 		</div> --%>

		<form:row label="What is the main construction material for the walls?" helpId="506">
			<field:import_select xpath="${xpath}/wallMaterial"
				required="true"
				title="the main construction material for the walls"
				url="/WEB-INF/option_data/property_wall_material.html"/>
		</form:row>

		<form:row label="What is the main construction material for the roof?">
			<field:import_select xpath="${xpath}/roofMaterial"
				required="true"
				title="the main construction material for the roof"
				url="/WEB-INF/option_data/property_roof_material.html"/>
		</form:row>

		<form:row label="What year was the home built?">
			<field:import_select xpath="${xpath}/yearBuilt"
				required="true"
				title="what year the home was built"
				url="/WEB-INF/option_data/property_built_year.html"/>
		</form:row>

		<div class="heritage">
			<form:row label="Is the home heritage listed?" helpId="505">
				<field:array_radio
					xpath="${xpath}/isHeritage"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No"
					title="if the home is heritage listed?"/>
			</form:row>
		</div>

		<form:row label="Is the home part of a body corporate/strata title complex?">
				<field:array_radio xpath="${xpath}/bodyCorp"
					title="if the home is part of a body corporate/strata title complex"
					required="true"
					className="pretty_buttons"
					items="Y=Yes,N=No" />
			</form:row>

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="onready">

	var PropertyDescription = new Object();
	PropertyDescription = {

		init: function(){

			$('#${name}_propertyType').on('change', function()
			{
				PropertyDescription.toggleBestDescribesHome();
			});

			PropertyDescription.toggleBestDescribesHome();

		},

		toggleBestDescribesHome: function(){

			if( $('#${name}_propertyType').find('option:selected').text().toLowerCase() == 'other') {
				$('.bestDescribesHome').slideDown();
			} else {
				$('.bestDescribesHome').slideUp();
			}

		}

	}
	var PropertyCondition = new Object();
	PropertyCondition = {

		init: function(){

			$('#${name}_yearBuilt').on('change', function()
			{
				PropertyCondition.toggleHeritage();
			});

			PropertyCondition.toggleHeritage();

		},

		toggleHeritage: function(){

			if( parseInt( $('#${name}_yearBuilt').find('option:selected').val() ) <= 1914 ) {
				$('.heritage').slideDown();
			} else {
				$('.heritage').slideUp();
			}

		},

		limitYearBuilt: function(moveInYear){

			$('#${name}_yearBuilt option[value=2011]').show();

			if(!isNaN(moveInYear) && moveInYear < 2011){
				$('#${name}_yearBuilt option[value=2011]').hide();
			}
		}
	}

	$.validator.addMethod("yearBuiltAfterMoveInYear",
		function(value, element, param) {

			var moveInYear = $(".whenMoveIn select").first().find(":selected").val();
			if( !isNaN(moveInYear) && moveInYear < $(element).val() && $(".whenMoveIn select").is(":visible") ){
				return false;
			}
			return true;

		},
		"Custom message"
	);

	var PropertySituation = new Object();
	PropertySituation = {

		init: function(){



		}

	}

</go:script>

<go:script marker="onready">
	PropertyDescription.init();
	PropertyCondition.init();
	PropertySituation.init();
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_yearBuilt" rule="yearBuiltAfterMoveInYear" parm="true" message="Please change the building year so that it is prior or equal to the year you moved in" />