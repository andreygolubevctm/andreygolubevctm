<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Household Details group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name"		value="${go:nameFromXpath(xpath)}" />

<%-- PARAMETERS --%>
<c:set var="postcode" 	value="${param.postcode}" />

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Household Details">
		
		<form:row label="Postcode">
			<field:post_code xpath="${xpath}/postcode" title="postcode" required="true" />
		</form:row>
		
			<c:set var="autocompleteSource">
				function( request, response ) {
					$.ajax({
						url: "ajax/json/get_suburbs.jsp",
						data: {
								term: request.term,
								fields: "suburb, postCode, state"
							},
						success: function( data ) {
							response( $.map( data, function( item ) {
								if( item.length != undefined ){
									splitItem = AutoCompleteHandler.splitItem( item );
									
									return {
										label: splitItem.postcode + " - " + splitItem.suburb + ", " + splitItem.state,
										value: item
									}
								} else {
									return data;
								}
							}));
						}
					});
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
						
						return false;
					}
				}
			</c:set>
			
			<c:set var="autocompleteOpen">
				function( event, ui ) {
					var format = /.*\s-\s.*,.*/;
					
					// don't open if the value matches the format we aim for
					if( format.test( $(event.target).val() ) ){
						$(event.target).autocomplete("close");
					}
				}
			</c:set>
			
			<field:autocomplete xpath="${xpath}/location" title="Postcode/Suburb" required="true" source="${autocompleteSource}" select="${autocompleteSelect}" open="${autocompleteOpen}" min="2" />
			<field:hidden xpath="${xpath}/postcode" required="false" />
			<field:hidden xpath="${xpath}/suburb" required="false" />
			<field:hidden xpath="${xpath}/state" required="false" />
		</form:row>
		
		<form:row label="Are you moving to this property?" helpId="413">
			<field:array_radio items="Y=Yes,N=No" id="${name}_movingIn" xpath="${xpath}/movingIn" title="if you are moving to this property" required="true" />	
		</form:row>
		
		<form:row label="What would you like to compare?">
			<field:array_radio items="E=Electricity,G=Gas,EG=Electricity and Gas" id="${name}_whatToCompare" xpath="${xpath}/whatToCompare" title="which energies to compare" required="true" />	
		</form:row>
		
		<form:row label="Would you like us to estimate how much energy you use?">
			<field:array_select items="=Please choose...,S=Yes - Use my $ spend to work out my usage,H=Yes - Use my household size to work out my usage,U=No&nbsp;&nbsp;&nbsp;- I will enter my usage in kWh/MJ from a recent bill(s)" xpath="${xpath}/howToEstimate" title="how to estimate how much energy you use" required="true" />	
		</form:row>
		
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
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
var HouseholdDetailsHandler = {
	
};

var HouseholdDetailsHandler = {
	init: function(){
		$("#${name}_movingIn, #${name}_whatToCompare").buttonset();
	
		<c:if test="${not empty postcode && postcode ne null}">
			$('#${name}_location').focus().val('${postcode}').autocomplete('search','${postcode}');
		</c:if>
		
		
	}
};

$.validator.addMethod("validatePostcode",
	function(value, element) {
		var passed = true;
		
		if( String(value).length > 3 && value != PostCodeStateHandler.current_state )
		{
			$.ajax({
				url: "ajax/json/get_state.jsp",
				data: {postCode:value},
				type: "POST",
				async: true,
				cache: false,
				success: function(jsonResult){
					var count = Number(jsonResult[0].count);
					var state = jsonResult[0].state;
					PostCodeStateHandler.current_state = state;
					switch( count )
					{
						case 2:
							$("#${name}_state_refine").parents(".fieldrow").show();
							$("#${name}_state_refine").buttonset();
							
							var states = state.split(", ");
							
							$("#${name}_state_refine_A").val(states[0]);
							$('#${name}_state_refine label:first span').empty().append(states[0]);
							
							$("#${name}_state_refine_B").val(states[1]);
							$('#${name}_state_refine label:last span').empty().append(states[1]);
							
							$("input[name=${name}_state_refine]").on('change', function(){
								$("#${name}_state").val($(this).val()).trigger('change');
							});
							passed = true;
							break;
						case 1:
							$("#${name}_state").val( state );
							$("#${name}_state_refine").parents(".fieldrow").hide();
							passed = true;
							break;
						default:
							$("#${name}_state").val("");
							$("#${name}_state_refine").parents(".fieldrow").hide();
							passed = false;
							break;
					}
					$("#${name}_state").trigger('change');
				},
				dataType: "json",
				error: function(obj,txt){
					passed = false;
				},
				timeout:60000
			});
		} else {
			$("#${name}_state_refine").parents(".fieldrow").hide();
			$("#${name}_state").val("").trigger('change');
		}	
		
		return passed;
	},
	"Replace this message with something else"
);
</go:script>

<go:script marker="onready">	
	HouseholdDetailsHandler.init();
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_postcode" rule="validatePostcode" parm="true" message="Must enter a valid 4 digit postcode." />
<go:validate selector="${name}_state" rule="required" parm="true" message="No state has been found." />
