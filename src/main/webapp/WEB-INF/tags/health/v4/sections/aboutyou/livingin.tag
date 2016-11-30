<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Living status row"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" 		required="true"	 rtexprvalue="true"	 description="field group's xpath" %>

<%-- VARIABLES --%>
<c:set var="name" 			value="${go:nameFromXpath(xpath)}" />

<%-- If the user is coming via a broucherware site where by a state is passed in instead of a postcode, then only show state selection --%>

<c:set var="fieldXpath" value="${xpath}/location" />
<c:set var="state" value="${data['health/situation/state']}" />
<c:set var="location" value="${data['health/situation/location']}" />

<form_v4:row label="Living in" fieldXpath="${fieldXpath}" className="health-location">

	<c:choose>
		<c:when test="${not empty param.state || (not empty state && empty location && (param.action == 'amend' || param.action == 'load'))}">
			<field_v1:state_select xpath="${xpath}/state" useFullNames="true" title="State" required="true" />
		</c:when>
		<c:otherwise>
			<field_v2:lookup_suburb_postcode xpath="${fieldXpath}" required="true" placeholder="Suburb / Postcode" extraDataAttributes=" data-rule-validateLocation='true' " />
			<field_v1:hidden xpath="${xpath}/state" />
		</c:otherwise>
	</c:choose>

	<field_v1:hidden xpath="${xpath}/suburb" />
	<field_v1:hidden xpath="${xpath}/postcode" />

</form_v4:row>