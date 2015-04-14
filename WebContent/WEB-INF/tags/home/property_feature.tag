<%@ tag import="java.util.*"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Property features group gadget."%>

<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true"	description="variable's xpath"%>
<%@ attribute name="className" required="false" rtexprvalue="true"	description="additional css class attribute"%>
<%@ attribute name="title" required="true" rtexprvalue="true"	description="title of the panel"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<go:style marker="css-head">
	.securityFeatures .fieldrow_value {
		margin: 8px 0 0 14px;
	}
</go:style>

<div class="${className}">

	<form:fieldset legend="${title}" className="${className}" id="${name}">
			<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY GREENSTONE & CALLIDEN --%>
<%-- 		<c:set var="swimmingPool"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/swimmingPool" value="Y"  title="Swimming Pool" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="balcony"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/balcony" value="Y" title="Balcony" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="deck"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/deck" value="Y" title="Deck" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="verandah"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/verandah" value="Y" title="Verandah" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="grannyFlat"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/grannyFlat" value="Y" title="Granny Flat" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="smallGardenShed"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/smallGardenShed" value="Y" title="Small Garden Shed" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="largeGardenShed"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/largeGardenShed" value="Y" title="Large Garden Shed" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="tennisCourt"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/tennisCourt" value="Y" title="Tennis Court" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="waterTanks"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/waterTanks" value="Y" title="Water Tank(s)" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="airConditionners"> --%>
<%-- 			<field:checkbox xpath="${xpath}/features/airConditionners" value="Y" title="More than 2 fixed air conditioners" required="false"/> --%>
<%-- 		</c:set> --%>

<!-- 		<div class="propertyFeatures"> -->
<%-- 			<form:items_grid label="Which features does the home has?" columns="3" items="Swimming Pool=${swimmingPool}, --%>
<%-- 																			Balcony=${balcony}, --%>
<%-- 																			Deck=${deck}, --%>
<%-- 																			Verandah=${verandah}, --%>
<%-- 																			Granny Flat=${grannyFlat}, --%>
<%-- 																			Small Garden Shed=${smallGardenShed}, --%>
<%-- 																			Large Garden Shed=${largeGardenShed}, --%>
<%-- 																			Tennis Court=${tennisCourt}, --%>
<%-- 																			Water Tank(s)=${waterTanks}, --%>
<%-- 																			More than 2 fixed air conditioners=${airConditionners}" /> --%>
<!-- 		</div> -->

<!-- 		<hr/> -->

			<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY GREENSTONE & CALLIDEN --%>
<%-- 		<c:set var="doorLocks"> --%>
<%-- 			<field:checkbox xpath="${xpath}/securityFeatures/doorLocks" value="Y"  title="Locks on all doors" required="false"/> --%>
<%-- 		</c:set> --%>
<%-- 		<c:set var="windowLocks"> --%>
<%-- 			<field:checkbox xpath="${xpath}/securityFeatures/windowLocks" value="Y" title="Locks on all windows" required="false"/> --%>
<%-- 		</c:set> --%>
		<c:set var="internalSiren">
			<field:checkbox xpath="${xpath}/securityFeatures/internalSiren" value="Y" title="An Internal Siren" required="false"/>
		</c:set>
		<c:set var="externalSiren">
			<field:checkbox xpath="${xpath}/securityFeatures/externalSiren" value="Y" title="An External Siren" required="false"/>
		</c:set>
		<c:set var="strobeLight">
			<field:checkbox xpath="${xpath}/securityFeatures/strobeLight" value="Y" title="An External Strobe Light" required="false"/>
		</c:set>
		<c:set var="backToBase">
			<field:checkbox xpath="${xpath}/securityFeatures/backToBase" value="Y" title="Active Back To Base Monitoring" required="false" helpId="527" className="left"/>
		</c:set>

		<div class="securityFeatures">
			<form:items_grid 	label="Which security features does the home have?"
								columns="2"
								items="
									An Internal Siren=${internalSiren},
									An External Siren=${externalSiren},
									An External Strobe Light=${strobeLight},
									Active Back To Base Monitoring=${backToBase}"
								xpath="${xpath}/securityFeatures"
																			/>
						<%-- TEMPORARY REMOVAL OF QUESTION WHICH IS ONLY REQUIRED BY GREENSTONE & CALLIDEN --%>
<%-- 																			Locks on all doors=${doorLocks}, --%>
<%-- 																			Locks on all windows=${windowLocks}, --%>
		</div>

		<core:clear />
	</form:fieldset>
</div>

<%-- JAVASCRIPT HEAD --%>
<go:script marker="js-head">
	var PropertyFeature = new Object();
	PropertyFeature = {

		internalSirenId: '${name}_securityFeatures_internalSiren',
		externalSirenId: '${name}_securityFeatures_externalSiren',
		strobeLightId: '${name}_securityFeatures_strobeLight',
		backToBaseId: '${name}_securityFeatures_backToBase',

		init: function(){



		},

		toggleSecurityFeatures: function(){

			switch(CoverType.coverType){
				case "Contents Cover Only":
				case "Home & Contents Cover":
					$("label[for="+PropertyFeature.internalSirenId+"]").slideDown();
					$("input[name="+PropertyFeature.internalSirenId+"]").slideDown();

					$("label[for="+PropertyFeature.externalSirenId+"]").slideDown();
					$("input[name="+PropertyFeature.externalSirenId+"]").slideDown();

					$("label[for="+PropertyFeature.strobeLightId+"]").slideDown();
					$("input[name="+PropertyFeature.strobeLightId+"]").slideDown();

					$("label[for="+PropertyFeature.backToBaseId+"]").slideDown();
					$("input[name="+PropertyFeature.backToBaseId+"]").slideDown();
				break;
				default:
					$("label[for="+PropertyFeature.internalSirenId+"]").slideUp();
					$("input[name="+PropertyFeature.internalSirenId+"]").slideUp();

					$("label[for="+PropertyFeature.externalSirenId+"]").slideUp();
					$("input[name="+PropertyFeature.externalSirenId+"]").slideUp();

					$("label[for="+PropertyFeature.strobeLightId+"]").slideUp();
					$("input[name="+PropertyFeature.strobeLightId+"]").slideUp();

					$("label[for="+PropertyFeature.backToBaseId+"]").slideUp();
					$("input[name="+PropertyFeature.backToBaseId+"]").slideUp();
			}

		}

	}

</go:script>

<go:script marker="onready">
	PropertyFeature.init();
</go:script>