<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group for youngest driver selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="className" value="${go:nameFromXpath(xpath)}" />
<c:set var="youngDriverXpath" value="${xpath}" />
<c:set var="youngDriverExistsXpath" value="${xpath}/exists" />
<c:set var="youngName" value="${go:nameFromXpath(youngDriverExistsXpath)}" />

<%-- HTML --%>
<form:row label="Will any driver (including a spouse or household member) be younger than the Regular Driver" helpId="12" id="quote_drivers_youngDriverRow">
	<field:array_radio xpath="quote/drivers/young/exists"
					   required="true"
					   className="youngExists"
					   id="youngExists"
					   items="Y=Yes,N=No"
					   title="if any driver (including a spouse or household member) is younger than the Regular Driver"/>
</form:row>

<div id="youngDriverRow">
	<form:row label="Date of birth of youngest driver" id="youngDriverDobRow">
		<field:person_dob xpath="quote/drivers/young/dob" required="true" title="youngest driver's"/>
	</form:row>
	
	<form:row label="Age the youngest driver obtained a drivers licence" id="youngDriverLicenceAgeRow">
		<field:age_licence xpath="quote/drivers/young/licenceAge" required="true" title="youngest" />
	</form:row>
	
	<form:row label="Approximate annual kilometers driven by the youngest driver" id="young_annual_kilometres_row">
		<field:kilometers_travelled xpath="quote/drivers/young/annualKilometres"
									id="quote_drivers_young_annualKilometres"
									className="young_annual_kilometres"
									required="true" />
	</form:row>
	
	<form:row label="Gender" id="youngDriverGenderRow">
		<field:array_radio xpath="quote/drivers/young/gender"
						   required="true"
						   className="young_gender" 
						   id="young_gender"
						   items="M=Male,F=Female"
						   title="youngest driver's gender"/>
	</form:row>
</div>

<%-- CSS --%>
<go:style marker="css-head">

	#young_annual_kilometres_row {
		width: 250px;
		float: left;
	}
	#young_annual_kilometres, #quote_drivers_young_annualKilometres {
		width: 50px;
		margin-top:6px;
	}
	#quote_drivers_young_licenceAge {
		margin-top:6px;	
	}
	#youngDriverRow {
		width: 485px;
		overflow: hidden;
	}
	#youngDriverDobRow {
		height: 30px;
		padding-top:3px;
	}
	#youngDriverDobRow .fieldrow_label {
		vertical-align:bottom;
	} 
	#youngDriverLicenceAgeRow {
    	margin-top:1px;
    	width:280px;float:left;
  	}
  	#youngDriverLicenceAgeRow input{
  		vertical-align:middle;
  	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#youngExists, #young_gender").buttonset();
	});
	
	$("#quote_drivers_young_gender_M").click(function(){			
		$('input[id="quote_drivers_young_gender_M"]').attr({checked: true});
		});	

	<c:set var="youngDriverExists" value="${data[youngDriverExistsXpath]}" />
	
	<%-- Initial: Hide young driver info capture if exists is no or blank --%>
	<c:if test="${youngDriverExists != 'Y'}">
		jQuery("#youngDriverRow").hide();
		
		$('#youngDriverRow :input').each(function(index) {
			$(this).rules("remove", "required");
		});
		$('#youngDriverRow ').find('input[type=text]').val("");
		$('input[name="quote_drivers_young_gender"]').attr({checked: false}).button('refresh');
		
	</c:if>
	
	<%-- Interactive: Hide young driver questions if answer is no --%>
	jQuery(".youngExists input").change(function(){
	
		if ($(this).val() == 'N'){
			jQuery("#youngDriverRow").slideUp('normal');
			$('#youngDriverRow :input').each(function(index) {
				$(this).rules("remove", "required");
			});
		} else {
			jQuery("#youngDriverRow").slideDown('normal');
			$('#youngDriverRow :input').each(function(index) {
				$(this).rules("add", {required:true});
			});			
		}
		$('#youngDriverRow ').find('input[type=text]').val("");
		$('input[name="quote_drivers_young_gender"]').attr({checked: false}).button('refresh');
		
	});
	
</go:script>

<%-- VALIDATION --%>
<go:validate selector="quote_drivers_young_dob" rule="youngRegularDriversAgeCheck" parm="true" message="Youngest driver should not be older than the regular driver."/>

