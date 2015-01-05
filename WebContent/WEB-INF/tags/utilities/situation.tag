<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Applicant's situation group"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" />
<fmt:setLocale value="en_GB" scope="session" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<div id="${name}" class="${name}">
	
	<form:fieldset legend="Identification Details">
		
			<form:row label="Identification type" id="idTypeContainer">
				<field:array_select items="=Please choose...,Medicare=Medicare,Passport=Passport,DriversLicence=Driver's License" xpath="${xpath}/identification/idType" title="the identification type" required="true" />
			</form:row>
			
			<form:row label="Identification number">
				<field:input xpath="${xpath}/identification/idNo" title="identification number" required="true" maxlength="20" />
			</form:row>
			
			<div class="countryRowContainer">
				<form:row label="Country of issue">
					<field:import_select xpath="${xpath}/identification/country" 
						url="/WEB-INF/option_data/country_of_issue_name.html"
						title="country of issue"
						required="true" />
				</form:row>
			</div>
			
			<div class="stateRowContainer">
				<form:row label="State of issue">
					<field:state_select xpath="${xpath}/identification/state" useFullNames="true" />
				</form:row>
			</div>
			
			<fmt:formatDate value="${go:AddDays(now,365*10)}" var="expiryMaxDate" type="date" pattern="dd/MM/yyyy"/>
			<form:row label="Expiry date" id="idExpiryDate">
				<field:basic_date xpath="${xpath}/identification/expiryDate" title="identification expiry date" required="true" disableWeekends="false" maxDate="${expiryMaxDate}" />
			</form:row>

	</form:fieldset>		

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} #identificationSection,
	#${name} .countryRowContainer,
	#${name} .stateRowContainer{
		display:none;
	}
	
	#idTypeContainer .fieldrow_value{
		width: 400px;
	}
	
	.fieldrow_value input.cardValidity{
		margin-right: 5px;
	}
	
	#helpToolTip span div {
		height: 5px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var utilitiesSituation = {
	
		init: function(){
			
			$('#${name}_identification_idType').on('change', function(){
				utilitiesSituation.identificationFields();
			});
			utilitiesSituation.identificationFields();
		},
		
		identificationFields: function(){
		
			switch($('#${name}_identification_idType').val()){
				
				case 'Passport':
					$('#${name} .countryRowContainer').slideDown();
					$('#${name} .stateRowContainer').slideUp();
					break;
					
				case 'DriversLicence':
					$('#${name} .countryRowContainer').slideUp();
					$('#${name} .stateRowContainer').slideDown();
					break;
					
				default:
					$('#${name} .countryRowContainer').slideUp();
					$('#${name} .stateRowContainer').slideUp();
					break;
			}
			
		}
	};
</go:script>

<go:script marker="onready">	

	utilitiesSituation.init();
	
</go:script>
