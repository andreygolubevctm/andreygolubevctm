<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Household Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name"		value="${go:nameFromXpath(xpath)}" />

<%-- PARAMETERS --%>
<c:set var="postcode"><c:out value="${param.postcode}" escapeXml="true" /></c:set>

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Household Details">
		
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
		
		<form:row label="Are you moving to this property?" helpId="413">
			<field:array_radio items="Y=Yes,N=No" id="${name}_movingIn" xpath="${xpath}/movingIn" title="if you are moving to this property" required="true" />	
		</form:row>
		
		<div id="movingInContainer">
		<form:row label="What date are you moving in?">
			<field:basic_date xpath="${xpath}/movingInDate" title="moving in date" required="true" disableWeekends="true" maxDate="+60d" />
		</form:row>
		</div>
		<form:row label="What would you like to compare?" helpId="528">
			<field:array_radio items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_whatToCompare" xpath="${xpath}/whatToCompare" title="which energies to compare" required="true" />	
		</form:row>
		
		<form:row label="Would you like us to estimate how much energy you use?" helpId="526">
			<field:array_select items="=Please choose...,S=Yes - Use my $ spend to work out my usage,U=No&nbsp;&nbsp;&nbsp;- I will enter my usage in kWh/MJ from a recent bill(s)" xpath="${xpath}/howToEstimate" title="how to estimate how much energy you use" required="true" />&nbsp;
		</form:row>
		
		<form:row label="Do you have solar panels installed on your property?">
			<field:array_radio items="Y=Yes,N=No" id="${name}_solarPanels" xpath="${xpath}/solarPanels" title="if you have solar panels" required="true" />
		</form:row>

		<field:hidden xpath="${xpath}/tariff" required="false" />

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
		$("#${name}_movingIn, #${name}_whatToCompare, #${name}_solarPanels").buttonset();
	
		if($("input[name=utilities_householdDetails_movingIn]:checked").val() == 'Y'){
			$('#movingInContainer').show();
		} else {
			$('#movingInContainer').hide();
		}

		<c:if test="${not empty postcode && postcode ne null}">
			$('#${name}_location').focus().val('${postcode}').autocomplete('search','${postcode}');
		</c:if>
	}
};

$.validator.addMethod("validateLocation",
	function(value, element) {
		
		var format = /.*\s-\s.*,.*/;
		
		if( format.test(value) ){
		
			postcode = $('#${name} #${name}_postcode');
			suburb = $('#${name} #${name}_suburb');
			state = $('#${name} #${name}_state');
			
			if( postcode.val() == ""
				|| state.val() == "") {
				return false;
			}
			
			return true;
			
		} else {
		
			return false;
			
		}
		
	},
	"Replace this message with something else"
);
</go:script>

<go:script marker="onready">	
	HouseholdDetailsHandler.init();

	$('input[name=utilities_householdDetails_movingIn]').on('change',function(){
		if($("input[name=utilities_householdDetails_movingIn]:checked").val() == 'Y'){
			$('#movingInContainer').show();
		} else {
			$('#movingInContainer').hide();
		}
	});
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_location" rule="validateLocation" parm="true" message="Please make sure that the format of the postcode/suburb field is &quotpostcode - suburb, state&quot" />