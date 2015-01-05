<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:import var="config" url="/WEB-INF/aggregator/utilities/config_settings.xml" />
<x:parse doc="${config}" var="configOBJ" />
<c:set var="sw_url"><x:out select="$configOBJ//*[local-name()='url']" /></c:set>
<c:set var="sw_user"><x:out select="$configOBJ//*[local-name()='user']" /></c:set>
<c:set var="sw_pwd"><x:out select="$configOBJ//*[local-name()='pwd']" /></c:set>
<c:set var="postcode"><c:out value="${param.postcode}" escapeXml="true"/></c:set>

<c:set var="utilities">
	<go:scrape url="${sw_url}/ProductClassPackageForPostcode/${postcode}" sourceEncoding="UTF-8" username="${sw_user}" password="${sw_pwd}" />
</c:set>

${go:XMLtoJSON(utilities)}