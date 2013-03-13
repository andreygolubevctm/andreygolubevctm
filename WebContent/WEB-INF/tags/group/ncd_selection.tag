<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group for NCD and NCD Protection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="className" value="${go:nameFromXpath(xpath)}" />

<c:set var="ncdXpath" value="${xpath}/ncd" />
<c:set var="ncdName" value="${go:nameFromXpath(ncdXpath)}" />

<%-- HTML --%>
<form:row label="Regular Drivers current No Claims Discount (NCD) or Rating Discount?" helpId="10" id="quote_drivers_regular_ncdRow">
	<field:import_select xpath="${xpath}/ncd" 
					 url="/WEB-INF/option_data/ncd.html"
					 title="the regular driver's NCD or Rating Discount"
					 className="ncd" 
					 required="true" />	
</form:row>

<c:set var="ncdProRow" value="${className}_ncdProRow" />
<form:row label="Do you want to pay an extra premium and protect the No Claims Discount (NCD) or Rating Discount?" id="${ncdProRow}" helpId="15">
	<field:driver_ncdpro xpath="${xpath}/ncdpro" required="false"/>
</form:row>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	<c:set var="v" value="${data[ncdXpath]}" />
	
	<%-- Initial: Hide ncdpro if ncd not = 5 --%>
	<c:if test="${v != 5}">
		$("#${ncdProRow}")
					.hide()
					.attr('disabled', 'disabled');
	</c:if>
	
	<%-- Interactive: Hide ncdpro if ncd not = 5 --%>
	$("#${ncdName}").change(function(){
		if ($(this).val() != 5){

			$('input[name="quote_drivers_regular_ncdpro"]').rules("remove", "required");
			$("#${ncdProRow}")
				.slideUp('normal')
				.attr('disabled', 'disabled');
			
		} else {			

			$("#${ncdProRow}")
						.slideDown('normal')
						.removeAttr('disabled');
			$('input[name="quote_drivers_regular_ncdpro"]').rules("add", {required: true});								
			$('input[id="quote_drivers_regular_ncdpro_Y"]').attr({checked: false});			
			$('input[id="quote_drivers_regular_ncdpro_N"]').attr({checked: false});
			$(':radio').button('refresh');			
		}
	});

</go:script>

<%-- VALIDATION --%>
<go:validate selector="quote_drivers_regular_ncd" rule="ncdValid" parm="true" message="Invalid NCD Rating based on number of years driving."/>
<go:validate selector="quote_drivers_regular_ncd" rule="youngestDriverMinAge" parm="true" message="Driver age restriction invalid due to youngest driver's age."/>
