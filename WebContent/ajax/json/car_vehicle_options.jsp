<%@ page language="java" contentType="text/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%-- Ideally this should be squared away into a service --%>

<sql:query var="standard">

	SELECT code, des
		FROM aggregator.vehicle_accessories
		WHERE redbookCode = ? AND type = 'S'
		ORDER BY des;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<sql:query var="options">

	SELECT code, des
		FROM aggregator.vehicle_accessories
		WHERE redbookCode = ?
			AND type = 'O'
		ORDER BY des;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<sql:query var="alarm">
	SELECT code, des
		FROM aggregator.vehicle_accessories
		WHERE redbookCode = ? AND type = 'S'
			AND des LIKE ('%alarm%')
		LIMIT 1;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<sql:query var="immobiliser">
	SELECT code, des
		FROM aggregator.vehicle_accessories
		WHERE redbookCode = ? AND type = 'S'
			AND des LIKE ('%immobil%')
		LIMIT 1;
	<sql:param>${param.redbookCode}</sql:param>
</sql:query>

<%-- JSON --%>
<json:object>
	<json:array name="standard" var="item" items="${standard.rows}" prettyPrint="true">
		<json:object>
			<json:property name="code" value="${item.code}" escapeXml="false"/>
			<json:property name="label" value="${item.des}" escapeXml="false"/>
		</json:object>
	</json:array>
	<json:array name="options" var="item" items="${options.rows}" prettyPrint="true">
		<json:object>
			<json:property name="code" value="${item.code}" escapeXml="false"/>
			<json:property name="label" value="${item.des}" escapeXml="false"/>
		</json:object>
	</json:array>
	<json:array name="alarm" var="item" items="${alarm.rows}" prettyPrint="true">
		<json:object>
			<json:property name="code" value="${item.code}" escapeXml="false"/>
			<json:property name="label" value="${item.des}" escapeXml="false"/>
		</json:object>
	</json:array>
	<json:array name="immobiliser" var="item" items="${immobiliser.rows}" prettyPrint="true">
		<json:object>
			<json:property name="code" value="${item.code}" escapeXml="false"/>
			<json:property name="label" value="${item.des}" escapeXml="false"/>
		</json:object>
	</json:array>
</json:object>