<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Dialog to set a comparison reminder"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" 			required="true" 	rtexprvalue="true"	 description="xpath for reminder form" %>
<%@ attribute name="vertical" 		required="false" 	rtexprvalue="true"	 description="the vertical that this is associated with" %>
<%@ attribute name="preSelect" 		required="false" 	rtexprvalue="true"	 description="List of options to be preselected" %>
<%@ attribute name="src" 			required="false" 	rtexprvalue="true"	 description="whether this is from an external source or local" %>
<%@ attribute name="id" 			required="false" 	rtexprvalue="true"	 description="ID used primarily for anti css conflicting" %>

<%-- ---------------------------------------------------------------------------------------------------------------------------- --%>
<%-- NOTE: This is designed to be used with the wrapper.tag and presented on the brochureware site. Please test accordingly --%>
<%-- ---------------------------------------------------------------------------------------------------------------------------- --%>

<c:set var="emailLabel">Email Address</c:set>
<c:set var="firstNameLabel">First Name</c:set>
<c:set var="lastNameLabel">Last Name</c:set>
<c:set var="postCodeLabel">Post Code</c:set>

<c:set var="quoteType">${vertical}_reminder</c:set>

<c:set var="emailCode">CTMR</c:set>

<c:if test="${src == 'ext' }">
	<c:set var="responseType">&responseType=jsonp</c:set>
</c:if>
<c:if test="${vertical == 'main' }">
	<c:set var="panelClass">-main</c:set>
</c:if>
<c:if test="${empty id}">
	<c:set var="id">mainReminder</c:set>
</c:if>
<c:if test="${src == 'ext' }">
	<div class="reminder_box">
	<c:choose>
		<c:when test="${vertical == 'main' }">
				<div class="right-panel-top${panelClass}"></div>
				<div class="right-panel-middle${panelClass}" id="${vertical}_comparison_reminder_holder">
					<!-- This will be filled with the comparison reminder button -->
				</div>
				<div class="right-panel-bottom${panelClass}"></div>

		</c:when>
		<c:otherwise>
				<div id="${vertical}_comparison_reminder_holder">
					<!-- This will be filled with the comparison reminder button -->
				</div>
		</c:otherwise>
	</c:choose>
	</div>
</c:if>
<div id="${vertical}_comparison_reminder_button">
	<h6>Not quite ready to get a comparison yet?</h6>
		<p class="${vertical}_reminder_set_text">Set a reminder &amp; we'll contact you closer to the time</p>
		<div class="button-wrapper" align="center">
			<a id="${vertical}_reminder-button" class="green-button ${vertical}_reminder-button" href="javascript:${vertical}_ComparisonReminderDialog.launch();">
				<span>
					<img src="brand/ctm/images/buttonReminderIcon.png" class="${vertical}_reminder_tick_small">
					Set a reminder now
				</span>
			</a>
		</div>
</div>
<div id="${vertical}_renewal-form-dialog" class="${vertical}_renewal-form-dialog" title="Comparison Reminder">
	<div class="${vertical}_innertube">
	<form:form action="javascript:void(0);" method="POST" id="reminder_form" name="reminder_form">


		<img src="brand/ctm/images/reminderTick.png" class="${vertical}_reminder_tick">
		<h3 class="${vertical}_reminder_header">Set your reminder</h3>
		<p class="${vertical}_reminder_header_text">Not ready to start comparing? Not a problem. We are more than happy to give you a gentle reminder at a later date. Simply fill out the form below and the rest will be taken care of!</p>
		<div class="${vertical}_clear"></div>
		<div class="line"></div>
		<div class="${vertical}_clear"></div>
		<avea:loading title="Please wait..." id="${vertical}_"/>
		<div class="${vertical}_clear"></div>

		<div class="${vertical}_content" id="${vertical}_save-confirm">
			<h6>Your reminder has been saved!</h6>
			<p>We will email you on the dates specified!</p>
			<div class="${vertical}_button-wrapper" align="left">
				<a id="${vertical}_restart-button" class="green-button ${vertical}_reminder-button" href="javascript:${vertical}_ComparisonReminderDialog.reset();">
					<span>
						<img src="brand/ctm/images/buttonReminderIcon.png" class="${vertical}_reminder_tick_small">
						Edit Reminder
					</span>
				</a>
				<a id="${vertical}_close-button" class="green-button ${vertical}_reminder-button" href="javascript:${vertical}_ComparisonReminderDialog.close();">
					<span>
						Close
					</span>
				</a>
			</div>
		</div>

		<div class="${vertical}_content" id="${vertical}_save-error">
			<h6>Saving Reminder failed</h6>
			<p>An error occurred when trying to save your details.</p>
			<p class="${vertical}_customisable"><!-- empty --></p>
			<p>Please try again at a later time.</p>
			<div class="${vertical}_button-wrapper" align="left">
				<a id="${vertical}_try_again-button" class="green-button ${vertical}_reminder-button" href="javascript:${vertical}_ComparisonReminderDialog.tryAgain();">
					<span>
						<img src="brand/ctm/images/buttonReminderIcon.png" class="${vertical}_reminder_tick_small">
						Try Again
					</span>
				</a>
			</div>
		</div>

		<div id="${vertical}_reminder_body">
			<div id="${vertical}_main_content">
				<div class="${vertical}_colOne">
					<form:row label="" className="${vertical}_firstName_row" labelIcon="brand/ctm/images/icons/avatarGen.png">
						<field:input xpath="firstName" required="true" title="First name" placeHolder="${firstNameLabel}" tabIndex="1" size="17"/>
					</form:row>
					<form:row label="" labelIcon="brand/ctm/images/icons/emailIcon.png">
						<field:contact_email xpath="email" required="true" title="Email" placeHolder="${emailLabel}" tabIndex="3" size="17"/>
					</form:row>
					<div class="clear"></div>
				</div>
				<div class="${vertical}_colTwo">
					<form:row label="" className="${vertical}_lastName_row" labelIcon="">
						<field:input xpath="lastName" required="true" title="Last Name" placeHolder="${lastNameLabel}" tabIndex="2" size="17"/>
					</form:row>
					<form:row label="" labelIcon="brand/ctm/images/icons/postcodeIcon.png">
						<field:input xpath="postCode" required="true" title="Postcode" placeHolder="${postCodeLabel}" tabIndex="4" size="17" maxlength="4"/>
					</form:row>
					<div class="clear"></div>
				</div>
			</div>

			<div class="line"></div>
			<h4 class="${vertical}_reminder_header">What would you like us to remind you about?</h4>
				<span class="${vertical}_reminder_types ${vertical}_reminder_health">		<field:checkbox value="1" xpath="${vertical}/reminder/health" title="Health Insurance" label="Health Insurance" required="false" /></span>
				<span class="${vertical}_reminder_types ${vertical}_reminder_car">			<field:checkbox value="1" xpath="${vertical}/reminder/car" title="Car Insurance" label="Car Insurance" required="false"/></span>
				<span class="${vertical}_reminder_types ${vertical}_reminder_life">			<field:checkbox value="1" xpath="${vertical}/reminder/life" title="Life Insurance" label="Life Insurance" required="false"/></span>
				<span class="${vertical}_reminder_types ${vertical}_reminder_utilities">	<field:checkbox value="1" xpath="${vertical}/reminder/utilities" title="Utilities Comparison" label="Utilities Comparison" required="false"/></span>
				<span class="${vertical}_reminder_types ${vertical}_reminder_travel">		<field:checkbox value="1" xpath="${vertical}/reminder/travel" title="Travel Insurance" label="Travel Insurance" required="false"/></span>
				<span class="${vertical}_reminder_types ${vertical}_reminder_income">		<field:checkbox value="1" xpath="${vertical}/reminder/income" title="Income Protection" label="Income Protection" required="false"/></span>
				<span class="${vertical}_reminder_types ${vertical}_reminder_roadside">		<field:checkbox value="1" xpath="${vertical}/reminder/roadside" title="Roadside Assistance" label="Roadside Assistance" required="false"/></span>
			<div class="line"></div>
			<div id="${vertical}_reminder_health_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Health</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_health_date" required="true" title="Select your Health reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div id="${vertical}_reminder_car_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Car</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_car_date" required="true" title="Select your Car reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div id="${vertical}_reminder_life_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Life</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_life_date" required="true" title="Select your Life reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div id="${vertical}_reminder_utilities_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Utilities</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_utilities_date" required="true" title="Select your Utilities reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div id="${vertical}_reminder_travel_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Travel</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_travel_date" required="true" title="Select your Travel reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div id="${vertical}_reminder_income_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Income</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_income_date" required="true" title="Select your Income reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div id="${vertical}_reminder_roadside_row" class="${vertical}_reminder_date_text">
				<div>When would you like your <strong>Roadside</strong> reminder sent?</div>
				<field:basic_date xpath="${vertical}_reminder_roadside_date" required="true" title="Select your Roadside reminder date" className="${vertical}_reminder_date" numberOfMonths="1" maxDate="11m"></field:basic_date>
			</div>
			<div class="line"></div>
			<field:checkbox value="Y" xpath="${vertical}_reminder_marketing" title="Keep me informed about specials and other news from Compare the Market" label="Newsletter Signup" required="false" />
			<div class="line"></div>
			<div class="${vertical}_button-wrapper" align="left">
				<a id="${vertical}_submit_reminder-button" class="green-button ${vertical}_reminder-button" href="javascript:${vertical}_ComparisonReminderDialog.save();">
					<span>
						<img src="brand/ctm/images/buttonReminderIcon.png" class="${vertical}_reminder_tick_small">
						Set my reminder now
					</span>
				</a>
			</div>
		</div>

	</form:form>
	<div class="${vertical}_dialog_footer"></div>
	</div>
	<div id="${vertical}_reminder_quote_errors">
		<div class="error-panel-top-small error-panel-top small"><h3>Oops...</h3></div>
		<div class="error-panel-middle-small error-panel-middle small"><ul></ul></div>
		<div class="error-panel-bottom-small error-panel-bottom small"></div>
	</div>
</div>

<%-- Dialog for rendering fatal errors --%>
<form:fatal_error />

<%-- CSS --%>
<go:style marker="css-head-ie">
.${vertical}_reminder_tick_small {
	margin-top: -15px !important;
}
</go:style>
<go:style marker="css-head-ie9">
.${vertical}_reminder-button {
	zoom: 1;
	display:inline-block !important;
}
.error-panel-top H3 {
	padding-bottom: 0px !important;
}
.${vertical}_renewal-form-dialog H3 {
	margin: 0px !important;
}
#${vertical}_reminder_quote_errors {
	margin-top: -20px !important;
}
</go:style>
<go:style marker="css-head-ie8">
.ui-dialog-title {
	zoom: 1;
}
.ui-helper-clearfix:after, .ui-helper-clearfix:before {
	content: none !important;
	display: inline-block !important;
	clear: none !important;
}
.${vertical}_reminder-button {
	zoom: 1;
	display:inline-block !important;
}
#${vertical}_reminder_quote_errors {
	margin-top: -20px !important;
}
.error-panel-top H3 {
	padding-bottom: 0px !important;
}
.${vertical}_renewal-form-dialog H3 {
	margin: 0px !important;
}
.${vertical}_reminder_date_text div {
	display:inline-block;
}
</go:style>
<go:style marker="css-head-ie7">
.${vertical}_reminder-button {
	zoom: 1;
	display:inline-block !important;
}
#${vertical}_reminder_quote_errors {
	margin-top: -20px !important;
}
.error-panel-top H3 {
	padding-bottom: 0px !important;
}
.${vertical}_renewal-form-dialog H3 {
	margin: 0px !important;
}
#firstName {
	padding-right: 5px !important;
}

</go:style>
<go:style marker="css-head">
#${vertical}_reminder_quote_errors{
	display:none;
	position: absolute;
	right: 10px;
	top: 127px;
	width: 220px;
	z-index:10000;
	line-height: 1;
}
#${vertical}_renewal-form-dialog {
	min-width:				637px;
	max-width:				637px;
	width:					637px;
	display: 				none;
	overflow:				hidden;
}
#${vertical}_renewal-form-dialog .${vertical}_clear{clear:both;}

#${vertical}_renewal-form-dialog .${vertical}_innertube {
	margin:					0 20px;
}

#${vertical}_renewal-form-dialog h3,
#${vertical}_renewal-form-dialog p {
	font-size:				14px;
}

#${vertical}_renewal-form-dialog h3 {
	font-weight:			900;
	margin:					15px 0 5px 0;
}

#${vertical}_renewal-form-dialog h3:first-child {
	margin-top:				0;
}

#${vertical}_renewal-form-dialog p {
	margin:					8px 0;
	font-size:				13px;
	line-height:			15px;
}

#${vertical}_renewal-form-dialog table {
	width:					96%;
}

#${vertical}_renewal-form-dialog .${vertical}_spacesaver {
	width:					50%;
	float:					left;
	margin-top:				10px;
}

#${vertical}_renewal-form-dialog .${vertical}_spacesaver.right {
	float:					right;
}

#${vertical}_renewal-form-dialog .${vertical}_innertube th,
#${vertical}_renewal-form-dialog .${vertical}_innertube td {
	padding:				5px 10px;
	border:					1px solid #E3E8EC;
	text-align:				left;
}

#${vertical}_renewal-form-dialog .${vertical}_innertube th {
	font-weight:			900;
}

#${vertical}_renewal-form-dialog .${vertical}_dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_637.gif") no-repeat scroll left top transparent;
	width: 					637px;
	height: 				14px;
	clear: 					both;
}

.ui-dialog.${vertical}_renewal-form-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					2.5em;
	right: 					1em;
}
.ui-dialog.${vertical}_renewal-form-dialog .${vertical}_message-form, .ui-dialog #${vertical}_renewal-form-dialog{
	padding:				0;
}
#ui-datepicker-div {
	padding: 0;
}
.${vertical}_renewal-form-dialog .ui-dialog-titlebar {
	background-image:		url("common/images/dialog/header_637.gif") !important;
	height:					34px;
	-moz-border-radius-bottomright: 0;
	-webkit-border-bottom-right-radius: 0;
	-khtml-border-bottom-right-radius: 0;
	border-bottom-right-radius: 0;
	-moz-border-radius-bottomleft: 0;
	-webkit-border-bottom-left-radius: 0;
	-khtml-border-bottom-left-radius: 0;
	border-bottom-left-radius: 0;
}

.${vertical}_renewal-form-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_637.png") !important;
}
.${vertical}_reminder_tick {
	float: left;
	padding: 10px;
}
.${vertical}_reminder_tick_small {
	float: left;
	padding: 10px !important;
	margin-top: -15px !important;
}
.${vertical}_reminder_header_text {
	color: #9B9291;
}
.${vertical}_reminder_set_text {
	color: #9B9291;
	margin:10px;
	text-align: center;
	font-size: 14px;
	padding-bottom: 8px !important;
}
#firstName,
#postCode,
#lastName,
#email {
	color: #9B9291;
}
h4.${vertical}_reminder_header {
	margin-bottom:20px;
}
.${vertical}_reminder_types {
	width: 27%;
	background-color: #F1F1F1;
	margin-top: 10px;
	margin-right: 10px;
	padding: 10px;
	padding-right: 1px;
	padding-left: 5px;
	display: inline-block;
	font-size: 80%;
}
.${vertical}_reminder_types label{
	background-repeat: no-repeat;
	padding-left: 25px;
	display: inline-block;
	line-height: 25px;
}
.${vertical}_reminder_health label {
	background-image: url("brand/ctm/images/icons/icon-nav-health.png");
}
.${vertical}_reminder_car label {
	background-image: url("brand/ctm/images/icons/icon-nav-car.png");
}
.${vertical}_reminder_life label {
	background-image: url("brand/ctm/images/icons/icon-nav-life.png");
}
.${vertical}_reminder_utilities label {
	background-image: url("brand/ctm/images/icons/icon-nav-energy.png");
}
.${vertical}_reminder_travel label {
	background-image: url("brand/ctm/images/icons/icon-nav-travel.png");
}
.${vertical}_reminder_income label {
	background-image: url("brand/ctm/images/icons/icon-nav-income.png");
}
.${vertical}_reminder_roadside label {
	background-image: url("brand/ctm/images/icons/icon-nav-roadside.png");
}
.${vertical}_colOne{
	float:left;
	width:200px;
}
.${vertical}_colTwo{
	float:left;
	width:200px;
}
.imgOnlyLabel {
	margin: 0px !important;
	width: 30px !important;

}
#${vertical}_main_content {
	height: 80px;
}
.${vertical}_reminder-button  {
	float:none !important;
	display: inline-block;
	background-repeat: no-repeat;
	text-align: center;
	cursor: pointer;
}
.${vertical}_reminder-button span {
	width: 210px !important;
}
.${vertical}_reminder_date_text {
	padding-top: 5px;
	padding-bottom: 5px;
	display: none;
}
.${vertical}_reminder_date_text div {
	width: 450px;
	display: inline-block;
	*display: inline;
	zoom: 1;
}
#${vertical}_save-confirm,
#${vertical}_save-error {
	display:none;
	min-height: 100px;
}
a.${vertical}_reminder-button {
	width: auto !important;
}
.${vertical}_button-wrapper {
	height: 60px;
}
.${vertical}_button-wrapper a:hover {
	text-decoration: none;
}
#${vertical}_reminder_quote_errors ul li {
	background: none !important;
	padding: 0px !important;
}
.ui-datepicker-trigger {
	cursor: pointer;
}
.fieldrow {
	zoom: 1;
	*display: block;
}
.fieldrow_value {
	margin: 0 0 0 5px !important;
}
#{vertical}_save-confirm h6{
	font-weight: bold;
	color: #6C7173;
}
{ <%-- This is on purpose to allow the css parser to apply these rules to the container --%>
	font-size: 12px;
	font-family: arial, sans-serif;
}

</go:style>

<go:script marker="js-head">
var ${vertical}_ComparisonReminderDialog = new Object();
${vertical}_ComparisonReminderDialog = {

	_CONFIRM : "confirm",
	_ERROR : "error",
	_FILE : "write_reminder",
	_data : "",
	_showCounter : 0,

	init: function() {

		// Initialise the search quotes dialog box
		// =======================================
		$('#${vertical}_renewal-form-dialog').dialog({
			autoOpen: false,
			show: 'clip',
			hide: 'clip',
			'modal':true,
			'width':637,
			'minWidth':637,
			'autoOpen': false,
			'draggable':false,
			'resizable':false,
			'dialogClass':'${vertical}_renewal-form-dialog',
			open: function() {
				${vertical}_ComparisonReminderDialog.show();
				$('.ui-widget-overlay').bind('click', function () { $('#${vertical}_renewal-form-dialog').dialog('close'); });
				<%--IE fix --%>
				$('#firstName').trigger('focus');
				$('#firstName').blur();
			},
			close: function() {
				${vertical}_ComparisonReminderDialog.hide();
			}
		});

		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_health', 	'${vertical}_reminder_health_date');
		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_car', 		'${vertical}_reminder_car_date');
		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_life', 		'${vertical}_reminder_life_date');
		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_utilities', '${vertical}_reminder_utilities_date');
		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_travel', 	'${vertical}_reminder_travel_date');
		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_income', 	'${vertical}_reminder_income_date');
		${vertical}_ComparisonReminderDialog.showReminderDateRow ('${vertical}_reminder_roadside', 	'${vertical}_reminder_roadside_date');

		<!-- We want the button to be part of the main body but not the dialog as we need to avoid form conflicts -->

		if ($('#${vertical}_comparison_reminder_holder').length > 0){
			$('#${vertical}_comparison_reminder_button').appendTo('#${vertical}_comparison_reminder_holder');
		}

		$("#${vertical}_submit_reminder-button .${vertical}_reminder-button").click(function() {
			${vertical}_ComparisonReminderDialog.save();
		});

		${vertical}_ComparisonReminderDialog.validate_submit();

	},
	reset: function() {
		$("#${vertical}_save-confirm").hide();
		$("#${vertical}_reminder_body").show();
	},
	launch: function() {
		$('#${vertical}_renewal-form-dialog').dialog("open");
	},

	hide: function() {
		$("#${vertical}_renewal-form-dialog").hide();
	},
	close : function () {
		$('#${vertical}_renewal-form-dialog').dialog('close');
	},
	show: function() {

		<%-- Needed for css conflicts as these elements are outside of the main container because of IE --%>
		$('.ui-widget-overlay').wrap('<div class="${id}" />'); <%--this is recreated each time you open --%>
		if (${vertical}_ComparisonReminderDialog._showCounter == 0){
			$('.ui-effects-wrapper').wrap('<div class="${id}" />');
			$('#ui-datepicker-div').wrap('<div class="${id}" />');
			${vertical}_ComparisonReminderDialog._dialogMove = 1;

			<%--Initiate our preselects --%>
			var preselects = '${preSelect}';
			preselects = preselects.toLowerCase();
			preselects = preselects.split(',');

			for (var i=0; i < preselects.length; i++){
				${vertical}_ComparisonReminderDialog.preSelect(preselects[i]);
			}
		}

<%-- 		$("body").add('<span id="${id}_bottom" class="${id}"></span>'); --%>
		//.addClass("${id}").attr('id', '${id}_bottom');;
		//$('.ui-dialog').detach().appendTo('#${id}_bottom');

		$("#${vertical}_renewal-form-dialog").show();
		//Track.onCustomPage("Comparison Reminder Dialog");
	},
	showReminderDateRow : function (element, date_element){
		$('input[id='+element+']').on('change', function(){
			var currValue = $('input[id='+element+']:checked').val();

			if(currValue == '1'){
				${vertical}_ComparisonReminderDialog.addNewDateValidation(element, date_element);
			}
			else {
				${vertical}_ComparisonReminderDialog.removeDateValidation(element, date_element);
			}
		});
	},
	tryAgain : function (){
		$("#${vertical}_save-error").hide();
		$("#${vertical}_reminder_body").show();
	},
	addNewDateValidation : function (element, date_element){
		$('#'+element+'_row').slideDown();
		var reminder_name = date_element.replace(/_/g," ");
		reminder_name = reminder_name.replace("${vertical} reminder ","");
		reminder_name = ${vertical}_ComparisonReminderDialog.capitaliseFirstLetter(reminder_name);
		$("#"+date_element).rules("add", {

			required: true,
			messages: {
				required: reminder_name+" is required"
			}
		});
	},
	removeDateValidation : function (element, date_element){
		$('#'+element+'_row').slideUp();
		$("#"+date_element).rules("remove");
	},
	preSelect : function (element) {
		if ($('#${vertical}_reminder_'+element.toLowerCase()).length > 0 ){
			$('#${vertical}_reminder_'+element.toLowerCase()).prop('checked', true);
			${vertical}_ComparisonReminderDialog.addNewDateValidation ('${vertical}_reminder_'+element.toLowerCase(), '${vertical}_reminder_'+element.toLowerCase()+'_date');
		}
	},
	updateErrorFeedback: function( errors ) {
		if(typeof errors == "object" && errors.length) {
			var element = $("#${vertical}_save-error").find(".${vertical}_customisable").first();
			for( var i = 0; i < errors.length; i++ ) {
				element.append( errors[i].error );

				if( i + 1 < errors.length ) {
					element.append("<br /><br />");
				}
			}
		}
		else{
			$("#${vertical}_save-error").find(".${vertical}_customisable").first().empty().hide();
		}
	},
	save : function(){


			$("#reminder_form").validate();

			$("#reminder_form :input").each(function(index) {
				$("#reminder_form").validate().element("#" + $(this).attr("id"));
			});

<!-- 				// If no validation errors, save details.. -->
			if ($("#reminder_form").validate().numberOfInvalids() == 0){
				$("#${vertical}_loading-box").show();
				$("#${vertical}_reminder_body").hide();
				${vertical}_ComparisonReminderDialog._ajaxSave();
			}

	},
	_ajaxSave : function(){

		${vertical}_ComparisonReminderDialog._data = "xpath=${quoteType}&quoteType=${quoteType}&emailCode=${emailCode}&vertical=${vertical}${responseType}&brand=CTM";
		${vertical}_ComparisonReminderDialog.get_data('firstName');
		${vertical}_ComparisonReminderDialog.get_data('lastName');
		${vertical}_ComparisonReminderDialog.get_data('email');
		${vertical}_ComparisonReminderDialog.get_data('postCode');
		${vertical}_ComparisonReminderDialog.get_dates('health');
		${vertical}_ComparisonReminderDialog.get_dates('car');
		${vertical}_ComparisonReminderDialog.get_dates('life');
		${vertical}_ComparisonReminderDialog.get_dates('utilities');
		${vertical}_ComparisonReminderDialog.get_dates('travel');
		${vertical}_ComparisonReminderDialog.get_dates('income');
		${vertical}_ComparisonReminderDialog.get_dates('roadside');
		${vertical}_ComparisonReminderDialog.get_marketing();

		// ajax save the reminder..
		$.ajax({
			url: "ajax/json/" + ${vertical}_ComparisonReminderDialog._FILE + ".jsp",
			data: ${vertical}_ComparisonReminderDialog._data,
			type: "GET",
			jsonpCallback: 'jsonpCallBack',
			dataType: "jsonp",
			jsonp: 'callback',
			cache: false,
			beforeSend : function(xhr,setting) {
				var url = setting.url;
				setting.url = url;
			},
			success: function(jsonResult,txt,jqXHR ){
				if (jsonResult.result == "OK"){
					${vertical}_ComparisonReminderDialog.show(${vertical}_ComparisonReminderDialog._CONFIRM);
					$("#${vertical}_loading-box").hide();
					$("#${vertical}_save-confirm").show();
					$("#${vertical}_save-error").hide();
					$("#${vertical}_reminder_body").hide();
				}
				else{
					${vertical}_ComparisonReminderDialog.show(${vertical}_ComparisonReminderDialog._ERROR);
					$("#${vertical}_loading-box").hide();
					$("#${vertical}_save-confirm").hide();
					$("#${vertical}_save-error").show();
					$("#${vertical}_reminder_body").hide();
				}

				return false;
			},
			error: function(obj,txt,errString){
				try {
					var errors = eval(obj.responseText);
					if(typeof errors == "object" && errors.length) {
						${vertical}_ComparisonReminderDialog.updateErrorFeedback(errors);
					}
					else{
						${vertical}_ComparisonReminderDialog.updateErrorFeedback();
					}
				} catch(e) {
					${vertical}_ComparisonReminderDialog.updateErrorFeedback();
				}

				${vertical}_ComparisonReminderDialog.show(${vertical}_ComparisonReminderDialog._ERROR);
				$("#${vertical}_loading-box").hide();
				$("#${vertical}_reminder_body").hide();
				$("#${vertical}_save-confirm").hide();
				$("#${vertical}_save-error").show();
			},
			complete: function(jsonResult,txt){

			},
			timeout:30000
		});
	},
	get_dates : function (field) {
		if ($('#${vertical}_reminder_'+field).is(':checked')){
			var new_date = $('#${vertical}_reminder_'+field+'_date').val();
			new_date = new_date.substring(6,10) + "-" + new_date.substring(3,5)  + "-" + new_date.substring(0,2);
			new_date = encodeURI(new_date);
			${vertical}_ComparisonReminderDialog._data = ${vertical}_ComparisonReminderDialog._data + "&reminder_" + field + "_date=" + new_date;
		}
	},
	get_data : function (field) {
			var new_data = encodeURI($('#'+field).val());
			${vertical}_ComparisonReminderDialog._data = ${vertical}_ComparisonReminderDialog._data + "&" + field + "=" + new_data;
	},
	get_marketing : function() {
		if ($('#${vertical}_reminder_marketing').is(':checked')){
			var marketing = 'Y';
		}
		else {
			var marketing = 'N';
		}
		${vertical}_ComparisonReminderDialog._data = ${vertical}_ComparisonReminderDialog._data + "&reminder_marketing="+marketing;
	},
	validate_submit : function (){
		jQuery.validator.addMethod("notEqual", function(value, element, param) {

			return this.optional(element) || value != param;
		}, "Default value detected.");
		$("#reminder_form").validate({
			rules: {
				firstName: {
					required:true,
					notEqual: "${firstNameLabel}"
				},
				lastName: {
					required:true,
					notEqual: "${lastNameLabel}"
				},
				email: {
					required:true,
					notEqual: "${emailLabel}",
					email:true
				},
				postCode: {
					required:true,
					notEqual: "${postCodeLabel}",
					minlength: 4,
					maxlength: 4,
					number: true
				}
			},
			messages: {
				email: {
					required: "Please enter a valid email address",
					notEqual: "Please enter an email address"
				},
				firstName: {
					required: "Please enter a first name",
					notEqual: "Please enter your first name"
				},
				lastName: {
					required: "Please enter a last name",
					notEqual: "Please enter your last name"
				},
				postCode: {
					required: "Please enter a postcode",
					minlength: "Please enter 4 characters for postcode",
					maxlength: "Please enter 4 characters for postcode",
					notEqual: "Please enter your postcode"
					//,number: "Postcode should be numbers only" <%-- <= IE8 doesnt support numeric... --%>
				}
			},
			errorContainer: "#${vertical}_reminder_quote_errors, #${vertical}_reminder_quote_errors p",
			errorLabelContainer:"#${vertical}_reminder_quote_errors ul",
			wrapper: "li",
			debug:true
		});
	},
	capitaliseFirstLetter : function (string){
		return string.charAt(0).toUpperCase() + string.slice(1);
	},
	twoDigits : function (string) {
		string = string.toString();
		var length = string.length;
		if (string.length < 2) {
			return "0"+string;
		}
		else {
			return string;
		}
	}
};

</go:script>
<go:script marker="onready">
	${vertical}_ComparisonReminderDialog.init();
</go:script>