<%@ tag description="Fuel Prices Form"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<go:setData dataVar="data" value="*PARAMS" />

<c:set var="name"		value="${go:nameFromXpath(xpath)}" />

<%-- Parameters --%>
<c:set var="fuel"			value="${param.fueltype}" />
<c:set var="suburb"			value="${param.suburb}" />
<c:set var="postcode"		value="${param.fuel_location}" />


<%-- HTML: The standard form for selecting the fuel to search --%>
<form:fieldset legend="Select up to 2 fuel types" id="fuelTypes" className="no-background-color">
	<fuel:fuel_selection />	
</form:fieldset>
<form:fieldset legend="Enter your postcode/suburb" id="fuelTypes">

	<c:set var="autocompleteSource">
		function( request, response ) {
			
			// format is something like "Toowong Bc 4066 QLD"
			format = /^.*\s\d{4}\s(ACT|NSW|QLD|TAS|SA|NT|WA)$/;
			
			// don't search if the value matches the format we aim for
			if( !format.test( $('#${name}_location').val() ) ){
			
				$.ajax({
					url: "ajax/json/get_suburbs.jsp",
					data: {
							term: request.term
						},
					success: function( data ) {
						response( $.map( data, function( item ) {
							if( item.length != undefined ){
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

<div class="clear"></div>
<a href="javascript:;" class="cancelbtn"><span>Cancel</span></a>
<a href="javascript:;" class="updatebtn"><span>Update</span></a>
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
}

.fuel ul.ui-autocomplete.ui-menu  {
	max-height:200px;
	overflow:hidden;
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