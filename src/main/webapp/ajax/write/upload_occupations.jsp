<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger(pageContext.request.servletPath)}" />

<sql:setDataSource dataSource="jdbc/ctm"/>

<%--
AUTOMATIC CRON JOB FOR LIFEBROKER OCCUPATION SERVICE
====================================================
To be run once a month

Update status codes - returned in XML summary:
200 (Successful)
400 (Failed - XML contains bad syntax, data does not conform)
401 (Failed - Denied or Unauthorised)
404 (Failed - XML not returned - or not XML)
500 (Failed - Server Error or SQL error)

Process:
- Import the XML from the service call
-- iterate each occupation and:
--- INSERT or UPDATE into the database
---- Handle any errors
---- Return summary XML
--%>


<%-- VARIABLES --%>
<c:set var="errorPool" value='' />
<c:set var="errorSoftPool" value='' />

<%--IMPORT XML data from Life Broker --%>
<go:import var="dataXML" url="https://enterpriseapi.lifebroker.com.au/2-6-0/occupation/list" username="compthemkt" password="lI9hW2qIlx2f4G" />

<x:parse doc="${dataXML}" var="data" />
<c:set var="counter" value="${1}" />
<x:forEach select="$data//*[local-name()='occupation' and namespace-uri()='urn:Lifebroker.EnterpriseAPI']" var="x">
	<c:set var="id"><x:out select="$x/*[local-name()='id' and namespace-uri()='urn:Lifebroker.EnterpriseAPI']" /></c:set>
	<c:set var="value"><x:out select="$x/*[local-name()='value' and namespace-uri()='urn:Lifebroker.EnterpriseAPI']" /></c:set>
	${logger.info('Retrieved lifebroker occupation. {},{}', log:kv('id',id), log:kv('value',value))}
	<c:catch var="error">
		<sql:update var="update">
			INSERT INTO aggregator.general (type, code, description, orderSeq)
			VALUES
			(?,?,?,?)
			ON DUPLICATE KEY UPDATE
				description = '${value}',
				orderSeq = '${counter}';
			<sql:param value="occupation" />
			<sql:param value="${id}" />
			<sql:param value="${value}" />
			<sql:param value="${counter}" />
		</sql:update>
	</c:catch>
	<c:set var="counter" value="${counter + 1}" />

	<c:if test="${not empty error}">
		${logger.error('failed to insert into aggregator.general. {},{},{}', log:kv('value',value), log:kv('counter',counter), log:kv('id',id), error)}
	</c:if>
</x:forEach>

