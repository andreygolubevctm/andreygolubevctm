<%@ tag description="Fuel Selection to get unique fuel types"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<security:populateDataFromParams rootPath="fuel" />

<%-- Setting the fuel titles --%>
<c:set var="fuel2" value="Unleaded" />
<c:set var="fuel3" value="Diesel" />
<c:set var="fuel4" value="LPG" />
<c:set var="fuel5" value="Premium Unleaded 95" />
<c:set var="fuel6" value="E10" />
<c:set var="fuel7" value="Premium Unleaded 98" />
<c:set var="fuel8" value="Bio-Diesel 20" />
<c:set var="fuel9" value="Premium Diesel" />


<%-- HTML --%>
<div class="threecol threecolr col1">		
	<ui:button classNames="fuel-trigger" theme="blue">Unleaded</ui:button>
	<field:checkbox xpath="${xpath}/type/petrol/E10" label="true" value="6" className="${fuel6}" title="${fuel6}" required="false" />		
	<field:checkbox xpath="${xpath}/type/petrol/ULP" label="true" value="2" className="${fuel2}" title="${fuel2}" required="false" />
	<field:checkbox xpath="${xpath}/type/petrol/PULP" label="true" value="5" className="${fuel5}" title="${fuel5}" required="false" />
	<field:checkbox xpath="${xpath}/type/petrol/PULP98" label="true" value="7" className="${fuel7}" title="${fuel7}" required="false" />			
</div>

<div class="threecol threecolr col2">		
	<ui:button classNames="fuel-trigger" theme="blue">Diesel</ui:button>
	<field:checkbox xpath="${xpath}/type/diesel/D" label="true" value="3" className="${fuel3}" title="${fuel3}" required="false" />	
	<field:checkbox xpath="${xpath}/type/diesel/D20" label="true" value="8" className="${fuel8}" title="${fuel8}" required="false" />
	<field:checkbox xpath="${xpath}/type/diesel/PD" label="true" value="9" className="${fuel9}" title="${fuel9}" required="false" />			
</div>

<div class="threecol threecolr col3">		
	<ui:button classNames="fuel-trigger" theme="blue">LPG</ui:button>
	<field:checkbox xpath="${xpath}/type/lpg/LPG" label="true" value="4" className="${fuel4}" title="${fuel4}" required="false" />			
</div>

<field:hidden xpath="${xpath}/hidden" required="false" className="validate" validationMessage="Fuel type is required."></field:hidden>

<%-- JQUERY UI --%>
<go:script marker="onready">

	
	// Toggle the checkbox selections	
	$('#fuelTypes').find('.fuel-trigger').click(function(e){
		fuel.define(this);
		e.preventDefault();
	});
	
	// If checkbox changes re-validate form
	 $('#fuelTypes').find('input').change(function(){
	 	fuel.populate($(this));
		if($('#fuelTypes').hasClass("errorGroup")){
			QuoteEngine.validate();
		}
	});
	
	// Custom Validation
	$.validator.addMethod("fuelSelected",
		function(value, element) {	
			
			if(  $('#fuelTypes').find('input:checked').length > 0 &&  (fuel.isBrochureSite || $('#fuelTypes').find('input:checked').length < 3)){
				$('#fuelTypes input').removeClass("error");
				$('#fuelTypes').removeClass("errorGroup");
				return true;
			}
			
			$('#fuelTypes input').addClass("error");
			$('#fuelTypes').addClass("errorGroup");
			return false;		
		},
		"Please select up to 2 fuels types"
	);
	
</go:script>


<go:style marker="css-head">
	.fourcol{float:left; width:115px; height:153px; position:relative;}
	.fourcol strong{margin:8px 0 4px 0;}
	.fourcolr{margin-right:5px;}
	.twocol{float:left; width:260px;}
	.twocoln{float:left; width:220px;}
	.qe-window .content{min-height:auto;}
	#help_213{top:13px; left:503px; position:absolute;}
	a.fuel-trigger{
		width: 120px;
		padding: 7px 0;
		font-size: 100%;
		font-weight: bold;
		margin-left: 7px;
		display: block;
		margin-bottom: 10px;
	}
</go:style>


<%-- VALIDATION --%>
<go:validate selector="${go:nameFromXpath(xpath)}_hidden" rule="fuelSelected" parm="true" message="Please select up to 2 fuels types" />