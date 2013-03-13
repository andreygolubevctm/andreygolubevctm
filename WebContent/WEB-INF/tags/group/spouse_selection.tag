<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group for spouse selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="className" value="${go:nameFromXpath(xpath)}" />
<c:set var="spouseXpath" value="${xpath}" />
<c:set var="spouseExistsXpath" value="${xpath}/exists" />
<c:set var="spouseName" value="${go:nameFromXpath(spouseExistsXpath)}" />

<%-- HTML --%>
<form:row label="Do you have a spouse at the same address">
	<field:array_radio xpath="quote/drivers/spouse/exists"
					   required="true"
					   className="double_high spouseExists"
					   id="spouseExists"
					   items="Y=Yes,N=No"
					   title="if you have a spouse at the same address"/>
</form:row>
<div id="spouseRow">

<form:row label="Spouse Gender" id="spouseGenderRow">
	<field:array_radio xpath="quote/drivers/spouse/gender"
					   required="false"
					   className="spouse_gender" 
					   id="spouse_gender"
					   items="M=Male,F=Female"
					   title="spouse gender"/>
</form:row>
<form:row label="Spouse Employment Status" id="spouseEmploymentRow">
	<field:import_select xpath="quote/drivers/spouse/employmentStatus"
						 required="false" 
						 className="employment_status"
						 url="/WEB-INF/option_data/employment_status.html"
						 title="spouse's employment status" />						
</form:row>
</div>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#spouseExists, #spouse_gender").buttonset();
	});

	<c:set var="spouseExists" value="${data[spouseExistsXpath]}" />
	
	<%-- Initial: Hide spouse info capture if exists is no or blank --%>
	<c:if test="${spouseExists != 'Y'}">
		jQuery("#spouseDobRow, #spouseGenderRow, #spouseEmploymentRow")
					.hide()
					.attr("disabled", true);	
	</c:if>
	
	<%-- Interactive: Hide young driver questions if answer is no --%>
	jQuery(".spouseExists input").change(function(){
	
		if ($(this).val() == 'N'){
		
			jQuery("#spouseDobRow, #spouseGenderRow, #spouseEmploymentRow")
				.slideUp('normal')
				.attr('disabled', true);
			$('#spouseRow :input').each(function(index) {
				$(this).rules("remove", "required");		
			});	
												
		} else {			

			jQuery("#spouseDobRow, #spouseGenderRow, #spouseEmploymentRow")
						.slideDown('normal')
						.removeAttr('disabled');
			$('#spouseRow :input').each(function(index) {
				$(this).rules("add", {required: true});		
			});

		}
		
	});
	
</go:script>
