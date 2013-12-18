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

		</form:section>
		
		<form:section title="Concession Details" separator="true">
		
			<form:row label="Are you entitled to an energy concession?" className="hasConcessionRow" helpId="416">
				<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/concession/hasConcession" title="if you have the right to a concession" required="true" className="${name}_concession_hasConcession" />
			</form:row>
			
			<div id="concessionContainer">
				<form:row label="Concession type">
					<field:array_select items="=Please choose..." xpath="${xpath}/concession/type" title="your concession type" required="true" />
					<utilities:concession_selector id="${name}_concession_type" />
				</form:row>
				
				<form:row label="Card Number">
					<field:input xpath="${xpath}/concession/cardNo" title="concession card number" required="true" maxlength="20" />
				</form:row>
				
				<fmt:formatDate value="${go:AddDays(now,-365*5)}" var="minDate" type="date" pattern="dd/MM/yyyy"/>
				<fmt:formatDate value="${go:AddDays(now,365*5)}" var="maxDate" type="date" pattern="dd/MM/yyyy"/>
	
				<field:date_range xpath="${xpath}/concession/cardDateRange" minDate="${minDate}"
				maxDate="${maxDate}" required="true" labelTo="Card expiry date" labelFrom="Card start date"
				titleFrom="start" titleTo="expiry" showIcon="true" iconImageOnly="true" inputClassName="cardValidity" />
				
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
			<div id="concessionContainerSA">
				<form:row label=" ">
					<p>If you live in SA and are entitled to a concession you will need to contact the Department of Families and Communities (DFC) on 1800 307 758 and complete an application. Your concession will apply once your application is processed by DFC.</p>
				</form:row>
			</div>
		
		</form:section>
		
		<form:section title="Medical Requirements" id="medicalRequirementsSection">
			<form:row label="Do you have any medical requirements?" helpId="417">
				<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/medicalRequirements" title="if you have any medical requirements" required="true" className="${name}_medicalRequirements" />
			</form:row>
			
			<div id="medicalRequirementsContainer">
				<form:row label="Someone at my home uses life support">
					<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/lifeSupport" title="if you need life support" required="true" className="${name}_lifeSupport ${name}_medicalRequirementsOptions" />
				</form:row>
				
				<form:row label="Someone at my home has multiple sclerosis (MS)">
					<field:array_radio items="Y=Yes,N=No" xpath="${xpath}/multipleSclerosis" title="if you have multiple sclerosis" required="true" className="${name}_multipleSclerosis ${name}_medicalRequirementsOptions" />
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
	#${name} #concessionContainer,
	#${name} #concessionContainerSA,
	#${name} #medicalRequirementsContainer{
		display:none;
	}
	
	#idTypeContainer .fieldrow_value{
		width: 400px;
	}
	
	.hasConcessionRow .fieldrow_value{
		padding-top: 9px;
	}
	
	.fieldrow_value input.cardValidity{
		margin-right: 5px;
	}
	
	#${name} #concessionContainer .fieldrow_value,
	#${name} #concessionContainerSA .fieldrow_value{
		max-width: 400px;
	}
	
	div.${name}_medicalRequirementsOptions label.invalid{
		border: 1px solid #EB5300;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="js-head">
	var utilitiesSituation = {
	
		init: function(){
			
			$('.${name}_concession_hasConcession, .${name}_medicalRequirements, .${name}_lifeSupport, .${name}_multipleSclerosis').buttonset();
			
			$('#${name}_identification_idType').on('change', function(){
				utilitiesSituation.identificationFields();
			});
			utilitiesSituation.identificationFields();
			
			$('.${name}_concession_hasConcession').on('change', function(){
				var target = "concessionContainer";
				if(utilitiesChoices._state == "SA"){
					target += "SA";
				}
				if( $('.${name}_concession_hasConcession :checked').val() == 'Y'){
					$('#${name} #'+target).slideDown();
				}else{
					$('#${name} #'+target).slideUp();
				}
			});
			$('.${name}_concession_hasConcession').trigger('change');
			
			$('.${name}_medicalRequirements').on('change', function(){
				
				if( $('.${name}_medicalRequirements :checked').val() == 'Y'){
					$('#${name} #medicalRequirementsContainer').slideDown();
				}else{
					$('#${name} #medicalRequirementsContainer').slideUp();
				}
			});
			$('.${name}_medicalRequirements').trigger('change');
			
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
	
	$.validator.addMethod("medicalSelected",
		function(value, elem, parm) {
		
			// if user declared having medical requirements, more validation
			if( $('.${name}_medicalRequirements :checked').val() == 'Y'){
			
				// if 0 medical requirements are selected
				if($("input.${name}_medicalRequirementsOptions:checked").filter(function(){return $(this).val() == "Y"}).length == 0){
					
					$("div.${name}_medicalRequirementsOptions label").addClass("invalid");
					
					$('.${name}_medicalRequirementsOptions').on('change', function(){
						$("#mainform").validate().element("#${name}_medicalRequirements_Y");
					});
					
					return false;
				}
			}
			$("div.${name}_medicalRequirementsOptions label").removeClass("invalid");
			return true;
			
		}, ""
	);

</go:script>

<go:script marker="onready">	

	utilitiesSituation.init();
	
</go:script>

<%-- VALIDATION --%>
<go:validate selector="${name}_concession_cardDateRange_toDate" rule="maxExpiry" parm="true" message="Your concession card cannot be valid for more than 5 years, please review your dates" />
<go:validate selector="${name}_medicalRequirements" rule="medicalSelected" parm="true" message="Please choose the appropriate medical requirement(s)" />
