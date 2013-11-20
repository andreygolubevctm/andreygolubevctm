<%@ tag description="Fuel Prices Form"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="data" value="*PARAMS" />

<c:set var="name"		value="${go:nameFromXpath(xpath)}" />

<%-- Parameters --%>
<c:set var="fuel"			value="${param.fueltype}" />
<c:set var="suburb"			value="${param.suburb}" />
<c:choose>
	<c:when test="${not empty param.fuel_location}">
<c:set var="postcode"		value="${param.fuel_location}" />
	</c:when>
	<c:otherwise>
		<c:set var="postcode" value="${param.location}" />
	</c:otherwise>
</c:choose>

<c:set var="fuel_brochure_site_test">
	<c:choose>
		<c:when test="${not empty fuel and (not empty suburb or not empty postcode)}">true</c:when>
		<c:otherwise>false</c:otherwise>
	</c:choose>
</c:set>

<%-- SCRIPT --%>
<go:script marker="js-head">

var FUEL_BROCHURE_SITE_REQUEST = ${fuel_brochure_site_test};

<%-- To proceed a user must select either a valid postcode or enter a suburb and
	select a valid suburb/postcode/state value from the autocomplete. This is to
	avoid suburbs that match multiple locations being sent with request only to be
	returned empty because can only search a single location (FUE-23). --%>
$.validator.addMethod("validateFuelPostcodeSuburb",
	function(value, element) {

		var postcode_match = new RegExp(/^(\s)*\d{4}(\s)*$/);
		var search_match = new RegExp(/^((\s)*\w+\s+)+\d{4}((\s)+(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)(\s)*)$/);

		value = $.trim(String(value));

		if( FUEL_BROCHURE_SITE_REQUEST ) {
			FUEL_BROCHURE_SITE_REQUEST = false;
			$('#fuel_location').trigger("focus");
			return true;
		}

		if( value != '' ) {
			if( value.match(postcode_match) || value.match(search_match) ) {
				return true;
			}
		}

		return false;
	},
	"Replace this message with something else"
);
</go:script>


<%-- HTML: The standard form for selecting the fuel to search --%>
<form:fieldset legend="Select up to 2 fuel types" id="fuelTypes" className="no-background-color">
	<fuel:fuel_selection />	
</form:fieldset>
<form:fieldset legend="Enter your postcode/suburb" id="fuelLocation" className="fuel_postcode_suburb no-background-color">

	<c:set var="autocompleteSource">
		function( request, response ) {
			
			// format is something like "Toowong Bc 4066 QLD"
			format = /^.*\s\d{4}\s(ACT|NSW|QLD|TAS|SA|NT|VIC|WA)$/;
			
			// don't search if the value matches the format we aim for
			if( !format.test( $('#${name}_location').val() ) ){
			
				$.ajax({
					url: "ajax/json/get_suburbs.jsp",
					data: {
							term: request.term,
							fields: 'postcode, suburb, state'
						},
					success: function( data ) {
						response( $.map( data, function( item ) {
							if( item.length != undefined ){

								<%-- FUE-23: If only one item is returned then simply update the location field with the suburb --%>
								if( data.length == 1 ) {
									$('#${name}_location').val(item);
								}

								return {
									label: item,
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
	
	<form:row label="Postcode / Suburb">
		<field:autocomplete xpath="${xpath}/location" title="Postcode/Suburb to compare fuel" required="true" source="${autocompleteSource}" min="2" />
	</form:row>
</form:fieldset>

<go:validate selector="${name}_location" rule="validateFuelPostcodeSuburb" parm="true" message="Please select a valid postcode to compare fuel" />

<div class="clear"></div>
<ui:button classNames="fuelForm-buttons fuelForm-cancelbtn" theme="green">Cancel</ui:button>
<ui:button classNames="fuelForm-buttons fuelForm-updatebtn" theme="green">Update</ui:button>
<div class="clear"></div>

<%-- CSS --%>
<go:style marker="css-head">

.threecol {
	float:left;
	width:35%;
	margin-right:1%;
	overflow:auto;
}

.threecol.col1 {
	width:35%;
}

.threecol.col2 {
	width:33%;
}

.threecol.col3 {
	width:28%;
}

	.resultsform .col1 {
		width:42%;
	}
	.resultsform .col2 {
		width:32%;
	}
	.resultsform .col3 {
		width:23%;
	}		

#fuelTypes .content {
	overflow:auto;
}

#fuelTypes .content strong {
	margin:8px 0 8px 0;
	cursor:pointer;
	font-size:14px;
	font-weight:normal;
}

#fuelTypes .content strong:hover {
	color:#193C97;
	text-decoration:underline;
}

#fuelTypes label {
	float:left;
	line-height:175%;
	min-width:55%;
}

#fuelTypes input {
	float:left;
	clear:left;
	margin-right:8px;
	margin-left: 7px;
}

.fuel ul.ui-autocomplete.ui-menu  {
	max-height:200px;
	overflow:hidden;
}
.fuel .resultsform .fuel_postcode_suburb {
	width: 330px;
}
.fuel .resultsform .fuel_postcode_suburb .content{
	width: 330px;
}
.fuel .resultsform .qe-window .fieldrow_label {
	width: 115px !important;
}
body .fuelForm-buttons{
	float: right;
	width: 120px;
	padding: 8px 0;
	margin-right: 5px;
}

</go:style>


<%-- JAVASCRIPT --%>
<go:script marker="onready">

<%-- Checking for pre-defined parameters AND filling the form + submitting if possible --%>
//check for location and if none substitute with best param available
$('#fuel_location').each( function(){
	if($(this).val() == ''){
		if( '${postcode}' !=  '' ){
			$(this).val('${postcode}');
		} else if( '${suburb}' !=  '' ) {
			$(this).val('${suburb}');
		}		
	}	
});

//check if fuel paramater is set, and use a function to select the types
if( $('#fuelTypes').find(':checked').length == 0 ){
	//select the context and use the function
	switch('${fuel}')
	{
	case 'P':
	  fuel.define( $('#fuelTypes').find('.col1 label:first'), true  );
	  break;
	case 'D':
	  fuel.define( $('#fuelTypes').find('.col2 label:first'), true  );
	  break;
	case 'L':
	  fuel.define( $('#fuelTypes').find('.col3 label:first'), true  );
	  break;	  
	default:
	  //do nothing //fuel.toggleSelect(true); //select all
	}
}


<%--
	NOTE: 'form submit' trigger placed into includes.tag
--%>


$('#fuelTypes').find(':checkbox').change( function() {
	fuel.limit(this);
});


</go:script>