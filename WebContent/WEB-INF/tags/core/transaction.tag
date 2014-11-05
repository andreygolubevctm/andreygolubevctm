<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Wrapper for all transaction touching and quote writes." %>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<core_new:no_cache_header/>



<%@ attribute name="touch" 				required="true"		description="Touch type (single character) e.g. N, R" %>
<%@ attribute name="comment"			required="false"	description="If this is a fail touch (F), optional comment/error message can be specified" %>
<%@ attribute name="noResponse"			required="false"	description="Set to 'true' and this tag will not echo back the outcome" %>
<%@ attribute name="writeQuoteOverride"	required="false"	description="STOP! Do you know what you're doing? Values can be Y or N" %>
<%@ attribute name="emailAddress"	required="false"	description="emailAddress for transaction details" %>
<%--
	core:transaction responses:
	---------------------------
	T = Invalid touch attribute value
	V = Invalid vertical attribute value
	I = Transaction ID is empty
	C = Transaction is already confirmed
	F = Transaction is failed/pending (should only return this if operator=ONLINE)
	Empty response = OK

	Touch types:
	------------
	A = Apply now (user has selected a product and starting application form)
	C = Confirmation (sale/transaction confirmed)
	CB = Call me back
	CD = Call direct
	E = Error (general error e.g. ajax timeout)
	F = Application failed (in Health this is considering Pending and will lock out ONLINE user)
	H = General hit (e.g. tracking user between slides)
	L = Load quote
	LF = Lead feed (currently only used in Life/IP, for when we send a lead feed to Lifebroker)
	N = New quote
	P = Processing/submitting application
	Q = Results single e.g. for 'update premium'
	R = Results page
	S = Save quote
	T = Transferring quote to a 3rd party (eg AFG for Home Loans vertical)
	X = Unlock quote
--%>




<%-- VARIABLES ................................................................... --%>
<c:set var="transactionId" value="" />
<c:set var="vertical" value="${fn:toLowerCase(applicationService.getVerticalCodeFromRequest(pageContext.getRequest()))}" />
<c:set var="touch" value="${fn:toUpperCase(touch)}" />
<c:set var="response" value="" />

<c:set var="write_quote">
	<c:choose>
		<c:when test="${writeQuoteOverride == 'Y' or writeQuoteOverride == 'N'}">${writeQuoteOverride}</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:set var="operator">
	<c:choose>
		<c:when test="${not empty authenticatedData.login.user.uid}">${authenticatedData.login.user.uid}</c:when>
		<c:otherwise>ONLINE</c:otherwise>
	</c:choose>
</c:set>

<sql:setDataSource dataSource="jdbc/ctm" />
<go:log source="core:transaction">START - touch:${touch}, vertical:${vertical}, noResponse:${noResponse}, writeQuoteOverride:${writeQuoteOverride}, comment:${comment}</go:log>



<%-- VALIDATE .................................................................... --%>
<%--
	TODO Should we put core:access_check in here? Seems better to incorporate here instead, because some of it is related.
	TODO Might be good to query transaction_header and validate TransactionId and ProductType
--%>
<c:set var="is_valid_touch">
	<core:validate_touch_type valid_touches="A,C,CB,CD,E,F,H,L,LF,N,P,Q,R,S,T,X" touch="${touch}" />
</c:set>
<c:choose>
	<c:when test="${is_valid_touch == false}">
		<go:log level="ERROR" source="core:transaction">Touch type is invalid or unsupported: "${touch}"</go:log>
		<c:set var="response" value="T" />
		<c:set var="write_quote" value="N" />
		<c:set var="touch" value="" /><%-- unset --%>
	</c:when>

	<c:when test="${empty vertical}">
		<go:log level="ERROR" source="core:transaction">Vertical setting can not be empty</go:log>
		<c:set var="response" value="V" />
		<c:set var="write_quote" value="N" />
		<c:set var="touch" value="" /><%-- unset --%>
	</c:when>

	<c:otherwise>
		<c:choose>
			<%-- If new quote get a fresh ID --%>
			<c:when test="${touch == 'N'}">
				<c:set var="getTransactionID" >
					<core:get_transaction_id
						quoteType="${vertical}" />
				</c:set>
			</c:when>

			<%-- Otherwise use what was passed or default to preserve --%>
			<c:otherwise>
				<c:set var="id_handler">
					<c:choose>
						<c:when test="${not empty param.id_handler}">${param.id_handler}</c:when>
						<c:otherwise>preserve_tranId</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="getTransactionID">
					<core:get_transaction_id
						quoteType="${vertical}"
						id_handler="${id_handler}"
						emailAddress="${emailAddress}" />
				</c:set>
			</c:otherwise>
		</c:choose>

		<c:set var="transactionId" value="${data.current.transactionId}" />

		<c:if test="${empty transactionId}">
			<c:set var="response" value="I" />
			<c:set var="write_quote" value="N" />
			<c:set var="touch" value="" /><%-- unset --%>
		</c:if>
	</c:otherwise>
</c:choose>

<go:log source="core:transaction" >TRANSACTION ID: ${transactionId}</go:log>

<%-- TOUCH ....................................................................... --%>
<c:choose>
	<c:when test="${empty touch}"></c:when>
	<c:otherwise>
		<c:set var="type" value="${touch}" />
		<c:if test="${touch == 'H' and not empty comment}">
			<c:set var="type" value="${fn:substring(comment, 0, 10)}" />
		</c:if>

		<sql:update var="result">
			INSERT INTO ctm.touches (transaction_id, date, time, operator_id, type)
			VALUES (?, NOW(), NOW(), ?, ?);
			<sql:param value="${transactionId}" />
			<sql:param value="${operator}" />
			<sql:param value="${type}" />
		</sql:update>

		<go:log source="core:transaction" >TOUCHED: ${touch}</go:log>

		<%-- SUBMIT FAIL: add error to comments table --%>
		<c:if test="${touch != 'H' and not empty comment}">
			<c:catch var="error">
				<c:set var="addcomment">
					<c:import url="/ajax/json/comments_add.jsp">
						<c:param name="transactionid">${transactionId}</c:param>
						<c:param name="userOverride">yes</c:param>
						<c:param name="comment">${comment}</c:param>
					</c:import>
				</c:set>
			</c:catch>
			<%-- TODO comments_add.jsp does return error json --%>
		</c:if>
	</c:otherwise>
</c:choose>



<%-- CHECK IF SAFE TO WRITE QUOTE ................................................. --%>
<c:if test="${write_quote != 'N'}">
	<%-- Does this transaction have a confirmation touch? No need to check if we've just touched with a C. --%>
	<c:if test="${touch != 'C'}">
		<sql:query var="confirmationQuery">
			SELECT COALESCE(t1.type,t2.type,1) AS editable FROM ctm.touches t0
			LEFT JOIN ctm.touches t1 ON t0.transaction_id = t1.transaction_id AND t1.type = 'C'
			LEFT JOIN ctm.touches t2 ON t0.transaction_id = t2.transaction_id AND t2.type = 'F'
			WHERE t0.transaction_id = ?
			LIMIT 1
			<sql:param value="${transactionId}" />
		</sql:query>
		<c:choose>
			<c:when test="${confirmationQuery.rowCount == 0}"></c:when>

			<%-- If transaction is Failed/Pending (F), only call centre can edit the transaction --%>
			<c:when test="${confirmationQuery.rows[0]['editable'] == 'F' and operator == 'ONLINE'}">
			<c:set var="write_quote" value="N" />
				<c:set var="response" value="F" />
				<go:log source="core:transaction" >WRITE QUOTE NO: Transaction is failed/pending.</go:log>
			</c:when>

			<c:when test="${confirmationQuery.rows[0]['editable'] == 'C'}">
				<c:set var="write_quote" value="N" />
			<c:set var="response" value="C" />
				<go:log source="core:transaction">WRITE QUOTE NO: Transaction is already confirmed.</go:log>
			</c:when>
		</c:choose>
		</c:if>
	</c:if>

<%-- Rules around whether to write quote or not --%>
<c:set var="write_quote">
	<c:choose>
		<%-- Definitely don't write --%>
		<c:when test="${write_quote == 'N'}">N</c:when>

		<%-- Definitely write --%>
		<c:when test="${write_quote == 'Y'}">Y</c:when>

		<%-- Don't write quote details for these touches --%>
		<c:when test="${touch == 'A' or touch == 'C' or touch == 'CD' or touch == 'CB' or touch == 'E' or touch == 'F' or touch == 'N' or touch == 'L' or touch == 'X'}">N</c:when>

		<%-- This is a hidden field at the end of the form:form tag. It ensures that we've collected the form contents. --%>
		<c:when test="${param.transcheck != '1'}">
			<c:out value="N" />
			<go:log source="core:transaction">WRITE QUOTE NO, transcheck form element missing (touch: ${touch})</go:log>
		</c:when>

		<c:otherwise>Y</c:otherwise>
	</c:choose>
</c:set>

<c:choose>
	<c:when test="${write_quote == 'Y'}">

		<c:set var="currentTransactionId" value="${data.current.transactionId}" />

		<%-- WRITE QUOTE ................................................................. --%>
		<c:set var="response">${response}<agg:write_quote productType="${fn:toUpperCase(vertical)}" rootPath="${vertical}" source="${comment}" /></c:set>
		<go:log source="core:transaction" >WRITE QUOTE YES</go:log>

		<c:choose>
			<c:when test="${vertical eq 'car'}">
				<go:setData dataVar="data" xpath="quote/transactionId" value="${currentTransactionId}" />
			</c:when>
			<c:otherwise>
		<go:setData dataVar="data" xpath="${vertical}/transactionId" value="${currentTransactionId}" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<go:log source="core:transaction" >WRITE QUOTE NO</go:log>
	</c:otherwise>
</c:choose>



<%-- RESPONSE .................................................................... --%>
<c:if test="${fn:length(response) > 0}">
	<%-- Log the error --%>
	<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
		<c:param name="transactionId" value="${transactionId}" />
		<c:param name="page" value="${pageContext.request.servletPath}" />
		<c:param name="message" value="core:transaction" />
		<c:param name="description" value="${response}" />
		<c:param name="data" value="vertical=${vertical} touch=${touch} writeQuoteOverride=${writeQuoteOverride} comment:${comment}" />
	</c:import>
</c:if>
<c:if test="${noResponse != 'true'}">
	<c:out value="${response}" />
</c:if>
<go:log source="core:transaction" >FINISH</go:log>
