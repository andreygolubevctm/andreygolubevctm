<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('tag.agg.email_send')}" />
<core_v2:no_cache_header/>

<session:get settings="true"/>

<%@ attribute name="brand"		required="true"	 rtexprvalue="true"	 description="Brand applicable to the email" %>
<%@ attribute name="vertical"	required="true"	 rtexprvalue="true"	 description="Vertical applicable to the email" %>
<%@ attribute name="email"		required="true"	 rtexprvalue="true"	 description="Email address to be posted to" %>
<%@ attribute name="mode"		required="true"	 rtexprvalue="true"	 description="Type of email to be sent" %>
<%@ attribute name="tmpl"		required="true"	 rtexprvalue="true"	 description="Email template to use" %>

<%-- Need to guarantee that the transaction header record has the current email address.
	Is needed for the quote url to link the transaction with the hashed email. --%>
<c:if test="${not empty data.current.transactionId}">
	<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
	<c:catch var="ignoreable_error">
		<sql:update var="result">
			UPDATE aggregator.transaction_header
			SET EmailAddress = ?
			WHERE TransactionId = ? AND EmailAddress='';
			<sql:param value="${email}" />
			<sql:param value="${data.current.transactionId}" />
		</sql:update>
	</c:catch>
</c:if>

<c:set var="sendYN">
	<c:choose>
		<c:when test="${pageSettings.hasSetting('sendYN') eq 'false'}">false</c:when>
		<c:otherwise>${pageSettings.getSetting('sendYN')}</c:otherwise>
	</c:choose>
</c:set>

<c:choose>
	<c:when test="${sendYN eq 'Y'}">
		<security:authentication justChecking="true" emailAddress="${email}" />
		<c:set var="emailSubscribed">
			<c:choose>
				<c:when test="${userData.optInMarketing eq true}">Y</c:when>
				<c:otherwise>N</c:otherwise>
			</c:choose>
		</c:set>
		<c:set var="emailResponse">
			<c:import url="../json/send.jsp">
				<c:param name="vertical" value="${fn:toUpperCase(vertical)}" />
				<c:param name="mode" value="${mode}" />
				<c:param name="tmpl" value="${tmpl}" />
				<c:param name="emailAddress" value="${email}" />
				<c:param name="hashedEmail" value="${userData.hashedEmail}" />
				<c:param name="emailSubscribed" value="${emailSubscribed}" />
			</c:import>
		</c:set>
		<go:setData dataVar="data" xpath="userData/emailSent" value="true" />
	</c:when>
	<c:when test="${sendYN eq 'N'}">
		${logger.warn('[sendYN] No email sent - Emails are not sent for this brand/vertical combo')}
	</c:when>
	<c:otherwise>
		${logger.warn('[sendYN] No email sent - Value is not defind')}
	</c:otherwise>
</c:choose>