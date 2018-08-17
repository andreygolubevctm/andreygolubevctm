<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />

<p>Tags with a <del>deleted</del> title indicate they have been replaced (e.g. into a field-new version) due to changes, such as markup, that may introduce instability in current verticals.</p>

<%--
<div style="position:relative;height:200px;width:700px;">
<field_v2:creditcard_assurance_message showCreditCards="true" />
</div>
--%>

<form_v2:fieldset legend="'ui' tags" className="">
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
</form_v2:fieldset>



<form_v2:fieldset legend="CTM icon font" className="">
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
			<span class="icon-radio-empty" title="icon-radio-empty"></span>
			<span class="icon-radio-selected" title="icon-radio-selected"></span>
			<span class="icon-arrow-thick-left" title="icon-arrow-thick-left"></span>
			<span class="icon-arrow-thick-right" title="icon-arrow-thick-right"></span>
			<span class="icon-arrow-thick-down" title="icon-arrow-thick-down"></span>
			<span class="icon-arrow-thick-up" title="icon-arrow-thick-up"></span>
			<span class="icon-single" title="icon-single"></span>
			<span class="icon-couple" title="icon-couple"></span>
			<span class="icon-family" title="icon-family"></span>
			<span class="icon-single-family" title="icon-single-family"></span>
			<span class="icon-group" title="icon-group"></span>
			<span class="icon-dollar" title="icon-dollar"></span>
			<span class="icon-plus" title="icon-plus"></span>
			<span class="icon-minus" title="icon-minus"></span>
			<span class="icon-callback" title="icon-callback"></span>
			<span class="icon-pencil" title="icon-pencil"></span>
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
			<span class="icon-pet" title="icon-pet"></span>
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
			<span class="icon-single" title="icon-single"></span>
			<span class="icon-couple" title="icon-couple"></span>
			<span class="icon-family" title="icon-family"></span>
			<span class="icon-single-family" title="icon-single-family"></span>
			<span class="icon-group" title="icon-group"></span>
			<span class="icon-dollar" title="icon-dollar"></span>
			<span class="icon-plus" title="icon-plus"></span>
			<span class="icon-minus" title="icon-minus"></span>
			<span class="icon-vert-hnc" title="icon-vert-hnc"></span>
			<span class="icon-vert-ctp" title="icon-vert-ctp"></span>
			<span class="icon-vert-energy" title="icon-vert-energy"></span>
			<span class="icon-vert-fuel" title="icon-vert-fuel"></span>
			<span class="icon-vert-ip" title="icon-vert-ip"></span>
			<span class="icon-vert-roadside" title="icon-vert-roadside"></span>
			<span class="icon-vert-car" title="icon-vert-car"></span>
			<span class="icon-vert-health" title="icon-vert-health"></span>
			<span class="icon-vert-home" title="icon-vert-home"></span>
			<span class="icon-vert-life" title="icon-vert-life"></span>
			<span class="icon-vert-money" title="icon-vert-money"></span>
			<span class="icon-vert-travel" title="icon-vert-travel"></span>
			<span class="icon-vert-pet" title="icon-vert-pet"></span>
			<span class="icon-callback" title="icon-callback"></span>
			<span class="icon-pencil" title="icon-pencil"></span>
		</div>
	</div>
</form_v2:fieldset>



<form_v2:fieldset legend="'field' tags" className="">

	<form_v2:row label="additional_excess">
		<field_v1:additional_excess increment="100" minVal="500" xpath="quote/excess" maxCount="16" title="additional excess" required="" omitPleaseChoose="Y" />
	</form_v2:row>

	<form_v2:row label="age">
		<field_v1:age dob="22/08/1970" />
	</form_v2:row>

	<form_v2:row label="birthday">
		<field_v1:birthday dob="22/08/1970" />
	</form_v2:row>

	<form_v2:row label="button">
		<field_v1:button xpath="quote_go" title="Search">Go</field_v1:button>
	</form_v2:row>

	<form_v2:row label="cards_expiry">
		<field_v1:cards_expiry rule="ccExp" xpath="${xpath}/expiry" title="cards_expiry" required="true" />
	</form_v2:row>

	<form_v2:row label="category_select" id="${categoryRow}">
		<field_v1:category_select xpath="${xpath}/category" title="category" type="category" required="true" />
	</form_v2:row>

	<form_v2:row label="contact_mobile">
		<field_v1:contact_mobile xpath="${xpath}/mobile" size="15" required="true" title="field:contact_mobile" labelName="contact mobile" placeHolderUnfocused="Unfocused placeholder text" />
	</form_v2:row>

	<form_v2:row label="contact_telno">
		<field_v1:contact_telno xpath="${xpath}/otherNumber" title="field:contact_telno" required="true" />
	</form_v2:row>

	<form_v2:row label="flexi_contact_number">
		<field_v1:flexi_contact_number xpath="${xpath}/flexiNumber" title="field:flexi_contact_number" required="true" maxLength="20"/>
	</form_v2:row>

	<form_v2:row label="count_select">
		<field_v2:count_select xpath="${xpath}/day" min="1" max="27" step="1" title="field:count_select" required="true" />
	</form_v2:row>

	<form_v2:row label="customisable-checkbox">
		<field_v1:customisable-checkbox xpath="${xpath}/optin" theme="replicaLarge" value="Y" required="true" label="true" title="field:customisable-checkbox" errorMsg="field:customisable-checkbox errorMsg" />
	</form_v2:row>

	<form_v2:row label="filler_row (not used?)">
		<field_v1:filler_row xpath="" required="true" />
	</form_v2:row>

	<form_v2:row label="new_general_select">
		<field_v2:general_select xpath="${xpath}/new/generalSelect" type="healthSitu" title="field:new_general_select" required="true" initialText="initialText" />
	</form_v2:row>

	<form_v2:row label="hidden">
		(two hidden inputs here)
		<field_v1:hidden xpath="${xpath}/frequency" defaultValue="M" constantValue="M" />
		<field_v1:hidden required="true" validationRule="validateMinDependants" validationMessage="field:hidden" defaultValue="" xpath="${xpath}/dependantrequired" />
	</form_v2:row>

	<form_v2:row label="ip_address (not used?)">
		<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />
		<%-- Pull out the IP Address --%>
		<c:set var="ip" value="${ipAddressHandler.getIPAddress(pageContext.request)}" />
		<c:out value="${ip}" />
	</form_v2:row>

	<form_v2:row label="ip_number">
		<field_v1:ip_number ip="127.0.0.1" />
	</form_v2:row>

	<form_v2:row label="password">
		<field_v1:password xpath="save/password" required="true" title="field:password" minLength="6" onKeyUp="getElementById(\"field_password_test\").innerText=this.value;" />
		<span id="field_password_test" class="help-block">Type password; will appear here</span>
	</form_v2:row>

	<form_v2:row label="person_name">
		<field_v1:person_name xpath="${xpath}/name" title="field:person_name" required="true" size="50" />
	</form_v2:row>

	<form_v2:row label="phone_number">
		<field_v1:phone_number className="" required="true" xpath="foobar" placeHolder="xxx 000" title="field:phone_number" size="10" allowMobile="true" allowLandline="false" labelName="field:phone_number" />
	</form_v2:row>

	<form_v2:row label="post_code">
		<field_v1:post_code xpath="${xpath}/postcode" title="field:post_code" required="true" />
	</form_v2:row>

	<form_v2:row label="provider_select">
		<field_v1:provider_select productCategories="HEALTH" xpath="${xpath}/singleProvider" />
	</form_v2:row>

	<form_v2:row label="slider">
		<field_v1:slider helpId="16" title="Excess: " id="health_excess2" value="4" />
	</form_v2:row>

	<form_v2:row label="state_select">
		<field_v1:state_select xpath="${xpath}/identification/state" useFullNames="true" title="field:state_select" required="true" />
	</form_v2:row>

	<form_v2:row label="textarea">
		<field_v1:textarea xpath="${xpath}/message" title="field:textarea" required="true" />
	</form_v2:row>

	<form_v2:row label="time_ago (not used?)">
		<field_v1:time_ago time="11:43:12" />
	</form_v2:row>

	<form_v2:row label="vehicle_year">
		Disabled because I hate its autofocus
		<%-- <field_v1:vehicle_year xpath="${xpath}/year" required="true" /> --%>
	</form_v2:row>
</form_v2:fieldset>



<form_v2:fieldset legend="'field-new' tags" className="">
	<form_v2:row label="account_number">
		<field_v2:account_number xpath="${xpath}/new/accountNumber" title="account number" minLength="5" maxLength="9" required="true" />
	</form_v2:row>

	<form_v2:row label="group_v2:elastic_address">
		<group_v2:elastic_address xpath="new/group/address" type="RES" />
	</form_v2:row>

	<form_v2:row label="array_radio">
		<field_v2:array_radio items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadio" xpath="${xpath}/new/arrayRadio" title="array_radio" required="true" />
	</form_v2:row>

	<form_v2:row label="array_radio (inline)">
		<field_v2:array_radio style="inline" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioInline" xpath="${xpath}/new/arrayRadioInline" title="array_radio_inline" required="true" />
	</form_v2:row>

	<form_v2:row label="array_radio (grouped)">
		<field_v2:array_radio style="group" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioGroup" xpath="${xpath}/new/arrayRadioGroup" title="array_radio_group" required="true" />
	</form_v2:row>

	<form_v2:row label="array_radio (horizontal)">
		<field_v2:array_radio style="horizontal" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioHorizontal" xpath="${xpath}/new/arrayRadioHorizontal" title="array_radio_horizontal" required="true" />
	</form_v2:row>

	<form_v2:row label="array_radio (vertical)">
		<field_v2:array_radio style="vertical" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioVertical" xpath="${xpath}/new/arrayRadioVertical" title="array_radio_vertical" required="true" />
	</form_v2:row>

	<form_v2:row label="array_radio (group-tile)">
		<field_v2:array_radio style="group-tile" items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_arrayRadioGroupTile" xpath="${xpath}/new/arrayRadioGroupTile" title="array_radio_group_tile" required="true" />
	</form_v2:row>

	<form_v2:row label="bsb_number" helpId="1">
		<field_v2:bsb_number xpath="${xpath}/new/bsb" title="bsb number" required="true" />
	</form_v2:row>

	<form_v2:row label="checkbox">
		<field_v2:checkbox xpath="${xpath}/new/checkbox" value="Y" title="checkbox label" required="true" label="true" errorMsg="errorMsg" theme="themeA" />
		<field_v2:checkbox xpath="${xpath}/new/checkbox2" value="Y" title="second checkbox" required="true" label="true" errorMsg="errorMsg" />
		<field_v2:checkbox xpath="${xpath}/new/checkboxDisabled" value="Y" title="disabled" required="true" label="true" errorMsg="errorMsg" />
		<field_v2:checkbox xpath="${xpath}/new/checkboxDisabled2" value="Y" title="disabled checked" required="true" label="true" errorMsg="errorMsg" />
		<go:script marker="onready">
			$('#${go:nameFromXpath(xpath)}_new_checkboxDisabled, #${go:nameFromXpath(xpath)}_new_checkboxDisabled2').prop('disabled', true);
			$('#${go:nameFromXpath(xpath)}_new_checkboxDisabled2').prop('checked', true);
		</go:script>
	</form_v2:row>


	<form_v2:row label="creditcard_number" legend="This is a legend">
		<field_v2:creditcard_number xpath="${xpath}/new/cardNumber" title="field_v2:creditcard_number" required="true" />
	</form_v2:row>

	<form_v2:row label="creditcard_ccv">
		<field_v2:creditcard_ccv xpath="${xpath}/new/cardCCV"  required="true" />
	</form_v2:row>

	<form_v2:row label="currency">
		<field_v2:currency xpath="currency_example"
				required="false"
				title="Currency"
				className=""
				minValue="1000"
				decimal="${false}"
				defaultValue="0"/>
		<%-- Onready needed here, as there is not a dynamic.jsp module setup --%>
		<go:script marker="onready">meerkat.modules.currencyField.initCurrency();</go:script>
	</form_v2:row>

	<form_v2:row label="filter_excess ">
		<health_v1:filter_excess xpath="${xpath}/new/filterExcess" />
		<%-- <field_v1:hidden xpath="health/excess" defaultValue="3" /> --%>
		<input type="hidden" value="3" class="" id="health_excess" name="health_excess">
	</form_v2:row>

	<form_v2:row label="filter_price">
		<health_v1:filter_price xpath="${xpath}/new/filterPrice" />
	</form_v2:row>

	<form_v2:row label="input">
		<field_v2:input xpath="${xpath}/new/input" title="input" required="true" maxlength="20" />
	</form_v2:row>

	<form_v2:row label="input (search)">
		<field_v2:input type="search" xpath="${xpath}/new/inputSearch" title="input" required="true" />
	</form_v2:row>

	<form_v2:row label="input (email)">
		<field_v2:input type="email" xpath="${xpath}/new/inputEmail" title="input" required="true" />
	</form_v2:row>

	<form_v2:row label="input (number)">
		<field_v2:input type="number" xpath="${xpath}/new/inputNumber" title="input" required="true" />
	</form_v2:row>

	<form_v2:row label="input (tel)">
		<field_v2:input type="tel" xpath="${xpath}/new/inputTel" title="input" required="true" />
	</form_v2:row>

	<form_v2:row label="input (date)">
		<go:setData dataVar="data" xpath="${xpath}/new/inputDate" value="2011-01-27" />

		<field_v2:input type="date" xpath="${xpath}/new/inputDate" title="input" required="true" />
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
	</form_v2:row>

	<form_v2:row label="medicare_number">
		<field_v2:medicare_number xpath="${xpath}/new/medicareNumber" required="true" title="field:medicare_number" />
	</form_v2:row>

	<form_v2:row label="name_on_card">
		<field_v2:name_on_card xpath="${xpath}/new/cardName" title="field:name_on_card" required="true" />
	</form_v2:row>

	<form_v2:row label="payment_type">
		<field_v2:payment_type xpath="${xpath}/new/paymentType" title="field:payment_type" />
	</form_v2:row>

	<form_v2:row label="person_dob">
		<field_v2:person_dob xpath="${xpath}/new/dob" required="true" title="field:person_dob" ageMax="85" ageMin="16" />
	</form_v2:row>

	<form_v2:row label="calendar">
		<field_v2:calendar xpath="${xpath}/new/calendar" required="true" title="start date" />
	</form_v2:row>

	<form_v2:row label="basic_date">
		<field_v2:basic_date xpath="${xpath}/new/basic_date" required="true" title="Basic date" />
	</form_v2:row>


	<form_v2:row label="lookup_suburb_postcode">
		<field_v2:lookup_suburb_postcode xpath="${xpath}/new/location" required="true" placeholder="Suburb / Postcode" />
	</form_v2:row>

	<core_v1:select_tags
		variableListName="countrySelectionList"
		variableListArray="{ 'options': [{ 'value': 'VAL', 'text': 'Hello' }, { 'value': 'VAL2', 'text': 'Hello2' }, { 'value': 'VAL3', 'text': 'Hello3' }] }"
		xpath="travel/destinations"
		xpathhidden="travel/destination"
		label="Country"
		title="Where are you travelling?"
		validationErrorPlacementSelector=".travel_details_destinations"
		/>

	<form_v2:row label="slider">
	<div style="background:#f8f8f8; padding:10px">
		<field_v2:slider xpath="${xpath}/new/sliderExcess" type="excess" value="2" range="1,5" markers="5" legend="None,$250,$500,$750,All" />
		<field_v2:slider xpath="${xpath}/new/sliderPrice" type="price" value="550" range="100,650" legend="NONE,BASIC,MEDIUM,COMPREHENSIVE" />
	</div>
	</form_v2:row>

	<form_v2:row>
		<div class="inlineHeadingWithButton">
			<h5>Dependant ${count}</h5> <a href="javascript:void(0);" class="remove-last-dependent btn btn-danger" title="Remove last dependent">Remove Dependant</a>
		</div>
	</form_v2:row>


	<form_v2:row label="array_select">
		<field_v2:array_select items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)" xpath="callmeback/save/time" title="array_select" required="true" />
	</form_v2:row>


</form_v2:fieldset>

<form_v2:fieldset legend="Function based buttons">
	<form_v2:row label="btn btn-back">
		<a class="btn btn-back" href="javascript:;">Button text</a>
		<a class="btn btn-sm btn-back" href="javascript:;">Button with btn-sm</a>
		<a class="btn btn-block btn-back" href="javascript:;">Button with btn-block</a>
		<a class="btn btn-sm btn-block btn-back" href="javascript:;">Button with btn-sm and btn-block</a>
	</form_v2:row>
	<form_v2:row label="btn btn-email">
		<a class="btn btn-email" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-dropdown">
		<a class="btn btn-dropdown" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-pagination">
		<a class="btn btn-pagination" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-save">
		<a class="btn btn-save" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-cancel">
		<a class="btn btn-cancel" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-next">
		<a class="btn btn-next" href="javascript:;">Button text <span class="icon icon-arrow-right"></span></a>
	</form_v2:row>
	<form_v2:row label="btn btn-cta">
		<a class="btn btn-cta" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-shortlist">
		<a class="btn btn-shortlist" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-clear">
		<a class="btn btn-clear" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-download">
		<a class="btn btn-download" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-compare-clear">
		<a class="btn btn-compare-clear" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-features-compare">
		<a class="btn btn-features-compare" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-edit">
		<a class="btn btn-edit" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-hollow (transparent)">
		<div style="background-color: #1c3e93;">
			<a class="btn btn-hollow" href="javascript:;">Button text</a>
		</div>
	</form_v2:row>
	<form_v2:row label="btn btn-hollow-inverse (transparent)">
		<div style="background-color: #1c3e93;">
			<a class="btn btn-hollow-inverse" href="javascript:;">Button text</a>
		</div>
	</form_v2:row>
	<form_v2:row label="btn btn-hollow-red">
		<a class="btn btn-hollow-red" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-call">
		<a class="btn btn-call" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-call-inverse">
		<a class="btn btn-call-inverse" href="javascript:;">Button text</a>
	</form_v2:row>

</form_v2:fieldset>

<form_v2:fieldset legend="Mostly Deprecated Buttons">
	<form_v2:row label="btn btn-default">
		<a class="btn btn-default" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-primary">
		<a class="btn btn-primary" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-secondary">
		<a class="btn btn-secondary" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-tertiary">
		<a class="btn btn-tertiary" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-info">
		<a class="btn btn-info" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-success">
		<a class="btn btn-success" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-warning">
		<a class="btn btn-warning" href="javascript:;">Button text</a>
	</form_v2:row>
	<form_v2:row label="btn btn-danger">
		<a class="btn btn-danger" href="javascript:;">Button text</a>
	</form_v2:row>
</form_v2:fieldset>


<form_v2:fieldset legend="'form' tags">
	<form_v2:row label="form:submit_button (not used?)">
		<form_v1:submit_button label="Submit" />
	</form_v2:row>

	<form_v2:row label="form:submit_quote (not used?)">
		<form_v1:submit_quote label="Submit" />
	</form_v2:row>
</form_v2:fieldset>