<%@ tag description="Enables the user to be able to have a basic recovery from a lost session"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="ipAddressHandler" class="com.ctm.web.core.security.IPAddressHandler" scope="application" />
<jsp:useBean id="selectedProductService" class="com.ctm.web.health.services.HealthSelectedProductService" scope="application" />

<c:set var="logger" value="${log:getLogger('tag.error.recover')}" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%@ attribute name="quoteType" 	required="true" rtexprvalue="true" description="The vertical (Required: will attempt to load the settings file)" %>
<%@ attribute name="origin"		required="true" rtexprvalue="true" description="Page/Tag where the recovery has been called" %>
<%@ attribute name="lastKnownTransactionId" required="false" rtexprvalue="true" description="TransationId used to perform and vertical specific recover operations" %>
<%@ attribute name="selectedProductId" required="false" rtexprvalue="true" description="ProductId of the selected product" %>

${logger.info('core:recover START. {},{}', log:kv('quoteType',quoteType ), log:kv('origin',origin ))}

<c:set var="serverIp"><%
	String ip = request.getLocalAddr();
	try {
		java.net.InetAddress address = java.net.InetAddress.getLocalHost();
		ip = address.getHostAddress();
	}
	catch (Exception e) {}
%><%= ip %></c:set>

<%-- Recreate the settings and Transaction Id --%>
<c:set var="id_return">
    <c:choose>
        <c:when test="${not empty lastKnownTransactionId}">
            <core_v1:get_transaction_id quoteType="${quoteType}" transactionId="${lastKnownTransactionId}" id_handler="preserve_tranId" />
        </c:when>
        <c:otherwise>
            <core_v1:get_transaction_id quoteType="${quoteType}" id_handler="new_tranId" />
        </c:otherwise>
    </c:choose>

</c:set>

<core_v1:transaction touch="H" comment="Recover" noResponse="true" writeQuoteOverride="N" />

<c:set var="message">error:recovery quoteType=${quoteType} transactionId=${data['current/transactionId']} ipAddress=${ipAddressHandler.getIPAddress(pageContext.request)}</c:set>
<c:set var="code">500: serverIP=${serverIp} sessionId=<%=session.getId()%></c:set>

<%-- Log the error into the database, as this is an error recovery --%>
<c:catch var="error">
	<sql:update var="results" dataSource="${datasource:getDataSource()}">
		INSERT INTO aggregator.error_log
		  (id, styleCodeId, property, origin, message, code, transactionId, datetime)
		VALUES
		  (NULL, ?, ?, ?, ?, ?, ?, NOW());
		<sql:param value="${styleCodeId}" />
		<sql:param value="${pageSettings.getBrandCode()}" />
		<sql:param value="${origin}" />
		<sql:param value="${message}" />
		<sql:param value="${code}" />
		<sql:param value="${data['current/transactionId']}" />
	</sql:update>
</c:catch>
<c:if test="${error}">
	${logger.warn('Failed to insert into error log. {}', log:kv('message', message), error)}
</c:if>

<%-- Perform vertical specific recovery operations if last known transactionId provided --%>
<c:if test="${not empty lastKnownTransactionId}">
    <c:choose>
        <%-- For HEALTH we want to recover the selected product data if available --%>
        <c:when test="${quoteType.compareToIgnoreCase('health') eq 0 and not empty lastKnownTransactionId and not empty selectedProductId}">
            ${selectedProductService.cloneSelectedProduct(lastKnownTransactionId, data['current/transactionId'], selectedProductId)}
        </c:when>
    </c:choose>
</c:if>