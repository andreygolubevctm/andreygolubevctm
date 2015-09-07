<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="request" />

<p>Tags with a <del>deleted</del> title indicate they have been replaced (e.g. into a field-new version) due to changes, such as markup, that may introduce instability in current verticals.</p>

<%--
<div style="position:relative;height:200px;width:700px;">
<field_new:creditcard_assurance_message showCreditCards="true" />
</div>
--%>

<form_new:fieldset legend="'ui' tags" className="">
	<div class="row">
		<div class="col-sm-3">
			<ui:bubble>
				<h4>bubble default</h4>
				<p>Cosby sweater Odd Future tote bag yr flannel fanny pack cred Portland shabby chic.</p>
			</ui:bubble>
		</div>
		<div class="col-sm-3">
			<ui:bubble variant="help">
				<h4>bubble help</h4>
				<p>Tote bag skateboard umami, fap actually meggings pickled VHS food truck ethnic next level bespoke swag.</p>
			</ui:bubble>
		</div>
		<div class="col-sm-3">
			<ui:bubble variant="info">
				<h4>bubble info</h4>
				<p>Wayfarers polaroid salvia, disrupt Williamsburg keffiyeh squid keytar tousled cray sustainable.</p>
			</ui:bubble>
		</div>
		<div class="col-sm-3">
			<ui:bubble variant="chatty">
				<h4>bubble chatty</h4>
				<p>Seitan polaroid High Life hoodie hashtag. Mixtape mumblecore blog, next level art party synth ugh twee beard small batch Austin.</p>
			</ui:bubble>
		</div>
	</div>
</form_new:fieldset>



<form_new:fieldset legend="CTM icon font" className="">
	<div class="row">
		<div class="col-xs-12">
			<h3>Base size</h3>
			<span class="icon-tick" title="icon-tick"></span>
			<span class="icon-cross" title="icon-cross"></span>
			<span class="icon-info" title="icon-info"></span>
			<span class="icon-circle-cut" title="icon-circle-cut"></span>
			<span class="icon-arrow-left" title="icon-arrow-left"></span>
			<span class="icon-arrow-right" title="icon-arrow-right"></span>
			<span class="icon-arrow-down" title="icon-arrow-down"></span>
			<span class="icon-arrow-up" title="icon-arrow-up"></span>
			<span class="icon-phone" title="icon-phone"></span>
			<span class="icon-phone-hollow" title="icon-phone-hollow"></span>
			<span class="icon-car-solid" title="icon-car-solid"></span>
			<span class="icon-car" title="icon-car"></span>
			<span class="icon-plane-solid" title="icon-plane-solid"></span>
			<span class="icon-plane" title="icon-plane"></span>
			<span class="icon-money-solid" title="icon-money-solid"></span>
			<span class="icon-money" title="icon-money"></span>
			<span class="icon-heart-solid" title="icon-heart-solid"></span>
			<span class="icon-heart" title="icon-heart"></span>
			<span class="icon-house-solid" title="icon-house-solid"></span>
			<span class="icon-house" title="icon-house"></span>
			<span class="icon-health-solid" title="icon-health-solid"></span>
			<span class="icon-health" title="icon-health"></span>
			<span class="icon-travel" title="icon-travel"></span>
			<span class="icon-roadside" title="icon-roadside"></span>
			<span class="icon-life" title="icon-life"></span>
			<span class="icon-ip" title="icon-ip"></span>
			<span class="icon-home-loans" title="icon-home-loans"></span>
			<span class="icon-contents" title="icon-contents"></span>
			<span class="icon-home-contents" title="icon-home-contents"></span>
			<span class="icon-fuel" title="icon-fuel"></span>
			<span class="icon-energy" title="icon-energy"></span>
			<span class="icon-ctp" title="icon-ctp"></span>

			<span class="icon-blog" title="icon-blog"></span>
			<span class="icon-more" title="icon-more"></span>
			<span class="icon-devices" title="icon-devices"></span>
			<span class="icon-print" title="icon-print"></span>
			<span class="icon-search" title="icon-search"></span>
			<span class="icon-clock" title="icon-clock"></span>
			<span class="icon-tag" title="icon-tag"></span>
			<span class="icon-computer" title="icon-computer"></span>
			<span class="icon-tick-hollow" title="icon-tick-hollow"></span>

			<span class="icon-quote-start" title="icon-quote-start"></span>
			<span class="icon-quote-end" title="icon-quote-end"></span>

			<span class="icon-undo" title="icon-undo"></span>
			<span class="icon-trophy" title="icon-trophy"></span>
			<span class="icon-filter" title="icon-filter"></span>
			<span class="icon-cog" title="icon-cog"></span>
			<span class="icon-envelope-alt" title="icon-envelope-alt"></span>
			<span class="icon-envelope" title="icon-envelope"></span>
			<span class="icon-credit" title="icon-credit"></span>
			<span class="icon-star" title="icon-star"></span>
			<span class="icon-star-empty" title="icon-star-empty"></span>
			<span class="icon-th-list" title="icon-th-list"></span>
			<span class="icon-th-vert" title="icon-th-vert"></span>
			<span class="icon-reorder" title="icon-reorder"></span>
			<span class="icon-ellipsis-vertical" title="icon-ellipsis-vertical"></span>
			<span class="icon-ellipsis-horizontal" title="icon-ellipsis-horizontal"></span>
			<span class="icon-sort" title="icon-sort"></span>
			<span class="icon-angle-left" title="icon-angle-left"></span>
			<span class="icon-angle-right" title="icon-angle-right"></span>
			<span class="icon-angle-up" title="icon-angle-up"></span>
			<span class="icon-angle-down" title="icon-angle-down"></span>
			<span class="icon-calendar" title="icon-calendar"></span>
			<span class="icon-angle-down" title="icon-radio-empty"></span>
			<span class="icon-radio-selected" title="icon-radio-selected"></span>
			<span class="icon-arrow-thick-left" title="icon-arrow-thick-left"></span>
			<span class="icon-arrow-thick-right" title="icon-arrow-thick-right"></span>
			<span class="icon-arrow-thick-down" title="icon-arrow-thick-down"></span>
			<span class="icon-arrow-thick-up" title="icon-arrow-thick-up"></span>
		</div>
		<div class="col-xs-12" style="font-size:200%">
			<h3>Bigger!</h3>
			<span class="icon-tick" title="icon-tick"></span>
			<span class="icon-cross" title="icon-cross"></span>
			<span class="icon-info" title="icon-info"></span>
			<span class="icon-circle-cut" title="icon-circle-cut"></span>
			<span class="icon-arrow-left" title="icon-arrow-left"></span>
			<span class="icon-arrow-right" title="icon-arrow-right"></span>
			<span class="icon-arrow-down" title="icon-arrow-down"></span>
			<span class="icon-arrow-up" title="icon-arrow-up"></span>
			<span class="icon-phone" title="icon-phone"></span>
			<span class="icon-phone-hollow" title="icon-phone-hollow"></span>
			<span class="icon-car-solid" title="icon-car-solid"></span>
			<span class="icon-car" title="icon-car"></span>
			<span class="icon-plane-solid" title="icon-plane-solid"></span>
			<span class="icon-plane" title="icon-plane"></span>
			<span class="icon-money-solid" title="icon-money-solid"></span>
			<span class="icon-money" title="icon-money"></span>
			<span class="icon-heart-solid" title="icon-heart-solid"></span>
			<span class="icon-heart" title="icon-heart"></span>
			<span class="icon-house-solid" title="icon-house-solid"></span>
			<span class="icon-house" title="icon-house"></span>
			<span class="icon-health-solid" title="icon-health-solid"></span>
			<span class="icon-health" title="icon-health"></span>
			<span class="icon-travel" title="icon-travel"></span>
			<span class="icon-roadside" title="icon-roadside"></span>
			<span class="icon-life" title="icon-life"></span>
			<span class="icon-ip" title="icon-ip"></span>
			<span class="icon-home-loans" title="icon-home-loans"></span>
			<span class="icon-contents" title="icon-contents"></span>
			<span class="icon-home-contents" title="icon-home-contents"></span>
			<span class="icon-fuel" title="icon-fuel"></span>
			<span class="icon-energy" title="icon-energy"></span>
			<span class="icon-ctp" title="icon-ctp"></span>

			<span class="icon-blog" title="icon-blog"></span>
			<span class="icon-more" title="icon-more"></span>
			<span class="icon-devices" title="icon-devices"></span>
			<span class="icon-print" title="icon-print"></span>
			<span class="icon-search" title="icon-search"></span>
			<span class="icon-clock" title="icon-clock"></span>
			<span class="icon-tag" title="icon-tag"></span>
			<span class="icon-computer" title="icon-computer"></span>
			<span class="icon-tick-hollow" title="icon-tick-hollow"></span>
			<span class="icon-quote-start" title="icon-quote-start"></span>
			<span class="icon-quote-end" title="icon-quote-end"></span>

			<span class="icon-undo" title="icon-undo"></span>
			<span class="icon-trophy" title="icon-trophy"></span>
			<span class="icon-filter" title="icon-filter"></span>
			<span class="icon-cog" title="icon-cog"></span>
			<span class="icon-envelope-alt" title="icon-envelope-alt"></span>
			<span class="icon-envelope" title="icon-envelope"></span>
			<span class="icon-credit" title="icon-credit"></span>
			<span class="icon-star" title="icon-star"></span>
			<span class="icon-star-empty" title="icon-star-empty"></span>
			<span class="icon-th-list" title="icon-th-list"></span>
			<span class="icon-th-vert" title="icon-th-vert"></span>
			<span class="icon-reorder" title="icon-reorder"></span>
			<span class="icon-ellipsis-vertical" title="icon-ellipsis-vertical"></span>
			<span class="icon-ellipsis-horizontal" title="icon-ellipsis-horizontal"></span>
			<span class="icon-sort" title="icon-sort"></span>
			<span class="icon-angle-left" title="icon-angle-left"></span>
			<span class="icon-angle-right" title="icon-angle-right"></span>
			<span class="icon-angle-up" title="icon-angle-up"></span>
			<span class="icon-angle-down" title="icon-angle-down"></span>
			<span class="icon-calendar" title="icon-calendar"></span>
			<span class="icon-radio-empty" title="icon-radio-empty"></span>
			<span class="icon-radio-selected" title="icon-radio-selected"></span>
			<span class="icon-arrow-thick-left" title="icon-arrow-thick-left"></span>
			<span class="icon-arrow-thick-right" title="icon-arrow-thick-right"></span>
			<span class="icon-arrow-thick-down" title="icon-arrow-thick-down"></span>
			<span class="icon-arrow-thick-up" title="icon-arrow-thick-up"></span>
		</div>
	</div>
</form_new:fieldset>



<form_new:fieldset legend="'field' tags" className="">

	<form_new:row label="additional_excess">
		<field:additional_excess increment="100" minVal="500" xpath="quote/excess" maxCount="16" title="additional excess" required="" omitPleaseChoose="Y" />
	</form_new:row>

	<form_new:row label="age">
		<field:age dob="22/08/1970" />
	</form_new:row>

	<form_new:row label="<del>array_radio</del>">
		<field:array_radio items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadio" xpath="${xpath}/arrayRadio" title="array_radio" required="true" />
	</form_new:row>

	<form_new:row label="<del>array_select</del>">
		<field:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)" xpath="callmeback/save/time" title="array_select" required="true" />
	</form_new:row>

	<form_new:row label="birthday">
		<field:birthday dob="22/08/1970" />
	</form_new:row>

	<form_new:row label="button">
		<field:button xpath="quote_go" title="Search">Go</field:button>
	</form_new:row>

	<form_new:row label="cards_expiry">
		<field:cards_expiry rule="ccExp" xpath="${xpath}/expiry" title="cards_expiry" required="true" />
	</form_new:row>

	<form_new:row label="category_select" id="${categoryRow}">
		<field:category_select xpath="${xpath}/category" title="category" type="category" required="true" />
	</form_new:row>

	<form_new:row label="<del>checkbox</del>">
		<field:checkbox xpath="${xpath}/checkbox" value="Y" title="checkbox" required="true" label="true" errorMsg="errorMsg" theme="themeA" />
	</form_new:row>

	<form_new:row label="contact_mobile">
		<field:contact_mobile xpath="${xpath}/mobile" size="15" required="true" title="field:contact_mobile" labelName="contact mobile" placeHolderUnfocused="Unfocused placeholder text" />
	</form_new:row>

	<form_new:row label="contact_telno">
		<field:contact_telno xpath="${xpath}/otherNumber" title="field:contact_telno" required="true" />
	</form_new:row>

	<form_new:row label="count_select">
		<field_new:count_select xpath="${xpath}/day" min="1" max="27" step="1" title="field:count_select" required="true" />
	</form_new:row>

	<form_new:row label="customisable-checkbox">
		<field:customisable-checkbox xpath="${xpath}/optin" theme="replicaLarge" value="Y" required="true" label="true" title="field:customisable-checkbox" errorMsg="field:customisable-checkbox errorMsg" />
	</form_new:row>

	<form_new:row label="filler_row (not used?)">
		<field:filler_row xpath="" required="true" />
	</form_new:row>

	<form_new:row label="general_select">
		<field:general_select xpath="${xpath}/generalSelect" type="healthSitu" title="field:general_select" required="true" initialText="initialText" />
	</form_new:row>

	<form_new:row label="new_general_select">
		<field_new:general_select xpath="${xpath}/new/generalSelect" type="healthSitu" title="field:new_general_select" required="true" initialText="initialText" />
	</form_new:row>

	<form_new:row label="hidden">
		(two hidden inputs here)
		<field:hidden xpath="${xpath}/frequency" defaultValue="M" constantValue="M" />
		<field:hidden required="true" validationRule="validateMinDependants" validationMessage="field:hidden" defaultValue="" xpath="${xpath}/dependantrequired" />
	</form_new:row>

	<form_new:row label="ip_address (not used?)">
		<field:ip_address />
	</form_new:row>

	<form_new:row label="ip_number">
		<field:ip_number ip="127.0.0.1" />
	</form_new:row>

	<form_new:row label="make_select">
		<field:make_select xpath="${xpath}/make" title="field:make_select" type="make" required="true" />
	</form_new:row>

	<form_new:row label="password">
		<field:password xpath="save/password" required="true" title="field:password" minLength="6" onKeyUp="getElementById(\"field_password_test\").innerText=this.value;" />
		<span id="field_password_test" class="help-block">Type password; will appear here</span>
	</form_new:row>

	<form_new:row label="person_name">
		<field:person_name xpath="${xpath}/name" title="field:person_name" required="true" size="50" />
	</form_new:row>

	<form_new:row label="phone_number">
		<field:phone_number className="" required="true" xpath="foobar" placeHolder="xxx 000" title="field:phone_number" size="10" allowMobile="true" allowLandline="false" labelName="field:phone_number" />
	</form_new:row>

	<form_new:row label="post_code">
		<field:post_code xpath="${xpath}/postcode" title="field:post_code" required="true" />
	</form_new:row>

	<form_new:row label="provider_select">
		<field:provider_select productCategories="HEALTH" xpath="${xpath}/singleProvider" />
	</form_new:row>

	<form_new:row label="slider">
		<field:slider helpId="16" title="Excess: " id="health_excess2" value="4" />
	</form_new:row>

	<form_new:row label="state_select">
		<field:state_select xpath="${xpath}/identification/state" useFullNames="true" title="field:state_select" required="true" />
	</form_new:row>

	<form_new:row label="textarea">
		<field:textarea xpath="${xpath}/message" title="field:textarea" required="true" />
	</form_new:row>

	<form_new:row label="time_ago (not used?)">
		<field:time_ago time="11:43:12" />
	</form_new:row>

	<form_new:row label="vehicle_year">
		Disabled because I hate its autofocus
		<%-- <field:vehicle_year xpath="${xpath}/year" required="true" /> --%>
	</form_new:row>
</form_new:fieldset>



<form_new:fieldset legend="'field-new' tags" className="">
	<form_new:row label="account_number">
		<field_new:account_number xpath="${xpath}/new/accountNumber" title="account number" minLength="5" maxLength="9" required="true" />
	</form_new:row>

	<form_new:row label="group_new:address">
		<group_new:address xpath="new/group/address" type="RES" />
	</form_new:row>

	<form_new:row label="array_radio">
		<field_new:array_radio items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadio" xpath="${xpath}/new/arrayRadio" title="array_radio" required="true" />
	</form_new:row>

	<form_new:row label="array_radio (inline)">
		<field_new:array_radio style="inline" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioInline" xpath="${xpath}/new/arrayRadioInline" title="array_radio_inline" required="true" />
	</form_new:row>

	<form_new:row label="array_radio (grouped)">
		<field_new:array_radio style="group" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioGroup" xpath="${xpath}/new/arrayRadioGroup" title="array_radio_group" required="true" />
	</form_new:row>

	<form_new:row label="bsb_number" helpId="1">
		<field_new:bsb_number xpath="${xpath}/new/bsb" title="bsb number" required="true" />
	</form_new:row>

	<form_new:row label="checkbox">
		<field_new:checkbox xpath="${xpath}/new/checkbox" value="Y" title="checkbox label" required="true" label="true" errorMsg="errorMsg" theme="themeA" />
		<field_new:checkbox xpath="${xpath}/new/checkbox2" value="Y" title="second checkbox" required="true" label="true" errorMsg="errorMsg" />
		<field_new:checkbox xpath="${xpath}/new/checkboxDisabled" value="Y" title="disabled" required="true" label="true" errorMsg="errorMsg" />
		<field_new:checkbox xpath="${xpath}/new/checkboxDisabled2" value="Y" title="disabled checked" required="true" label="true" errorMsg="errorMsg" />
		<go:script marker="onready">
			$('#${go:nameFromXpath(xpath)}_new_checkboxDisabled, #${go:nameFromXpath(xpath)}_new_checkboxDisabled2').prop('disabled', true);
			$('#${go:nameFromXpath(xpath)}_new_checkboxDisabled2').prop('checked', true);
		</go:script>
	</form_new:row>


	<form_new:row label="creditcard_number" legend="This is a legend">
		<field_new:creditcard_number xpath="${xpath}/new/cardNumber" title="field_new:creditcard_number" required="true" />
	</form_new:row>

	<form_new:row label="creditcard_ccv">
		<field_new:creditcard_ccv xpath="${xpath}/new/cardCCV"  required="true" />
	</form_new:row>

	<form_new:row label="currency">
		<field_new:currency xpath="currency_example"
				required="false"
				title="Currency"
				className=""
				minValue="1000"
				decimal="${false}"
				defaultValue="0"/>

		<go:script marker="onready">meerkat.modules.currencyField.initCurrency();</go:script>
	</form_new:row>

	<form_new:row label="filter_excess ">
		<health:filter_excess xpath="${xpath}/new/filterExcess" />
		<%-- <field:hidden xpath="health/excess" defaultValue="3" /> --%>
		<input type="hidden" value="3" class="" id="health_excess" name="health_excess">
	</form_new:row>

	<form_new:row label="filter_price">
		<health:filter_price xpath="${xpath}/new/filterPrice" />
	</form_new:row>

	<form_new:row label="input">
		<field_new:input xpath="${xpath}/new/input" title="input" required="true" maxlength="20" />
	</form_new:row>

	<form_new:row label="input (search)">
		<field_new:input type="search" xpath="${xpath}/new/inputSearch" title="input" required="true" />
	</form_new:row>

	<form_new:row label="input (email)">
		<field_new:input type="email" xpath="${xpath}/new/inputEmail" title="input" required="true" />
	</form_new:row>

	<form_new:row label="input (number)">
		<field_new:input type="number" xpath="${xpath}/new/inputNumber" title="input" required="true" />
	</form_new:row>

	<form_new:row label="input (tel)">
		<field_new:input type="tel" xpath="${xpath}/new/inputTel" title="input" required="true" />
	</form_new:row>

	<form_new:row label="input (date)">
		<go:setData dataVar="data" xpath="${xpath}/new/inputDate" value="2011-01-27" />

		<field_new:input type="date" xpath="${xpath}/new/inputDate" title="input" required="true" />
		<script>
			if (Modernizr.inputtypes.date) {
				document.write('<p>Modernizr says input[type="date"] is supported</p>');
			} else {
				document.write('<p>Modernizr says input[type="date"] is NOT supported</p>');
			}
	<%--	if ($('#_new_inputDate').is(':disabled')) {
				document.write('<p>Input is disabled...?</p>');
			}
			$('#_new_inputDate').on('change', function() {
				$('#inputDate_val').text('Changed. ' + this.value);
			});
			$('#_new_inputDate').on('focus', function() {
				$('#inputDate_val').text('Focus. ' + this.value);
			});
			$(document).ready(function() {
				alert('iOS: ' + Modernizr.iOS + '\nAndroid: ' + Modernizr.Android + '\nChrome: ' + Modernizr.Chrome);
			});
	--%>
			document.write('<p>User agent: ' + navigator.userAgent + '</p>');
		</script>
		<p id="inputDate_val"></p>
	</form_new:row>

	<form_new:row label="input_age">
		<field_new:input_age validationNoun="traveller" maxlength="2" xpath="${xpath}/new/inputAge" title="field_new:input_age" required="true" />
	</form_new:row>

	<form_new:row label="medicare_number">
		<field_new:medicare_number xpath="${xpath}/new/medicareNumber" required="true" title="field:medicare_number" />
	</form_new:row>

	<form_new:row label="name_on_card">
		<field_new:name_on_card xpath="${xpath}/new/cardName" title="field:name_on_card" required="true" />
	</form_new:row>

	<form_new:row label="payment_type">
		<field_new:payment_type xpath="${xpath}/new/paymentType" title="field:payment_type" />
	</form_new:row>

	<form_new:row label="person_dob">
		<field_new:person_dob xpath="${xpath}/new/dob" required="true" title="field:person_dob" ageMax="85" ageMin="16" />
	</form_new:row>

	<form_new:row label="calendar">
		<field_new:calendar xpath="${xpath}/new/calendar" required="true" title="start date" />
	</form_new:row>

	<form_new:row label="basic_date">
		<field_new:basic_date xpath="${xpath}/new/basic_date" required="true" title="Basic date" />
	</form_new:row>


	<form_new:row label="lookup_suburb_postcode">
		<field_new:lookup_suburb_postcode xpath="${xpath}/new/location" required="true" placeholder="Suburb / Postcode" />
	</form_new:row>

	<core:select_tags
		variableListName="countrySelectionList"
		variableListArray="{ 'options': [{ 'value': 'VAL', 'text': 'Hello' }, { 'value': 'VAL2', 'text': 'Hello2' }, { 'value': 'VAL3', 'text': 'Hello3' }] }"
		xpath="travel/destinations"
		xpathhidden="travel/destination"
		label="Country"
		title="Where are you travelling?"
		validationErrorPlacementSelector=".travel_details_destinations"
		/>

	<form_new:row label="slider">
	<div style="background:#f8f8f8; padding:10px">
		<field_new:slider xpath="${xpath}/new/sliderExcess" type="excess" value="2" range="1,5" markers="5" legend="None,$250,$500,$750,All" />
		<field_new:slider xpath="${xpath}/new/sliderPrice" type="price" value="550" range="100,650" legend="NONE,BASIC,MEDIUM,COMPREHENSIVE" />
	</div>
	</form_new:row>

	<form_new:row label="switch">
		<%-- <field_new:switch xpath="${xpath}/new/switch" value="Y" className="switch-normal" /> --%>
		<field_new:switch xpath="${xpath}/new/switch2" value="Y" required="true" />
		<field_new:switch xpath="${xpath}/new/switch3" value="Y" />
		<field_new:switch xpath="${xpath}/new/switch4" value="Y" />
		<go:script marker="onready">
			$('#${go:nameFromXpath(xpath)}_new_switch3, #${go:nameFromXpath(xpath)}_new_switch4').bootstrapSwitch('setDisabled', true); //.prop('disabled', true);
			$('#${go:nameFromXpath(xpath)}_new_switch4').prop('checked', true).change();
		</go:script>
	</form_new:row>

	<form_new:row>
		<div class="inlineHeadingWithButton">
			<h5>Dependant ${count}</h5> <a href="javascript:void(0);" class="remove-last-dependent btn btn-danger" title="Remove last dependent">Remove Dependant</a>
		</div>
	</form_new:row>


	<form_new:row label="array_select">
		<field_new:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)" xpath="callmeback/save/time" title="array_select" required="true" />
	</form_new:row>


</form_new:fieldset>

<form_new:fieldset legend="Function based buttons">
	<form_new:row label="btn btn-back">
		<a class="btn btn-back" href="javascript:;">Button text</a>
		<a class="btn btn-sm btn-back" href="javascript:;">Button with btn-sm</a>
		<a class="btn btn-block btn-back" href="javascript:;">Button with btn-block</a>
		<a class="btn btn-sm btn-block btn-back" href="javascript:;">Button with btn-sm and btn-block</a>
	</form_new:row>
	<form_new:row label="btn btn-email">
		<a class="btn btn-email" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-dropdown">
		<a class="btn btn-dropdown" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-">
		<a class="btn btn-" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-pagination">
		<a class="btn btn-pagination" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-save">
		<a class="btn btn-" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-save">
		<a class="btn btn-" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-cancel">
		<a class="btn btn-cancel" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-next">
		<a class="btn btn-next" href="javascript:;">Button text <span class="icon icon-arrow-right"></span></a>
	</form_new:row>
	<form_new:row label="btn btn-cta">
		<a class="btn btn-cta" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-shortlist">
		<a class="btn btn-shortlist" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-clear">
		<a class="btn btn-clear" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-download">
		<a class="btn btn-download" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-compare-clear">
		<a class="btn btn-compare-clear" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-features-compare">
		<a class="btn btn-features-compare" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-edit">
		<a class="btn btn-edit" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-hollow (transparent)">
		<div style="background-color: #1c3e93;">
			<a class="btn btn-hollow" href="javascript:;">Button text</a>
		</div>
	</form_new:row>
	<form_new:row label="btn btn-hollow-inverse (transparent)">
		<div style="background-color: #1c3e93;">
			<a class="btn btn-hollow-inverse" href="javascript:;">Button text</a>
		</div>
	</form_new:row>
	<form_new:row label="btn btn-hollow-red">
		<a class="btn btn-hollow-red" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-call">
		<a class="btn btn-call" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-call-inverse">
		<a class="btn btn-call-inverse" href="javascript:;">Button text</a>
	</form_new:row>

</form_new:fieldset>

<form_new:fieldset legend="Mostly Deprecated Buttons">
	<form_new:row label="btn btn-default">
		<a class="btn btn-default" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-primary">
		<a class="btn btn-primary" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-secondary">
		<a class="btn btn-secondary" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-tertiary">
		<a class="btn btn-tertiary" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-info">
		<a class="btn btn-info" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-success">
		<a class="btn btn-success" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-warning">
		<a class="btn btn-warning" href="javascript:;">Button text</a>
	</form_new:row>
	<form_new:row label="btn btn-danger">
		<a class="btn btn-danger" href="javascript:;">Button text</a>
	</form_new:row>
</form_new:fieldset>


<form_new:fieldset legend="'form' tags">
	<form_new:row label="form:submit_button (not used?)">
		<form:submit_button label="Submit" />
	</form_new:row>

	<form_new:row label="form:submit_quote (not used?)">
		<form:submit_quote label="Submit" />
	</form_new:row>
</form_new:fieldset>