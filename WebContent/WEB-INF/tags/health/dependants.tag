<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Grouping together of dependantren"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="date" class="java.util.Date" />

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />
<c:set var="month"><fmt:formatDate value="${date}" pattern="M" /></c:set>
<c:set var="year"><fmt:formatDate value="${date}" pattern="yyyy" /></c:set>

<%-- Financial year --%>
<c:choose>
	<c:when test="${month < 7}">
		<c:set var="financialYearStart">${year - 1}</c:set>
		<c:set var="financialYearEnd">${year}</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="financialYearStart">${year}</c:set>
		<c:set var="financialYearEnd">${year + 1}</c:set>
	</c:otherwise>
</c:choose>

<%-- HTML --%>
<div id="${name}-selection" class="health-dependants">

	<form_new:fieldset legend="Your Dependants' Details" >
	
		<%-- //FIX: need to insert fund's real definition here --%>
		<p class="definition">
			This policy provides cover for your children aged less than 22 years plus students studying full time between the ages of 22 and 24. You can still obtain cover for your adult child outside these criteria by applying for a separate singles policy
		</p>
		
		<div id="${name}_threshold" class="text-danger">
			
			<p>
				You have not added any dependants but have selected a cover type that requires them.
			</p>
			<p>
				If you do not wish to add any dependants, you can search for suitable policies by <a href="javascript:;" data-slide-control="start">changing your cover type</a>.
			</p>
			<p>
				<strong>If you wish to continue, please add your dependants now.</strong>
			</p>

			<field:hidden required="true" validationRule="validateMinDependants" validationMessage="A dependant is required." defaultValue="" xpath="${xpath}/dependantrequired" />
		</div>
	
		<health:dependant_details xpath="${xpath}/dependant" count="1" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="2" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="3" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="4" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="5" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="6" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="7" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="8" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="9" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="10" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="11" />
		
		<health:dependant_details xpath="${xpath}/dependant" count="12" />
		
		<form_new:row id="dependents_list_options">
			<a href="javascript:void(0);" class="add-new-dependent btn btn-success" title="Add new dependent">Add New Dependant</a>
			
		</form_new:row>
		
		<%-- If the user changes the amount of dependants here, we will need to re-confirm their selection --%>
		<div class="health-dependants-tier" style="display:none">
			
			<form_new:row>
				<h5>When completed, confirm your new income tier</h5>
			</form_new:row>
			
			<c:set var="fieldXpath" value="${xpath}/income" />
			<form_new:row fieldXpath="${fieldXpath}" label="What is the estimated taxable income for your household for the financial year 1st July ${financialYearStart} to 30 June ${financialYearEnd}?" id="${name}_tier">
				<field_new:array_select xpath="${fieldXpath}"  title="Please enter your household income" required="true" items="=Please choose...||0=Tier 0||1=Tier 1||2=Tier 2||3=Tier 3" delims="||" className="income health_dependants_details_income"/>
				<span class="fieldrow_legend" id="${name}_incomeMessage"></span>
			</form_new:row>
		</div>

	</form_new:fieldset>

</div>


	


<%-- JAVASCRIPT --%>
<go:script marker="js-head">

	
	
<%-- Validation for defacto messages --%>
$.validator.addMethod("defactoConfirmation",
	function(value, element) {
	
		if( $(element).parent().find(':checked').val() == 'Y' ){
			return true; <%-- Passes --%>
		} else {
			return false; <%-- Fails --%>
		};
		
	}
);


<%-- Validation for defacto messages --%>
$.validator.addMethod("validateMinDependants",
	function(value, element) {
		return !$("#${name}_threshold").is(":visible");
	}
);


<%-- DOB validation message --%>
$.validator.addMethod("limitDependentAgeToUnder25",
	function(value, element) {	
		var getAge = returnAge(value);
		if( getAge >= healthDependents.maxAge ) {
			<%-- Change the element message on the fly --%>
			$(element).rules("add", { messages: { 'limitDependentAgeToUnder25':'Your child cannot be added to the policy as they are aged ' + healthDependents.maxAge + ' years or older. You can still arrange cover for this dependant by applying for a separate singles policy or please contact us if you require assistance.' } } );
			return false;
		};
		return true;
	}
);
</go:script>