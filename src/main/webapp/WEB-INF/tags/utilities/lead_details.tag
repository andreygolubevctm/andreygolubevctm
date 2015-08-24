<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Lead Feed group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name"		value="${go:nameFromXpath(xpath)}" />

<%-- PARAMETERS --%>
<c:set var="postcode"><c:out value="${param.postcode}" escapeXml="true" /></c:set>
<c:set var="privacyLink" value="<a href='javascript:void(0);' onclick='${name}InfoDialog.open()'>privacy statement</a>" />
<c:set var="label_text" value="I understand comparethemarket.com.au compares energy plans<br>based on a standard tariff from a range of participating retailers.<br>By providing my contact details I agree that comparethemarket.com.au<br>and its partner Thought World may contact me about the services<br>they provide. I confirm that I have read the ${privacyLink}." />
<c:set var="error_text" value="Please confirm you have read the privacy statement" />

<%-- HTML --%>
<div id="${name}" class="${name}">

	<form:fieldset legend="Your Details">

		<form:row label="Postcode / Suburb">

			<c:set var="autocompleteSource">
				function( request, response ) {

					authorizedCharacters = /^[a-z0-9\s]+$/i;

					// don't search if the value matches the format we aim for
					if( authorizedCharacters.test( $('#${name}_location').val() ) ){

						$.ajax({
							url: "ajax/json/get_suburbs.jsp",
							data: {
									term: request.term
								},
							success: function( data ) {
								response( $.map( data, function( item ) {
									if( item.length != undefined ){

										var splitItem = AutoCompleteHandler.splitItem( item );

										var label = splitItem.postcode + " - " + splitItem.suburb + ", " + splitItem.state;

										if( data.length == 1 ) {
											$('#${name}_location').val(label);
											$('#${name} #${name}_postcode').val(splitItem.postcode).trigger('change');
											$('#${name} #${name}_suburb').val(splitItem.suburb);
											$('#${name} #${name}_state').val(splitItem.state).trigger('change');
										}

										return {
											label: label,
											value: item
										}
									} else {
										return data;
									}
								}));
							}
						});

					} else {
						$('#${name}_location').autocomplete("close");
					}

				}
			</c:set>
			<c:set var="autocompleteSelect">
				function( event, ui ) {
					log( ui.item ?
						"Selected: " + ui.item.value + " aka " + ui.item.id :
						"Nothing selected, input was " + this.value );

					if(ui.item){
						splitItem = AutoCompleteHandler.splitItem( ui.item.value );

						$('#${name} #${name}_postcode').val(splitItem.postcode).trigger('change');
						$('#${name} #${name}_suburb').val(splitItem.suburb);
						$('#${name} #${name}_state').val(splitItem.state).trigger('change');

						// forcing the field's value
						$('#${name} #${name}_location').val( ui.item.label );

						if( $('#${name} #${name}_location').hasClass("error") ){
							$("#mainform").validate().element('#${name} #${name}_location');
						}

						return false;
					}
				}
			</c:set>

			<field:suburb_postcode xpath="${xpath}/location" title="Postcode/Suburb" id=""
				required="true"  source="${autocompleteSource}" select="${autocompleteSelect}"  />
			<field:hidden xpath="${xpath}/postcode" required="false" />
			<field:hidden xpath="${xpath}/suburb" required="false" />
			<field:hidden xpath="${xpath}/state" required="false" />
		</form:row>


	<form:row label="First name">
			<field:input xpath="${xpath}/firstName" title="First name" required="true" maxlength="50"/>
		</form:row>

		<form:row label="Last name">
			<field:input xpath="${xpath}/lastName" title="Last name" required="true" maxlength="50"/>
		</form:row>

		<form:row label="Mobile number">
			<field:contact_mobile xpath="${xpath}/mobileNumber" required="false" />
		</form:row>

		<form:row label="Other phone number">
			<field:contact_telno xpath="${xpath}/otherPhoneNumber" required="false" title="other phone number" isLandline="true" />
		</form:row>

		<form:row label="Your email address">
			<field:contact_email xpath="${xpath}/email" required="false" title="your email address" />
		</form:row>


		<form:row label="" id="${name}-row">
			<field:checkbox
				xpath="${xpath}/privacyoptin"
				value="Y"
				title="${label_text}"
				errorMsg="${error_text}"
				required="true"
				label="true"
			/>
		</form:row>

		<ui:dialog id="${name}Info" width="400" titleDisplay="false">
		Your privacy is important to us. And you may be wondering about the information we are collecting when you get quotes and compare products on our site.<br/><br/>
		The information we collect depends on what products and quotes you are comparing and without this information, we wouldn&#39;t be able to offer our service. Information about persons named must be given with their consent. We use your information, some of which may be sensitive, to provide you with quotes and/or comparisons. If you choose to apply for a product, we&#39ll pass this information on to the chosen product provider. We may also use it to keep you up&#45;to&#45;date with our services and products.
		<br/><br/>
		Your personal information (but not your sensitive information) may be held by some of our service providers in an overseas location, the details of which can be found in our privacy policy. In this privacy policy, you can also find out more about the information we hold and how to correct it, as well as how to make a complaint and how this complaint will be handled.&nbsp;&nbsp;<a href="${pageSettings.getSetting('privacyPolicyUrl')}" target="_blank">View Privacy Policy</a>
		</ui:dialog>

	</form:fieldset>

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} .fieldrow_value.dollar {
		position: relative;
	}

	#${name} .fieldrow_value.dollar input {
		padding-left: 11px;
	}

	#${name} .fieldrow_value.dollar span {
		position: absolute;
		width: 10px;
		height: 12px;
		top: 9px;
		left: 4px;
	}

	#${name} #${name}_location{
		width: 275px;
	}

	#${name}InfoDialog a,
	#${name}-row a {
		font-size: 100% !important;
	}
	#${name}-row label {
		margin-left: 5px;
	}

	.${name}InfoDialogContainer.ui-dialog .ui-dialog-content,
	#participatingSuppliersDialog {
		padding: 22px;
	}

	.${name}InfoDialogContainer.ui-dialog .ui-dialog-content {
		text-align: justify;
	}

</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">

var AutoCompleteHandler = new Object();
AutoCompleteHandler = {

	splitItem: function(item){

		splitItemArray = item.split(' ');
		var state = splitItemArray[splitItemArray.length-1];
		splitItemArray.splice(splitItemArray.length-1, 1);

		var postcode = splitItemArray[splitItemArray.length-1];
		splitItemArray.splice(splitItemArray.length-1, 1);

		var suburb = splitItemArray.join(' ');

		return {
			postcode: postcode,
			suburb: suburb,
			state: state
		}
	}

};

var HouseholdDetailsHandler = {
	init: function(){

		<c:if test="${not empty postcode && postcode ne null}">
			$('#${name}_location').focus().val('${postcode}').autocomplete('search','${postcode}');
		</c:if>
	}
};

</go:script>

<go:script marker="onready">
	HouseholdDetailsHandler.init();
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_mobileNumberinput" rule="validateMobileField" parm="true" message="You need to provide a mobile number or a landline number." />
<go:validate selector="${name}_location" rule="validateLocation" parm="true" message="Please make sure that the format of the postcode/suburb field is &quotpostcode - suburb, state&quot" />