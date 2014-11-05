<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Regular Driver Form Component - Extra"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<%-- Test if we have a commencement date already set - if not then set to today--%>
<c:if test="${empty data.quote.options.commencementDate}">
	<jsp:useBean id="now" class="java.util.Date" />
	<fmt:formatDate var="commencementDate" value="${now}" pattern="dd/MM/yyyy"/>
	<go:setData dataVar="data" xpath="${xpath}" value="${commencementDate}" />
</c:if>

<form_new:fieldset legend="Your preferred date to start the insurance" id="${xpath}FieldSet">
	<form_new:row label="Commencement date">
		<field_new:commencement_date xpath="${xpath}" mode="separated" includeMobile="false" />
	</form_new:row>
</form_new:fieldset>
<car:commencement_date_expired />