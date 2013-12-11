<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="now" class="java.util.Date" scope="request" />

<%@ attribute name="productType" 	required="true"	 rtexprvalue="true"	 description="The product type (e.g. TRAVEL)" %>
<%@ attribute name="rootPath" 	required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="triggeredsave" 			required="false" rtexprvalue="true"	 description="If not empty will insert sticky data into the transaction details" %>
<%@ attribute name="triggeredsavereason"	required="false" rtexprvalue="true"	 description="Optional reason for triggeredsave" %>

<c:choose>
	<c:when test="${rootPath eq 'car'}">
		<c:set var="rootPathData">quote</c:set>
	</c:when>
	<c:otherwise>
<c:set var="rootPathData">${rootPath}</c:set>
	</c:otherwise>
</c:choose>

<security:populateDataFromParams rootPath="save" />
<security:populateDataFromParams rootPath="saved" />

<sql:setDataSource dataSource="jdbc/aggregator"/>
<c:set var="brand" value="CTM" />
<c:set var="source" value="QUOTE" />

<c:set var="outcome"><core:get_transaction_id quoteType="${rootPath}" id_handler="preserve_tranId" /></c:set>
<c:set var="transactionId" value="${data.current.transactionId}" />

<c:set var="operator">
	<c:choose>
		<c:when test="${not empty data.login.user.uid}">${data.login.user.uid}</c:when>
		<c:otherwise>ONLINE</c:otherwise>
	</c:choose>
</c:set>

<c:set var="optinParam" value="${rootPath}_callmeback_optin" /><%-- callmeback_save_phone --%>
<c:if test="${not empty param[optinParam] and param[optinParam] eq 'Y'}">
	<c:set var="optinPhone" value=",okToCall=${param[optinParam]}" />
</c:if>
<%-- Capture the essential fields to update email table --%>
<c:choose>
	<c:when test="${fn:contains(param.quoteType, 'reminder')}">
		<c:set var="firstName" value="${data['reminder/firstName']}" />
		<c:set var="lastName" value="${data['reminder/lastName']}" />
		<c:set var="lastName" value="${data['reminder/lastName']}" />
		<c:set var="optinPhone" value="" />
		<c:set var="optinMarketing">
			<c:choose>
				<c:when test="${empty data['reminder/marketing']}">marketing=N</c:when>
				<c:otherwise>marketing=${data['reminder/marketing']}</c:otherwise>
			</c:choose>
		</c:set>
	</c:when>
	<c:when test="${rootPath eq 'car'}">
		<c:set var="emailAddress" value="${data['quote/contact/email']}" />
		<c:set var="firstName" value="${data['quote/drivers/regular/firstname']}" />
		<c:set var="lastName" value="${data['quote/drivers/regular/surname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['quote/contact/oktocall']}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${data['quote/contact/marketing']}">marketing=N</c:when>
					<c:otherwise>marketing=${data['quote/contact/marketing']}</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'utilities'}">
		<c:set var="emailAddress">
			<c:choose>
				<c:when test="${not empty data['utilities/application/details/email']}">${data['utilities/application/details/email']}</c:when>
				<c:otherwise>${data['utilities/resultsDisplayed/email']}</c:otherwise>
			</c:choose>
		</c:set>
		<c:set var="firstName" value="${data['utilities/application/details/firstName']}" />
		<c:set var="lastName" value="${data['utilities/application/details/lastName']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value="" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${empty data['utilities/application/thingsToKnow/receiveInfo']}">marketing=N</c:when>
					<c:otherwise>marketing=${data['utilities/application/thingsToKnow/receiveInfo']}</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'life'}">
		<c:set var="emailAddress" value="${data['life/contactDetails/email']}" />
		<c:set var="firstName" value="${data['life/primary/firstName']}" />
		<c:set var="lastName" value="${data['life/primary/lastname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['life/contactDetails/call']}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${empty data['life/contactDetails/optIn']}">marketing=N</c:when>
					<c:otherwise>marketing=${data['life/contactDetails/optIn']}</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'ip'}">
		<c:set var="emailAddress" value="${data['ip/contactDetails/email']}" />
		<c:set var="firstName" value="${data['ip/primary/firstName']}" />
		<c:set var="lastName" value="${data['ip/primary/lastname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value=",okToCall=${data['ip/contactDetails/call']}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${data['ip/contactDetails/optIn']}">marketing=N</c:when>
					<c:otherwise>marketing=${data['ip/contactDetails/optIn']}</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'health'}">
		<c:set var="emailAddress">
			<c:choose>
				<c:when test="${not empty data['health/contactDetails/email']}">${data['health/contactDetails/email']}</c:when>
				<c:otherwise>${data['health/application/email']}</c:otherwise>
			</c:choose>
		</c:set>
		<c:set var="firstName" value="${data['health/contactDetails/firstName']}" />
		<c:set var="lastName" value="${data['health/contactDetails/lastname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone">
				<c:choose>
					<c:when test="${not empty data['health/contactDetails/call']}">${data['health/contactDetails/call']}</c:when>
					<c:otherwise><c:out value="N" /></c:otherwise>
				</c:choose>
			</c:set>
			<c:set var="optinPhone" value=",okToCall=${optinPhone}" />
		</c:if>
		<c:if test="${empty optinMarketing}">
			<c:set var="optinMarketing">
				<c:choose>
					<c:when test="${empty data['health/application/optInEmail']}">marketing=N</c:when>
					<c:otherwise>marketing=${data['health/application/optInEmail']}</c:otherwise>
				</c:choose>
			</c:set>
		</c:if>
	</c:when>
	<c:when test="${rootPath eq 'travel'}">
		<c:set var="emailAddress" value="${data['travel/email']}" />
		<c:set var="firstName" value="${data['travel/firstName']}" />
		<c:set var="lastName" value="${data['travel/surname']}" />
		<c:if test="${empty optinPhone}">
			<c:set var="optinPhone" value="" />
		</c:if>
		<c:set var="optinMarketing">
			<c:choose>
				<c:when test="${data['travel/marketing']}">marketing=N</c:when>
				<c:otherwise>marketing=${data['travel/marketing']}</c:otherwise>
			</c:choose>
		</c:set>
	</c:when>
	<c:otherwise>
		<c:set var="firstName" value="" />
		<c:set var="lastName" value="" />
		<c:set var="optinPhone" value="" />
		<c:set var="optinMarketing" value="" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${not empty data['save/email']}">
		<c:set var="emailAddressHeader" value="${data['save/email']}" />
		<c:set var="emailAddress" value="${data['save/email']}" />
		<%-- Save form optin overrides the questionset  --%>
		<c:if test="${not empty data['save/marketing'] && data['save/marketing'] == 'Y'}">
			<c:set var="optinMarketing" value="marketing=Y" />
		</c:if>
	</c:when>
	<c:when test="${not empty data['saved/email']}">
		<c:set var="emailAddressHeader" value="${data['saved/email']}" />
		<%-- Save form optin overrides the questionset  --%>
		<c:if test="${(not empty data['saved/marketing']) && (data['saved/marketing'] == 'Y') && (data['saved/email'] == emailAddress)}">
			<c:set var="optinMarketing" value="marketing=Y" />
		</c:if>
	</c:when>
	<c:otherwise>
		<c:set var="emailAddressHeader" value="${emailAddress}" />
	</c:otherwise>
</c:choose>

<%--Don't override if already opted in--%>
<c:if test="${not empty data['userData/optInMarketing'] and data['userData/optInMarketing'] and (data['userData/emailAddress'] == emailAddress)}">
	<c:if test="">
		<c:set var="optinMarketing" value="marketing=Y" />
	</c:if>
</c:if>

<%-- Check if transaction is confirmed or pending --%>
<sql:query var="confirmationQuery">
	SELECT COALESCE(t1.type,t2.type,1) AS editable FROM ctm.touches t0
	LEFT JOIN ctm.touches t1 ON t0.transaction_id = t1.transaction_id AND t1.type = 'C'
	LEFT JOIN ctm.touches t2 ON t0.transaction_id = t2.transaction_id AND t2.type = 'F'
	WHERE t0.transaction_id = ?
	LIMIT 1
	<sql:param value="${transactionId}" />
</sql:query>
<%-- confirmationResult will be empty string if safe to write to --%>
<c:set var="confirmationResult">
	<c:choose>
		<c:when test="${confirmationQuery.rowCount == 0}"></c:when>
		<%-- If transaction is Failed/Pending (F), only call centre can edit the transaction --%>
		<c:when test="${confirmationQuery.rows[0]['editable'] == 'F' and operator != 'ONLINE'}"></c:when>
		<c:when test="${confirmationQuery.rows[0]['editable'] == 'C'}">C</c:when>
	</c:choose>
</c:set>

<c:if test="${confirmationResult == '' && not empty emailAddress}">
	<%-- Add/Update the user record in email_master --%>
	<c:catch var="error">
		<agg:write_email
			brand="${brand}"
			vertical="${rootPath}"
			source="${source}"
			emailAddress="${emailAddress}"
			firstName="${firstName}"
			lastName="${lastName}"
			items="${optinMarketing}${optinPhone}" />
	</c:catch>
</c:if>
<c:if test="${confirmationResult == '' && not empty emailAddressHeader}">
	<%-- Update the transaction header record with the user current email address --%>
	<c:catch var="error">
		<sql:update var="result">
			UPDATE aggregator.transaction_header
			SET EmailAddress = ?
			WHERE TransactionId = ?;
			<sql:param value="${emailAddressHeader}" />
			<sql:param value="${transactionId}" />
		</sql:update>
	</c:catch>
</c:if>
<%-- Test for DB issue and handle - otherwise move on --%>
<c:if test="${not empty error}">
	<c:if test="${not empty errorPool}">
		<c:set var="errorPool">${errorPool},</c:set>
	</c:if>
	<go:log>    Failed to update transaction_header: ${error.rootCause}</go:log>
	<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
		<c:param name="property" value="CTM" />
		<c:param name="page" value="${pageContext.request.servletPath}" />
		<c:param name="message" value="agg:write_quote optin/email" />
		<c:param name="description" value="${error}" />
		<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
	</c:import>
	<c:set var="errorPool">${errorPool}{"error":"A fatal database error occurred - we hope to resolve this soon."}</c:set>
</c:if>

<c:choose>
<%-- Do not write quote if this quote is already confirmed/finished --%>
	<c:when test="${confirmationResult == '' && transactionId.matches('^[0-9]+$') }">
		<c:catch var="error">
			<sql:transaction>
				<jsp:useBean id="insertParams" class="java.util.ArrayList" scope="request" />
				<c:set var="sandbox">${insertParams.clear()}</c:set>
				<c:set var="insertSQLSB" value="${go:getStringBuilder()}" />
				${go:appendString(insertSQLSB ,'INSERT INTO aggregator.transaction_details (transactionId,sequenceNo,xpath,textValue,numericValue,dateValue) VALUES ')}

				<%-- Add sticky content to transaction details for triggered saves (Kampyle, SessionPop or FatalError) --%>
				<c:if test="${not empty param.triggeredsave or not empty triggeredsave}">
					<c:choose>
						<c:when test="${not empty triggeredsave}"><c:set var="trigger" value="${triggeredsave}" /></c:when>
						<c:otherwise><c:set var="trigger" value="${param.triggeredsave}" /></c:otherwise>
					</c:choose>
					<c:choose>
						<c:when test="${not empty triggeredsavereason}"><c:set var="triggerreason" value="${triggeredsavereason}" /></c:when>
						<c:when test="${not empty param.triggeredsavereason}"><c:set var="triggerreason" value="${param.triggeredsavereason}" /></c:when>
					</c:choose>
					<c:set var="useragent" value="${header['User-Agent']}" scope="session"/>
					<c:if test="${not empty data[rootPathData].pendingID}">
						<c:set var="pendingID" value="${data[rootPathData].pendingID}" />
						<go:setData dataVar="data" xpath="${rootPathData}/pendingID" value="*DELETE" />
					</c:if>

					<%--
						-1 is reserved for confirmationCode/confirmationEmailCode
						-2 is reserved for policyNo
					--%>
					<c:if test="${not empty param.stage}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-3</sql:param>
							<sql:param>stage</sql:param>
							<sql:param>${param.stage}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty useragent}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-4</sql:param>
							<sql:param>useragent</sql:param>
							<sql:param>${useragent}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty trigger}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-5</sql:param>
							<sql:param>${trigger}</sql:param>
							<sql:param>${now}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty triggerreason}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-6</sql:param>
							<sql:param>fatalerrorreason</sql:param>
							<sql:param>${triggerreason}</sql:param>
						</sql:update>
					</c:if>
					<c:if test="${not empty pendingID}">
						<sql:update>
							INSERT INTO aggregator.transaction_details
							(transactionId,sequenceNo,xpath,textValue,numericValue,dateValue)
							VALUES (?, ?, ?, ?, default, NOW())
							ON DUPLICATE KEY UPDATE xpath = VALUES(xpath), textValue = VALUES(textValue), dateValue=VALUES(dateValue);
							<sql:param>${transactionId}</sql:param>
							<sql:param>-7</sql:param>
							<sql:param>pendingID</sql:param>
							<sql:param>${pendingID}</sql:param>
						</sql:update>
				</c:if>
				</c:if>
				<%-- END STICKY CONTENT --%>

				<c:import url="/WEB-INF/xslt/toxpaths.xsl" var="toXpathXSL" />
				<c:set var="dataXpaths">
					<x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data[rootPathData])}"/>
					<c:if test="${data['save'].size() > 0}"><x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data['save'])}"/></c:if>
					<c:if test="${data['saved'].size() > 0}"><x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data['saved'])}"/></c:if>
					<c:if test="${data['reminder'].size() > 0}"><x:transform xslt="${toXpathXSL}" xml="${go:getEscapedXml(data['reminder'])}"/></c:if>
				</c:set>

				<c:set var="counter" value="0" />
				<c:forEach items="${dataXpaths.split('#~#')}" var="xpathAndVal" varStatus="status" >
					<c:set var="xpath" value="${fn:substringBefore(xpathAndVal,'=')}" />
					<c:set var="xpath" value="${fn:substringAfter(xpath,'/')}" />
					<c:set var="rowVal" value="${fn:substringAfter(xpathAndVal,'=')}" />
					<c:set var="rowVal" value="${go:unescapeXml(rowVal)}" />
	<%--FIXME: Need to be reviewed and replaced with something nicer --%>
	<c:choose>
						<c:when test="${empty rowVal}"></c:when>
						<c:when test="${fn:contains(xpath,'credit/ccv')}"></c:when>
	<c:when test="${fn:contains(xpath,'credit/number')}"></c:when>
						<%-- //FIX: there should be no Please choose value for a blank item - need to see where that can come from... --%>
						<c:when test="${fn:startsWith(rowVal, 'Please choose')}"></c:when>
						<c:when test="${fn:startsWith(rowVal, 'ignoreme')}"></c:when>
	<c:when test="${fn:contains(xpath,'bank/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'claim/number')}"></c:when>
	<c:when test="${fn:contains(xpath,'payment/details/type')}"></c:when>
	<c:when test="${xpath=='/operatorid'}"></c:when>
						<c:when test="${fn:contains(rootPath,'frontend') and fn:contains(item.value,'json')}"></c:when>
						<c:when test="${fn:contains(xpath,'password')}"></c:when>
						<c:when test="${fn:contains(rootPath,'frontend') and xpath == '/'}"></c:when>
						<c:when test="${fn:contains(rootPath,'frontend') and fn:contains(xpath,'sendConfirm')}"></c:when>
	<c:otherwise>
							<c:set var="counter" value="${counter + 1}" />
							${go:appendString(insertSQLSB ,prefix)}
							<c:set var="prefix" value="," />
							${go:appendString(insertSQLSB , '(')}
							${go:appendString(insertSQLSB , transactionId)}
							${go:appendString(insertSQLSB , ', ?, ?, ?, default, Now()) ')}
							<c:set var="ignore">
								${insertParams.add(counter)};
								${insertParams.add(xpath)};
								${insertParams.add(rowVal)};
							</c:set>
	</c:otherwise>
	</c:choose>
</c:forEach>
<c:if test="${not empty data['login/user/uid']}">
					<c:set var="operatorIdXpath" value="${rootPath}/operatorId" />
					${go:appendString(insertSQLSB ,prefix)}
					${go:appendString(insertSQLSB , '(')}
					${go:appendString(insertSQLSB , transactionId)}
					${go:appendString(insertSQLSB , ', ?, ?, ?, default, Now()) ')}
					<c:set var="counter" value="${counter + 1}" />
					<c:set var="ignore">
						${insertParams.add(counter)};
						${insertParams.add(operatorIdXpath)};
						${insertParams.add(data.login.user.uid)};
					</c:set>
				</c:if>
				${go:appendString(insertSQLSB ,'ON DUPLICATE KEY UPDATE xpath=VALUES(xpath), textValue=VALUES(textValue), dateValue=VALUES(dateValue); ')}
				<%--
					300 and up is the range for custom entered data that doesn't come from params
				--%>
				<c:if test="${insertParams.size() > 0}">
					<sql:update sql="${insertSQLSB.toString()}">
						<c:forEach var="item" items="${insertParams}">
							<sql:param value="${item}" />
						</c:forEach>
					</sql:update>
	<sql:update>
						DELETE FROM aggregator.transaction_details
						WHERE transactionId = ${transactionId}
							AND sequenceNo > ${counter}
							AND sequenceNo < 300;
	</sql:update>
				</c:if>
			</sql:transaction>
		</c:catch>
		<c:if test="${not empty error}">
			<go:log>***** WRITE_QUOTE FAILED ${error}</go:log>
			<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
				<c:param name="property" value="CTM" />
				<c:param name="page" value="${pageContext.request.servletPath}" />
				<c:param name="message" value="agg:write_quote insert transaction details" />
				<c:param name="description" value="${error}" />
				<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
			</c:import>
			FAILED: A fatal database error occurred - we hope to resolve this soon.
		</c:if>

		<%--TODO: remove this once we are off disc --%>
		<%-- Set data from the form and call AGGTIC to write the client data to tables --%>
		<%-- Note, we do not wait for it to return - this is a "fire and forget" request --%>
		<c:if test="${rootPath == 'car'}">
			<go:log>Writing quote to DISC</go:log>
			<go:log>${go:getEscapedXml(data['quote'])}</go:log>
			<go:call pageId="AGGTIC"
				xmlVar="${go:getEscapedXml(data['quote'])}"
				transactionId="${transactionId}"
				mode="P"
				wait="FALSE"
				style="CTM"
				/>
		</c:if>
	</c:when>
	<c:when test="${empty transactionId}">
		<go:log>write_quote: No transaction ID.</go:log>
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="property" value="CTM" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="agg:write_quote confirmationResult" />
			<c:param name="description" value="No transaction ID." />
			<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
		</c:import>
		FAILED: No transaction ID.
	</c:when>
	<c:when test="${confirmationResult == 'F'}">
		<go:log>write_quote: No because pending/failed</go:log>
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="property" value="CTM" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="agg:write_quote confirmationResult" />
			<c:param name="description" value="Quote is pending/failed and operator=ONLINE" />
			<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
		</c:import>
		FAILED: Quote is pending/failed and operator=ONLINE.
	</c:when>
	<c:otherwise>
		<go:log>write_quote: No because this quote is already confirmed.</go:log>
		<c:import var="fatal_error" url="/ajax/write/register_fatal_error.jsp">
			<c:param name="property" value="CTM" />
			<c:param name="page" value="${pageContext.request.servletPath}" />
			<c:param name="message" value="agg:write_quote confirmationResult" />
			<c:param name="description" value="This quote is confirmed." />
			<c:param name="data" value="transactionId=${transactionId} productType=${productType} rootPath=${rootPath}" />
		</c:import>
		FAILED: This quote is confirmed.
	</c:otherwise>
</c:choose>