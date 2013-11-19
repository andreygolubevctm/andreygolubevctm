<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Group for vehicle selection which is put on brochureware via WRAPPER"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="modelRow" value="${name}_modelRow" />

<%-- HTML --%>
<div id="${name}-selection">
	<div id="quote_vehicle_selection">
		<form:row label="Make" id="${name}_makeRow" className="initial">
			<field:make_select xpath="${xpath}/make" title="vehicle manufacturer" type="make" required="true" />
			<%-- The hidden input, makeDes, is intentionally left out because the car_quote.jsp will handle it --%>
		</form:row>
		<form:row label="Model" id="${modelRow}">
			<field:general_select xpath="${xpath}/model" title="vehicle model" required="false" initialText="&nbsp;" />
			<%-- The hidden input, modelDes, is intentionally left out because the car_quote.jsp will handle it --%>
		</form:row>
		<form:row label="Year" id="${name}_yearRow">
			<field:general_select xpath="${xpath}/year" title="vehicle year" required="false" initialText="&nbsp;" />
		</form:row>
		<form:row label="&nbsp;" id="buttonRow">
			<a href="#" onclick="document.getElementById('mainform').submit();"
				class="btn orange arrow-right" id="ql_submit">
				<span>Compare Car Insurance</span></a>
		</form:row>
	</div>
</div>

<%-- CSS --%>
<go:style marker="css-head">
	<%-- Page Overrides --%>
	html, body, #content { background-color: transparent; background-image: none; min-width: 0; width: auto; }

	<%-- Style Implementation Overrides --%>
	#quote_vehicle-selection .fieldrow_value select {
		width: 142px;
		overflow:hidden !important;
	}
	#buttonRow {
		margin-bottom:0px;
		float:right;
	}
	#buttonRow .btn { white-space: nowrap; }
	#buttonRow .fieldrow_label { display: none; }
	.fieldrow {
		display: inline-block;
		width: auto;
		margin: 7px 8px 7px 0;
		float: left; /* For IE7 support */
	}
	.fieldrow_value {
		margin: 0;
	}
	.fieldrow_label {
		margin: 0;
		width: 35px;
		line-height: 34px;
		vertical-align: middle;
		color: white;
		margin-right: 9px;
		white-space: nowrap;
	}

	<%-- Hacks --%>
	<%-- Stop the pretty validation icons from appearing --%>
		.state-right {padding-right: 0;}
	<%-- Stop the overlay looking odd in an iframe --%>
		.ui-widget-overlay {display: none;}

	<%-- Stolen styles and other implementation updates --%>
	.fieldrow_value select {
		margin: 0;
		background: url('brand/${data.settings.styleCode}/images/buttons/dropdown_arrow_green.png') no-repeat right #fff;
		padding: 8px 34px 8px 14px;
		border-radius: 5px;
		border: none;
		font-size: 12px;

		/**
		 * Removes the down arrows on select boxes, the text-indent and text-overflow
		 * options make firefox play nice because of a bug with 'none'.
		 * IEx has no hope.
		 */
		text-indent: 0.01px;
		text-overflow: '';
		-webkit-appearance: none;
		-moz-appearance: none;
		appearance: none;
	}

	/**
	 * IE10 Compat method for no select box dropdown.
	 */
	.fieldrow_value select::-ms-expand {
		display: none;
	}

	/**
	 * Falls back to semi normal appearance of the select boxes on targeted IE's
	 */
	.lt-ie10 .fieldrow_value select {
		background-image: none;
		padding: 8px 14px;
	}
	.lt-ie8 .fieldrow_value select {
		margin-top: 7px;
	}

	@media only screen and (min-width: 320px) and (max-width: 480px){
		#buttonRow .fieldrow_label { display: block !important; }
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script href="common/js/car/vehicle_selection.js" marker="js-href" />

<%-- Legacy and onready calls --%>
<go:script marker="onready">
	<%-- Here are all our #id selectors if the JSTL needs them --%>
	<c:set var="year"		value="${name}_year" />
	<c:set var="make"		value="${name}_make" />
	<c:set var="makeDes"	value="${name}_makeDes" />
	<c:set var="model"		value="${name}_model" />
	<c:set var="modelDes"	value="${name}_modelDes" />
	<c:set var="xpathModel"	value="${xpath}/model" />
	<%-- Likewise if the JavaScript needs them --%>
	car.vehicleSelect.fields = {
		namePfx : "${name}",
		ajaxPfx : "car_",
		year    : "#${year}",
		make    : "#${make}",
		model   : "#${model}"
	};
	<%-- KICK OFF EVERYTHING FROM THE VEHICHLE_SELECTION.JS --%>
	car.vehicleSelect.init();
</go:script>