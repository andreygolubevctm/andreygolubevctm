<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Call Me Back form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="id" required="true" rtexprvalue="true"	description="ID to assign to the form" %>
<%@ attribute name="displayBubble" required="false" rtexprvalue="true"	description="Whether to display the right hand side column with the speech bubble" %>

<%@ attribute name="labelsClassName" required="false" rtexprvalue="true"	description="Classes on labels" %>
<%@ attribute name="fieldsContainerClassName" required="false" rtexprvalue="true"	description="Classes on field containers" %>
<%@ attribute name="submitButtonContainerClassName" required="false" rtexprvalue="true"	description="Classes on submit button container" %>

<c:if test="${empty displayBubble}">
	<c:set var="displayBubble" value="false" />
</c:if>
<c:choose>
	<c:when test="${displayBubble eq true}">
		<c:set var="leftColumnWidthClass" value="col-sm-8" />
		<c:set var="rightColumnWidthClass" value="col-sm-4" />
	</c:when>
	<c:otherwise>
		<c:set var="leftColumnWidthClass" value="col-xs-12" />
	</c:otherwise>
</c:choose>

<c:if test="${empty labelsClassName}">
	<c:set var="labelsClassName" value="col-sm-4" />
</c:if>
<c:if test="${empty fieldsContainerClassName}">
	<c:set var="fieldsContainerClassName" value="col-sm-8" />
</c:if>
<c:if test="${empty submitButtonContainerClassName}">
	<c:set var="submitButtonContainerClassName" value="col-sm-offset-4" />
</c:if>

<form id="${id}" class="form-horizontal call-me-back-form">

	<div class="row">

		<div class="${leftColumnWidthClass}">

			<h5>Get a call back</h5>

			<div class="form-group row">
				<c:set var="fieldXpath" value="${pageSettings.vertical}/callmeback/name" />
				<field_new:label value="Your name" xpath="${fieldXpath}" className="${labelsClassName}" />
				<div class="row-content ${fieldsContainerClassName}">
					<field_new:input xpath="${fieldXpath}" title="name" required="false" className="callmeback_name" />
				</div>
			</div>

			<div class="form-group row">
				<c:set var="fieldXpath" value="${pageSettings.vertical}/callmeback/phone" />
				<field_new:label value="Your best contact number" xpath="${fieldXpath}input" className="${labelsClassName}" />
				<div class="row-content ${fieldsContainerClassName}">
					<field:contact_telno xpath="${fieldXpath}" required="true" title="contact number" className="callmeback_phone" />
				</div>
			</div>

			<div class="form-group row">
				<c:set var="fieldXpath" value="${pageSettings.vertical}/callmeback/timeOfDay" />
				<field_new:label value="Best time to contact you" xpath="${fieldXpath}" className="${labelsClassName}" />
				<div class="row-content ${fieldsContainerClassName}">
					<field_new:array_select
						items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)"
						xpath="${fieldXpath}"
						title="Best time to call"
						className="callmeback_timeOfDay"
						required="false" />
				</div>
			</div>

			<field:hidden xpath="${pageSettings.vertical}/callmeback/optin" defaultValue="N" className="callmeback_optin" />

			<div class="form-group row">
				<div class="<c:out value='${submitButtonContainerClassName} ${fieldsContainerClassName}' />">
					<a href="javascript:;" class="btn btn-primary disabled call-me-back-submit">Call me</a>
				</div>
			</div>

		</div>

		<c:if test="${displayBubble eq true }">
			<div class="${rightColumnWidthClass} hidden-xs">
				<ui:bubble variant="info">
					<h1>Do you need a hand?</h1>
					<h6>Call us on 1800 77 77 12</h6>
					<p><small>Our Australian based call centre hours are <strong><form:scrape id='135'/></strong></small></p>
				</ui:bubble>
			</div>
		</c:if>

	</div>

</form>