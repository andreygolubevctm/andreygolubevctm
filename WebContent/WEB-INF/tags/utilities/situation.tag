<%@ tag language="java" pageEncoding="ISO-8859-1" %>
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
	
	<form:fieldset legend="Your situation">
		
		<form:section title="Identification Details" separator="true" id="identificationSection">
		
			<form:row label="Identification type" id="idTypeContainer">
				<field:array_select items="=Please choose...,Medicare=Medicare,Passport=Passport,DriversLicence=Driver's License" xpath="${xpath}/identification/idType" title="the identification type" required="true" />
			</form:row>
			
			<form:row label="Identification number">
				<field:input xpath="${xpath}/identification/idNo" title="identification number" required="true" maxlength="20" />
			</form:row>
			
			<div class="countryRowContainer">
				<form:row label="Country of issue">
					<field:import_select xpath="${xpath}/identification/country" 
						url="/WEB-INF/option_data/country_of_issue.html"
						title="country of issue"
						required="true" />
				</form:row>
			</div>
			
			<div class="stateRowContainer">
				<form:row label="State of issue">
					<field:state_select xpath="${xpath}/identification/state" useFullNames="true" />
				</form:row>
			</div>
			
		</form:section>
		
		<form:section title="Concession Details">
		
			<form:row label="Are you entitled to an energy concession?" className="hasConcessionRow" helpId="416">
				<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/concession/hasConcession" title="if you have the right to a concession" required="true" className="${name}_concession_hasConcession" />
			</form:row>
			
			<div id="concessionContainer">
				<form:row label="Concession type">
					<field:array_select items="=Please choose...,PCC=Pensioner Concession Card,HCC=Centrelink Health Care Card,DVAGC=DVA Gold Card,DVPC=DVA Pension Concession Card,QGSC=Queensland Government Seniors Card,DVAGC_WW=DVA Gold Card (War Widows Pension only),DVAGC_TPI=DVA Gold Card (Special Rate TPI Pension only),DVPC=Qld Dept of Communities Seniors Concession Card,DVPC=DVA Gold Card (Extreme Disablement Adjustment)" xpath="${xpath}/concession/type" title="your concession type" required="true" />
				</form:row>
				
				<form:row label="Card Number">
					<field:input xpath="${xpath}/concession/cardNo" title="concession card number" required="true" maxlength="20" />
				</form:row>
				
				<fmt:formatDate value="${go:AddDays(now,-365*5)}" var="minDate" type="date" pattern="dd/MM/yyyy"/>
				<fmt:formatDate value="${go:AddDays(now,365*5)}" var="maxDate" type="date" pattern="dd/MM/yyyy"/>
	
				<field:date_range xpath="${xpath}/concession/cardDateRange" minDate="${minDate}"  maxDate="${maxDate}" required="true" labelTo="Card expiry date" labelFrom="Card start date" titleFrom="start" titleTo="expiry" showIcon="true" iconImageOnly="true" inputClassName="cardValidity" />
				
				<core:js_template id="concession-checkbox-template">
					<form:row label=" ">
						<field:checkbox
							xpath="${xpath}/concession/concessionAgreement"
							value="Y"
							title="I authorise [#= provider_name #] and Centrelink or Department of Veterans Affairs to exchange my personal information during the term of this energy plan to verify eligibility for my concession."
							label="true"
							errorMsg="Please agree to exchange your personal information in order to verify your eligibility for a concession"
							required="true" />
						<%-- @todo = parse provider name into checkbox above --%>
					</form:row>
				</core:js_template>
				
				<div id="${name}_concession_placeholder"></div>
			</div>
			
			<div id="medicalRequirementsContainer">
				<form:row label="Do you have any special medical requirements?" className="medicalRequirementsRow" helpId="417">
					<field:array_select items="=Please choose...,N=No,LS=Yes - Someone at my home uses life support,MS=Yes - someone at my home has multiple sclerosis (MS)" xpath="${xpath}/medicalRequirements" title="any medical requirements" required="true" />
				</form:row>
			</div>
		
		</form:section>
		
	</form:fieldset>		

</div>

<%-- CSS --%>
<go:style marker="css-head">
	#${name} #identificationSection,
	#${name} .countryRowContainer,
	#${name} .stateRowContainer,
	#${name} #concessionContainer{
		display:none;
	}
	
	#idTypeContainer .fieldrow_value{
		width: 400px;
	}
	
	.hasConcessionRow .fieldrow_value,
	.medicalRequirementsRow .fieldrow_value{
		padding-top: 9px;
	}
	
	.fieldrow_value input.cardValidity{
		margin-right: 5px;
	}
	
	.fieldrow_value{
		max-width: 400px;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var utilitiesSituation = {
	
		init: function(){
			
			$('.${name}_concession_hasConcession').buttonset();
			
			$('#${name}_identification_idType').on('change', function(){
				utilitiesSituation.identificationFields();
			});
			utilitiesSituation.identificationFields();
			
			$('.${name}_concession_hasConcession').on('change', function(){
				if( $('.${name}_concession_hasConcession :checked').val() == 'Y'){
					$('#${name} #concessionContainer').slideDown();
				}else{
					$('#${name} #concessionContainer').slideUp();
				}
			});
			$('.${name}_concession_hasConcession').trigger('change');
			
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
	
	$.validator.addMethod("maxExpiry",
		function(value, elem, parm) {
			
			fromDateElement = $('#${name}_concession_cardDateRange_fromDate');
			toDateElement = $('#${name}_concession_cardDateRange_toDate');
			
			if(fromDateElement.val() != '' && toDateElement.val() != ''){
				
				toDate = toDateElement.val().split('/');
				toDateObj = new Date(toDate[2], toDate[1], toDate[0]);
				toDateObj.setDate(Number(toDateObj.getDate() - (365 * 5) ));
				
				fromDate = fromDateElement.val().split('/');
				fromDateObj = new Date(fromDate[2], fromDate[1], fromDate[0]);
				
				if(toDateObj > fromDateObj) {
					return false;
				} else {
					return true;
				}
				
			}else{
				return false;
			}
		}, ""
	);
	
</go:script>

<go:script marker="onready">	

	utilitiesSituation.init();
	
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_concession_cardDateRange_toDate" rule="maxExpiry" parm="true" message="Your concession card cannot be valid for more than 5 years, please review your dates" />
