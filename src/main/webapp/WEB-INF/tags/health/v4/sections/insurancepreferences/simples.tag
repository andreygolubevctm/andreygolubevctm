<%@ tag description="The Health More Info template"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="partner's lhc xpath" %>

<c:if test="${callCentre}">
	<c:set var="fieldXpath" value="${xpath}/partner/lhc" />
	<form_v2:row label="Partner's LHC" fieldXpath="${fieldXpath}">
		<field_v1:input_numeric xpath="${fieldXpath}" minValue="0" maxValue="70" title="Partner's LHC" required="false" id="${name}_partner_lhc" maxLength="2" className="partner-lhc"/>
	</form_v2:row>
</c:if>