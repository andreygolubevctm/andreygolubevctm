<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Returns the unhashed email address or false"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%@ attribute name="action" 	required="true"	 	rtexprvalue="true"	 description="What to do with the email" %>
<%@ attribute name="email" 		required="true"	 	rtexprvalue="true"	 description="The hashed email coming from an unsubscribe link" %>
<%@ attribute name="brand"		required="true"		rtexprvalue="true"	 description="The brand to check against (ie. CTM, CC, etc.)" %>
<%@ attribute name="DISC"		required="false"	rtexprvalue="true"	 description="Custom case if the source is DISC" %>
<%@ attribute name="output"		required="false"	rtexprvalue="true"	 description="What kinf of info/format to ouput (email for the unhashed email address, json for a json object of the email row)" %>

<c:if test="${empty output}"><c:set var="output" value="email" /></c:if>
<c:if test="${empty DISC}"><c:set var="DISC" value="false" /></c:if>
<c:set var="salt" value="++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1yt N|E2qg" />

<%-- 
	PLEASE NOTE, 1. The where clause to return a '' brand should be removed when the database code is cleaned up
	2. This is currently inconpatible with multiple brands. The unique constraint on the email field in the database needs to be removed and the sql queries would need to be updated to support email+brand as the unique identifier. 
--%>

<c:choose>
	<c:when test="${action eq 'encrypt'}">
		<sql:query var="results">
			SELECT CAST( SHA1(CONCAT(?, ?)) AS CHAR ) as result;
			<sql:param value="${email}" />
			<sql:param value="${salt}" />
		</sql:query>
		
		<c:set var="email_result">${results.rows[0].result}</c:set>
	</c:when>
	<c:when test="${action eq 'decrypt'}">

		<c:choose>
			<c:when test="${DISC eq 'true'}">

				<sql:query var="results">
					SELECT *
					FROM aggregator.email_master
					WHERE emailAddress=?
					AND (brand=? OR brand = '')
					LIMIT 1;
					<sql:param value="${email}" />
					<sql:param value="${brand}" />
				</sql:query>
	
			</c:when>
			<c:otherwise>

				<sql:query var="results">
					SELECT *
					FROM aggregator.email_master
					WHERE hashedEmail=?
					<%--
					AND (brand=? OR brand = '')
					--%>
					LIMIT 1;
					<sql:param value="${email}" />
					<%--
					TODO: support multiple brands per email in that database
					<sql:param value="${brand}" />
					--%>
				</sql:query>

			</c:otherwise>
		</c:choose>

		<c:choose>
			<c:when test="${results.rowCount > 0}">
				<c:set var="email_result">
				<c:choose>
					<c:when test="${output eq 'json'}">
							{
							<c:forEach items="${results.rows[0]}" var="property" varStatus="status">
								'${fn:replace(status.current,"=","':'")}'<c:if test="${not status.last}">,</c:if>
							</c:forEach>
							}
					</c:when>
					<c:otherwise>
						${results.rows[0].emailAddress}
					</c:otherwise>
				</c:choose>
				</c:set>
			</c:when>
			<c:otherwise>
				<c:set var="email_result" value="${false}" />
			</c:otherwise>
		</c:choose>
		


	</c:when>
</c:choose>
${email_result}