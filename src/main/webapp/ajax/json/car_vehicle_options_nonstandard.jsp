<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<%-- JSON --%>
<json:object>
	<json:array name="items" prettyPrint="false">

		<sql:query var="accListResult">
			SELECT `code`, `description`, `standard`, `min`, `max` FROM aggregator.vehicle_nonstandard ORDER BY `description`;
		</sql:query>
		<c:forEach items="${accListResult.rows}" var="accList" varStatus="status">
			<json:object>
				<json:property name="code" value="${accList.code}" escapeXml="false"/>
				<json:property name="label" value="${accList.description}" escapeXml="false"/>
				<json:property name="standard" value="${accList.standard}" escapeXml="false"/>
				<json:property name="min" value="${accList.min}" escapeXml="false"/>
				<json:property name="max" value="${accList.max}" escapeXml="false"/>
			</json:object>
		</c:forEach>

	</json:array>
</json:object>