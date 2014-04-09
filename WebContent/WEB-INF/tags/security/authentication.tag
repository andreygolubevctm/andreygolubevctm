<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="emailAddress" required="true" rtexprvalue="true" description="email address to authenticate against" %>
<%@ attribute name="password" required="false" rtexprvalue="true" description="password to authenticate against" %>
<%@ attribute name="hashedEmail" required="false" rtexprvalue="true" description="hashedEmail to authenticate against" %>
<%@ attribute name="vertical" required="false" rtexprvalue="true" description="vertical" %>
<%@ attribute name="brand" required="false" rtexprvalue="true" description="brand" %>

<jsp:useBean id="userData" class="com.disc_au.web.go.Data" scope="request" />

<c:set var="loginExists" value="false" />
<c:set var="validCredentials" value="false" />
<c:set var="optInMarketing" value="false" />

<c:choose>
	<c:when test="${empty emailAddress}">
	</c:when>
	<c:when test="${not empty hashedEmail}">
		<c:set var="emailAddressFromhash"><security:hashed_email action="decrypt" email="${hashedEmail}" brand="${brand}" /></c:set>
		<c:choose>
			<c:when test="${fn:toUpperCase(emailAddress) == fn:toUpperCase(emailAddressFromhash)}">
				<c:set var="validCredentials" value="true" />
				<sql:query var="emailResults" dataSource="jdbc/aggregator">
					SELECT em.emailPword as emailPword,
					ep.value
					FROM aggregator.email_master em
					LEFT JOIN aggregator.email_properties ep
						ON ep.emailAddress = em.emailAddress
						<c:if test="${not empty vertical}" >
							AND ep.vertical = ?
						</c:if>
						<c:if test="${not empty brand}" >
							AND ep.brand = ?
						</c:if>
					AND propertyId = 'marketing'
					WHERE em.emailAddress = ?
					GROUP BY emailPword;
					<c:if test="${not empty vertical}" >
						<sql:param>${vertical}</sql:param>
					</c:if>
					<c:if test="${not empty brand}" >
						<sql:param>${brand}</sql:param>
					</c:if>
					<sql:param>${emailAddress}</sql:param>
				</sql:query>
				<c:choose>
					<c:when test="${emailResults.rowCount > 0}">
						<c:set var="optInMarketing" value="${not empty emailResults.rows[0].value && emailResults.rows[0].value == 'Y'}" />
						<c:set var="loginExists" value="${not empty fn:trim(emailResults.rows[0].emailPword)}" />
						<c:set var="password" value="${emailResults.rows[0].emailPword}" />
						<security:log_audit identity="${emailAddressFromhash}" action="LOG IN" result="SUCCESS" metadata="<hashedEmail>${hashedEmail}</hashedEmail><brand>${brand}</brand><vertical>${vertical}</vertical>" />
					</c:when>
					<c:otherwise>
						<security:log_audit identity="${emailAddressFromhash}" action="LOG IN" result="FAIL" description="hashedEmail matched ${emailResults.rowCount} rows" metadata="<emailAddressPlain>${emailAddress}</emailAddressPlain><hashedEmail>${hashedEmail}</hashedEmail><brand>${brand}</brand><vertical>${vertical}</vertical>" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<security:log_audit identity="${emailAddressFromhash}" action="LOG IN" result="FAIL" description="Did not match emailAddress" metadata="<emailAddressPlain>${emailAddress}</emailAddressPlain><hashedEmail>${hashedEmail}</hashedEmail><brand>${brand}</brand><vertical>${vertical}</vertical>" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<sql:query var="emailResults" dataSource="jdbc/aggregator">
			SELECT em.emailPword as emailPword,
				em.hashedEmail, ep.value
				FROM aggregator.email_master em
				LEFT JOIN aggregator.email_properties ep
					ON ep.emailAddress = em.emailAddress
					<c:if test="${not empty vertical}" >
						AND ep.vertical = ?
					</c:if>
					<c:if test="${not empty brand}" >
						AND ep.brand = ?
					</c:if>
				AND propertyId = 'marketing'
			WHERE em.emailAddress = ?
			GROUP BY emailPword;
			<c:if test="${not empty vertical}" >
				<sql:param>${vertical}</sql:param>
			</c:if>
			<c:if test="${not empty brand}" >
				<sql:param>${brand}</sql:param>
			</c:if>
			<sql:param>${emailAddress}</sql:param>
		</sql:query>
		<c:choose>
			<c:when test="${emailResults.rowCount > 0}">
				<c:set var="optInMarketing" value="${not empty emailResults.rows[0].value && emailResults.rows[0].value == 'Y'}" />
				<c:set var="loginExists" value="${not empty fn:trim(emailResults.rows[0].emailPword)}" />
				<c:if test="${loginExists}">
					<c:set var="validCredentials" value="${emailResults.rows[0].emailPword == password}" />
				</c:if>
				<c:choose>
					<c:when test="${validCredentials}">
						<security:log_audit identity="${emailAddress}" action="LOG IN" result="SUCCESS" />
					</c:when>
					<c:when test="${loginExists && not empty password}"> <%-- When creating a new quote/user --%>
						<security:log_audit identity="${emailAddress}" action="LOG IN" result="FAIL" description="Password does not match" />
					</c:when>
				</c:choose>
				<c:set var="hashedEmail" value="${emailResults.rows[0].hashedEmail}" />
				<c:set var="password" value="${emailResults.rows[0].emailPword}" />
			</c:when>
			<c:otherwise>
				<security:log_audit identity="${emailAddress}" action="LOG IN" result="FAIL" description="Login does not exist" />
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<go:setData dataVar="userData" xpath="loginExists" value="${loginExists}" />
<go:setData dataVar="userData" xpath="validCredentials" value="${validCredentials}" />
<go:setData dataVar="userData" xpath="emailAddress" value="${emailAddress}" />
<go:setData dataVar="userData" xpath="optInMarketing" value="${optInMarketing}" />
<go:setData dataVar="userData" xpath="hashedEmail" value="${hashedEmail}" />
<go:setData dataVar="userData" xpath="password" value="${password}" />