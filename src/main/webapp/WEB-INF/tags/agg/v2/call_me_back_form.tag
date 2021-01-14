<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Call Me Back form"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="openingHoursService" class="com.ctm.web.core.openinghours.services.OpeningHoursService" scope="page" />

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

			<h4>Get a call back</h4>

			<div class="form-group row">
				<c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/callmeback/name" />
				<field_v2:label value="Your name" xpath="${fieldXpath}" className="${labelsClassName}" />
				<div class="row-content ${fieldsContainerClassName}">
					<field_v2:input xpath="${fieldXpath}" title="name" required="false" className="callmeback_name" />
				</div>
			</div>

			<div class="form-group row">
				<c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/callmeback/phone" />
				<field_v2:label value="Your best contact number" xpath="${fieldXpath}input" className="${labelsClassName}" />
				<div class="row-content ${fieldsContainerClassName}">
					<field_v1:flexi_contact_number xpath="${fieldXpath}"
												maxLength="20"
												required="${true}"
												className="callmeback_phone"
												labelName="best contact number"/>
				</div>
			</div>

			<div class="form-group row">
				<c:set var="fieldXpath" value="${pageSettings.getVerticalCode()}/callmeback/timeOfDay" />
				<field_v2:label value="Best time to contact you" xpath="${fieldXpath}" className="${labelsClassName}" />
				<div class="row-content ${fieldsContainerClassName}">
					<field_v2:array_select
						items="=Please choose...,M=Morning,A=Afternoon,E=Evening (excludes WA)"
						xpath="${fieldXpath}"
						title="Best time to call"
						className="callmeback_timeOfDay"
						required="false" extraDataAttributes="data-msg-required='Please select when you want us to call you back'" />
				</div>
			</div>

			<field_v1:hidden xpath="${pageSettings.getVerticalCode()}/callmeback/optin" defaultValue="N" className="callmeback_optin" />

			<div class="form-group row">
				<div class="<c:out value='${submitButtonContainerClassName} ${fieldsContainerClassName}' />">
					<a href="javascript:;" class="btn btn-cta disabled call-me-back-submit">Call me</a>
				</div>
			</div>

		</div>

		<c:if test="${displayBubble eq true }">
			<div class="${rightColumnWidthClass} hidden-xs">
				<ui:bubble variant="info" className="callCentreNumberSection">
					<h1>Do you need a hand?</h1>
					<h6>Call us on <span class="noWrap callCentreNumber">${callCentreNumber}</span></h6>
					<c:if test="${not empty openingHoursService.getAllOpeningHoursForDisplay(pageContext.getRequest(),false)}">
						<div class="opening-hours">
							<a href="javascript:;" data-toggle="dialog"
								data-content="#view_all_hours"
								data-dialog-hash-id="view_all_hours"
								data-title="Call Centre Hours" data-cache="true">View our Australian based call centre hours
							</a>
						</div>
					</c:if>
				</ui:bubble>
			</div>
		</c:if>

	</div>

</form>