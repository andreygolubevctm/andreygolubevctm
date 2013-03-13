<%@ page language="java" contentType="text/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- Load the params into data --%>
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" value="*PARAMS" />



<c:set var="testInstance" value="" />
<c:set var="siteName" value="${fn:toLowerCase(data.siteName)}" />


<c:forTokens items="${param}" delims="," var="paramData">
   	<c:choose>
		<c:when test="${fn:contains(paramData, 'testDesc')}">
			<c:set var="desc" value="${data[siteName].testDesc}" />
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${testInstance == ''}"><c:set var="testInstance" value="${paramData}"/></c:when>
				<c:otherwise><c:set var="testInstance" value="${testInstance},${paramData}"/></c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>
</c:forTokens>


<sql:setDataSource dataSource="jdbc/aggregator"/>
 <%-- insert test case into DB --%>
<c:choose>
	<c:when test="${testInstance != ''}">
		<sql:update>
			INSERT INTO aggregator.test_instances (testCase, siteName, testDesc) VALUES ('${testInstance}','${data.siteName}','${desc}')
		</sql:update>
		<c:set var="resultXML" value="<result>succcess</result>" />
	</c:when>
	<c:otherwise>
		<c:set var="resultXML" value="<result>failed</result>" />
	</c:otherwise>
</c:choose> 



<%-- XML RESPONSE --%>

${go:XMLtoJSON(resultXML)}
