<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Property condition group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the panel"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<go:style marker="css-head">
	.heritage{
		display: none;
	}
</go:style>

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">

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

<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY HOLLARD & CALLIDEN --%>
<%-- 		<form:row label="Is the home structurally sound and watertight?"> --%>
<%-- 			<field:array_radio xpath="${xpath}/soundWatertight" --%>
<%-- 				title="if the home is structurally sound and watertight" --%>
<%-- 				required="true" --%>
<%-- 				className="pretty_buttons" --%>
<%-- 				items="Y=Yes,N=No" /> --%>
<%-- 		</form:row> --%>

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">

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

</go:script>

<go:script marker="onready">
	PropertyCondition.init();
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_yearBuilt" rule="yearBuiltAfterMoveInYear" parm="true" message="Please change the building year so that it is prior or equal to the year you moved in" />