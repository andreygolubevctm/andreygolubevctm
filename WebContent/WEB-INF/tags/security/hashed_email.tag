<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Returns the unhashed email address or false"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<%@ attribute name="action" 	required="true"	 	rtexprvalue="true"	 description="What to do with the email" %>
<%@ attribute name="email" 		required="true"	 	rtexprvalue="true"	 description="The hashed email coming from an unsubscribe link" %>
<%@ attribute name="brand"		required="true"		rtexprvalue="true"	 description="The brand to check against (ie. CTM, CC, etc.)" %>
<%@ attribute name="output"		required="false"	rtexprvalue="true"	 description="What kind of info/format to output (email for the unhashed email address, json for a json object of the email row)" %>

<%-- IMPORTANT: case matters when generating HASH - always use one case style and don't leave it up to the case of the string provided --%>
<c:set var="brand">${fn:toUpperCase(brand)}</c:set>

<c:if test="${empty output}"><c:set var="output" value="email" /></c:if>
<c:set var="salt" value="++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1yt N|E2qg" />

<%-- 
	PLEASE NOTE, 1. The where clause to return a '' brand should be removed when the database code is cleaned up
	2. This is currently inconpatible with multiple brands. The unique constraint on the email field in the database needs to be removed and the sql queries would need to be updated to support email+brand as the unique identifier. 
--%>

<c:choose>
	<c:when test="${action eq 'encrypt'}">
		<%-- RFC RFC3696 states max length of email i
		s 256, cut to prevent possible abuse AGG-1800 --%>
		<sql:query var="results">
			SELECT CAST( SHA1(CONCAT(?, ?, ?)) AS CHAR ) as result;
			<sql:param value="${fn:substring(fn:toLowerCase(email), 0, 256)}" /> <%-- TRV-162: Normalise Email address to lowercase before output the hash value --%>
			<sql:param value="${salt}" />
			<sql:param value="${brand}" />
		</sql:query>
		
		<c:set var="email_result">${results.rows[0].result}</c:set>
	</c:when>
	<c:when test="${action eq 'decrypt'}">

		<jsp:useBean id="emailMasterDAO" class="com.ctm.dao.EmailMasterDao" scope="request" />
		<c:set var="emailDetails" value="${emailMasterDAO.decrypt(fn:substring(email, 0, 256), styleCodeId)}" />

		<c:choose>
			<c:when test="${emailDetails.isValid()}">
				<c:set var="email_result">
				<c:choose>
						<c:when test="${output eq 'id'}">
							${emailDetails.getEmailId()}
						</c:when>
					<c:otherwise>
							${emailDetails.getEmailAddress()}
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