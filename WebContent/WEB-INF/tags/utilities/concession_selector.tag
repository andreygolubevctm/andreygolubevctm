<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Form to searching/displaying saved quotes"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" required="true" rtexprvalue="true"	description="The ID assigned to the source select element" %>

<go:script marker="js-head">
<%--
	Class submits the mainForm for writing the current quote form to the database via ajax
--%>
var ConcessionSelector = function() {

	<%-- Private members area --%>
	var elements			= {},
		concessions			= {
			<%-- You'll notice that some concessions in the same group share the same code - this is as provided by Switchwise --%>

			<%-- http://websvcpreprod.switchwise.com.au/switchwise1_5_9/SwitchwiseSearchService.svc/ConcessionTypes/DODO --%>
			standard : [
				["DVPC",		"DVA Gold Card (Extreme Disablement Adjustment)"],
				["PCC",			"Pensioner Concession Card"],
				["HCC",			"Centrelink Health Care Card"],
				["DVAGC",		"DVA Gold Card"],
				["DVPC",		"DVA Pension Concession Card"],
				["QGSC",		"Queensland Government Seniors Card"],
				["DVAGC_WW",	"DVA Gold Card (War Widows Pension only)"],
				["DVAGC_TPI",	"DVA Gold Card (Special Rate TPI Pension only)"],
				["DVPC",		"Qld Dept of Communities Seniors Concession Card"]
			],
			<%-- Click Energy (NSW) --%>
			<%-- http://websvcpreprod.switchwise.com.au/switchwise1_5_9/SwitchwiseSearchService.svc/ConcessionTypes/CLK --%>
			clk	: [
				["CDHCC",		"Health Care Card Carer (Child Under 16)"],
				["SAHCC",		"Health Care Card Sickness Allowance [SA]"],
				["SPHCC",		"Health Care Card Special Benefit [SP]"],
				["QGSC",		"Queensland Government Senior's Card"],
				["PCC",			"Centrelink Pensioner Concession Card"],
				["DVAGC",		"Dept of Veterans Affairs Gold Card"],
				["DVA_DIS",		"DVA Gold Card (Disability Pension)"],
				["DVAGC",		"DVA Gold Card (Repatriation Health Card)"],
				["DVAGC_TPI",	"DVA Gold Card (TPI only)"],
				["DVAGC_WW",	"DVA Gold Card (War Widow)"],
				["DVPC",		"DVA Pension Concession Card"],
				["HCC",			"Health Care Card"]
			],
			<%-- Alinta Energy (Victoria) --%>
			<%-- http://websvcpreprod.switchwise.com.au/switchwise1_5_9/SwitchwiseSearchService.svc/ConcessionTypes/ALN --%>
			aln : [
				["PCC",			"Pensioner Concession Card"],
				["HCC",			"Centrelink Health Care Card"],
				["DVAGC",		"DVA Gold Card"],
				["DVPC",		"DVA Pension Concession Card"],
				["DVAGC_WW",	"DVA Gold Card (War Widows Pension only)"],
				["DVAGC_TPI",	"DVA Gold Card (Special Rate TPI Pension only)"]
			]
		};

	var init = function() {
		elements["root"] = $('#${id}');
	};

	var getOption = function(id, value, text) {

		return $('<option/>', {
			id 		: id,
			value	: value
		}).append(text)
	};

	this.update = function( provider_code ) {
		var options = concessions.hasOwnProperty( provider_code ) ? concessions[provider_code] : concessions.standard;
		var option_id = "utilities_application_situation_concession_type_";
		elements.root.find('option').remove();
		elements.root.append(getOption(option_id, '', "Please choose..."))
		for(var i=0; i < options.length; i++) {
			elements.root.append(
				getOption(option_id + options[i][0], options[i][0], options[i][1])
			);
		}
	};

	init();
};

var concession_selector;
</go:script>

<go:script marker="onready">
concession_selector = new ConcessionSelector();
</go:script>