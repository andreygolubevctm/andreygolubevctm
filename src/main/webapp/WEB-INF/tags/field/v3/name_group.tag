<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="Set xpath base"%>
<%@ attribute name="showInitial" required="false" rtexprvalue="true" description="Toggle to display initial field"%>

<%-- HTML --%>
<form_v2:row label="Name" hideHelpIconCol="true" className="row" addRowClass="${true}">
	<div class="col-sm-2 col-xs-12">
		<c:set var="fieldXpath" value="${xpath}/title" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Title" hideHelpIconCol="true" labelClassName="hidden-sm hidden-md hidden-lg" removeSMsize="${true}">
			<field_v3:import_select xpath="${fieldXpath}" title="${title} title"  required="true" url="/WEB-INF/option_data/titles_quick.html" className="person-title" additionalAttributes=" data-rule-genderTitle='true' "/>
		</form_v2:row>
	</div>
	<div class="col-sm-4 col-xs-12">
		<c:set var="fieldXpath" value="${xpath}/firstname" />
		<form_v2:row fieldXpath="${fieldXpath}" label="First Name" hideHelpIconCol="true" labelClassName="hidden-sm hidden-md hidden-lg" removeSMsize="${true}">
			<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} first name" className="contactField" placeholder="First name" />
		</form_v2:row>
	</div>
	<c:if test="${showInitial eq true}">
	<div class="col-sm-2 col-xs-12">
		<c:set var="fieldXpath" value="${xpath}/middleName" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Middle Name" hideHelpIconCol="true" labelClassName="hidden-sm hidden-md hidden-lg" removeSMsize="${true}">
			<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} middle name" className="contactField" placeholder="M" />
		</form_v2:row>
	</div>
	</c:if>
	<div class="col-sm-4 col-xs-12">
		<c:set var="fieldXpath" value="${xpath}/surname" />
		<form_v2:row fieldXpath="${fieldXpath}" label="Last Name" hideHelpIconCol="true" labelClassName="hidden-sm hidden-md hidden-lg" removeSMsize="${true}">
			<field_v1:person_name xpath="${fieldXpath}" required="true" title="${title} last name" className="contactField" placeholder="Last name" />
		</form_v2:row>
	</div>
</form_v2:row>