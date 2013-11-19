<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="NCD Protection Tag"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="variable's xpath" %>
<%@ attribute name="required" 	required="true"	 rtexprvalue="false" description="is this field required?" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}" />

<%-- HTML --%>
<field:array_radio xpath="${xpath}"
					required="false"
					className="${className} driver_ncdpro"
					id="driver_ncdpro"
					items="Y=Yes,N=No"
					title="ncd protection"/>
<%-- <label for="${name}" class="error">Please enter if NCD protection is required</label> --%>

<%-- VALIDATION --%>
<go:validate selector="${name}" rule="required" parm="${required}" message="Please choose if NCD protection is required"/>

<%-- CSS --%>
<go:style marker="css-head">
	label.error {
		display:none;
	}
</go:style>

<%-- JAVASCRIPT --%>
<go:script marker="onready">

	$(function() {
		$("#driver_ncdpro").buttonset();
	});

</go:script>