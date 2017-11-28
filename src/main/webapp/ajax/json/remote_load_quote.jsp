<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<session:get settings="true" verticalCode="${param.vertical}" />
<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>
<c:set var="logger" value="${log:getLogger('jsp.ajax.json.remote_load_quote')}" />

<%--
	load_quote.jsp

	Loads a previously completed quote, using the email address stored in data['current/email']
	This allows us to prevent people from being able to tamper with other peoples quotes, and this value
	can only be set by us server-side.

	@param action - Action to perform either "change" existing quote or "load" quote straight to results page


	TODO:
		- Change the program being called, or add parameter processing.
		- Add return codes/error message if it fails
		- Add code specifically to "load" to force jump to end
--%>


<%--
//REFINE:
- need to clean up go logs
- need to have better handling on DISC or MySQL based quotes
- need better handling for deleting the base xpath information (and better handling for save email etc.)
--%>

${logger.debug('LOAD QUOTE: {}', log:kv('param', param))}
<c:set var="id_for_access_check">
	<c:choose>
		<c:when test="${not empty param.id}">${param.id}</c:when>
		<c:when test="${not empty param.transactionId}">${param.transactionId}</c:when>
	</c:choose>
</c:set>

<c:set var="emailHash">
	<c:choose>
		<c:when test="${not empty param.hash}">${param.hash}</c:when>
	</c:choose>
</c:set>

<c:set var="quoteType" value="${fn:toLowerCase(param.vertical)}" />
<c:set var="loadAction" value="${fn:toLowerCase(param.action)}" />
<c:set var="loadType" value="${fn:toLowerCase(param.type)}" />

<c:set var="forcedBrandCode">
	<c:choose>
		<c:when test="${not empty param.brandCode}">${param.brandCode}</c:when>
	</c:choose>
</c:set>

<c:set var="xpathQuoteType">
	<c:choose>
		<c:when test="${quoteType eq 'car'}">quote</c:when>
		<c:otherwise>${quoteType}</c:otherwise>
	</c:choose>
</c:set>

<%-- First check owner of the quote --%>
<c:set var="proceedinator"><core_v1:access_check quoteType="${quoteType}" tranid="${id_for_access_check}" /></c:set>
<c:choose>
	<c:when test="${not empty proceedinator and proceedinator > 0}">
		${logger.info('PROCEEDINATOR PASSED. {},{}',log:kv('quoteType', quoteType),log:kv('transactionId',id_for_access_check))}
		<c:set var="requestedTransaction" value="${id_for_access_check}" />

		<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

				<%-- 30/1/13: Increment TranID when 'ANYONE' opens a quote --%>
				<c:set var="id_handler" value="increment_tranId" />
				<c:if test="${loadAction eq 'confirmation'}">
					<c:set var="id_handler" value="preserve_tranId" />
				</c:if>

				<c:set var="sandpit">
					<core_v1:get_transaction_id quoteType="${quoteType}" id_handler="${id_handler}" transactionId="${requestedTransaction}"/>
				</c:set>

		<go:setData dataVar="data" xpath="previous/transactionId" value="${requestedTransaction}" />
		${logger.info('Transaction Id has been updated. {},{}', log:kv('requestedTransaction',requestedTransaction ) ,log:kv('transactionId', data.current.transactionId))}
		<%-- Now we get back to basics and load the data for the requested transaction --%>
		<jsp:useBean id="remoteLoadQuoteService" class="com.ctm.web.core.services.RemoteLoadQuoteService" scope="page" />

		<c:catch var="error">
			<c:set var="details" value="${remoteLoadQuoteService.getTransactionDetails(emailHash, quoteType, loadType, param.email, requestedTransaction, styleCodeId)}" />
		</c:catch>

		<c:choose>
			<c:when test="${not empty error}">
				${logger.error("Failed to get transaction details. {},{},{},{}", log:kv('quoteType',param.vertical), log:kv('param.type',param.type), log:kv('param.email',param.email), log:kv('styleCodeId',styleCodeId ), error)}
				<c:set var="result"><result><error>Error loading quote data: ${error.rootCause}</error></result></c:set>
			</c:when>
			<c:when test="${empty details}">
						<c:set var="result"><result><error>No transaction data exists for transaction [${requestedTransaction}] and hash [${emailHash}] combination.</error></result></c:set>
			</c:when>
			<c:otherwise>
				${logger.debug('About to delete the vertical information. {},{}', log:kv('quoteType',quoteType ), log:kv('requestedTransaction',requestedTransaction ))}
				<%-- //FIX: need to delete the bucket of information here --%>
				<go:setData dataVar="data" value="*DELETE" xpath="${xpathQuoteType}" />

				<c:forEach var="detail" items="${details}" varStatus="status">
							<c:set var="textVal">
						<c:if test="${!fn:contains(detail.getTextValue(),'Please choose')}">${detail.getTextValue()}</c:if>
							</c:set>
					<go:setData dataVar="data" xpath="${detail.getXPath()}" value="${textVal}" />
				</c:forEach>
				<%-- Set the current transaction id to the one passed so it is set as the prev tranId--%>
				${logger.debug('Setting data.current.transactionId back to requestedTransaction. {},{}', log:kv('requestedTransaction', requestedTransaction), log:kv('privacyoptin',data[xpathQuoteType].privacyoptin ))}
				<%-- Add CampaignId to the databucket if provided --%>
				<c:if test="${not empty param.campaignId}">
					<go:setData dataVar="data" xpath="${xpathQuoteType}/tracking/cid" value="${param.campaignId}" />
				</c:if>

				<c:set var="vQuotetype">
					<c:choose>
						<c:when test="${quoteType eq 'car'}">
							quote
						</c:when>
						<c:otherwise>${quoteType}</c:otherwise>
					</c:choose>
				</c:set>
				<c:set var="jParam">
					<c:if test="${not empty data[vQuotetype]['currentJourney']}">
						&amp;j=${data[vQuotetype]['currentJourney']}
					</c:if>
				</c:set>
				<c:set var="trackingParams">
					<c:if test="${not empty param.cid and not empty param.etRid and not empty param.utmSource and not empty param.utmMedium and not empty param.utmCampaign}">
						&amp;cid=${param.cid}&amp;et_rid=${param.etRid}&amp;utm_source=${param.utmSource}&amp;utm_medium=${param.utmMedium}&amp;utm_campaign=${param.utmCampaign}
					</c:if>
				</c:set>

				<c:set var="productCode">
					<c:if test="${not empty param.productCode}">&amp;productCode=<c:out value="${param.productCode}" escapeXml="false"/></c:if>
				</c:set>

				<c:set var="result">
					<result>
						<c:choose>

							<%-- GET HEALTH RESULTS --%>
							<c:when test="${loadAction eq 'load' and quoteType eq 'health'}">
								<go:setData dataVar="data" xpath="userData/emailSent" value="true" />
								<core_v1:transaction touch="L" noResponse="true" />
								<c:choose>
									<c:when test="${not empty param.productId and param.productId != '' and not empty param.productTitle and param.productTitle != ''}">
										<destUrl>${quoteType}_quote.jsp?action=load&amp;transactionId=${param.transactionId}&amp;productId=${param.productId}&amp;productTitle=${param.productTitle}${jParam}${productCode}</destUrl>
									</c:when>
									<c:otherwise>
										<destUrl>${quoteType}_quote.jsp?action=load&amp;transactionId=${param.transactionId}${jParam}${trackingParams}${productCode}</destUrl>
									</c:otherwise>
								</c:choose>
							</c:when>

						<%-- AMEND QUOTE --%>
						<c:when test="${(loadAction eq 'amend' || loadAction eq 'start-again') and (forcedBrandCode eq 'wfdd')}">
								<destUrl>${remoteLoadQuoteService.getActionQuoteUrlForcedBrandCode(quoteType, loadAction, data.current.transactionId, jParam, trackingParams, forcedBrandCode)}</destUrl>
						</c:when>

						<%-- AMEND QUOTE --%>
						<c:when test="${loadAction eq 'amend' || loadAction eq 'start-again'}">
						        <destUrl>${remoteLoadQuoteService.getActionQuoteUrl(quoteType, loadAction, data.current.transactionId, jParam, trackingParams)}</destUrl>
						</c:when>

						<%-- BACK TO START IF PRIVACYOPTIN HASN'T BEEN TICKED FOR OLD QUOTES --%>
						<c:when test="${loadType ne 'promotion' && loadType ne 'bestprice' && (loadAction eq 'latest' || loadAction eq 'load') && data[xpathQuoteType].privacyoptin!='Y'}">
							<destUrl>${remoteLoadQuoteService.getStartAgainQuoteUrl(quoteType,data.current.transactionId,jParam, trackingParams)}</destUrl>
						</c:when>

							<%-- GET TRAVEL MULTI-TRIP --%>
							<c:when test="${(loadAction eq 'latest' || loadAction eq 'load') && quoteType eq 'travel' && loadType eq 'a'}">
								<c:if test="${not empty param.newDate and param.newDate != ''}">
									<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
								</c:if>

								<core_v1:transaction touch="L" noResponse="true" />
								<destUrl>travel_quote.jsp?type=A&amp;action=latest&amp;transactionId=${data.current.transactionId}${jParam}${trackingParams}</destUrl>
								<go:setData dataVar="data" value="true" xpath="userData/emailSent"/>
						</c:when>

							<%-- EXPIRED COMMENCEMENT DATE --%>
							<c:when test="${loadAction eq 'load' && not empty param.expired}">
								<c:set var="fieldXPath" value="" />
								<c:choose>
									<c:when test="${xpathQuoteType eq 'quote'}">
										<c:set var="fieldXPath" value="${xpathQuoteType}/options/commencementDate" />
									</c:when>
									<c:when test="${xpathQuoteType eq 'home'}">
										<c:set var="fieldXPath" value="${xpathQuoteType}/startDate" />
									</c:when>
								</c:choose>
								<c:if test="${not empty fieldXPath}">
									<go:setData dataVar="data" xpath="${fieldXPath}" value="${param.expired}" />
								</c:if>
								<core_v1:transaction touch="L" noResponse="true" />
								<c:set var="quotePagePrefix" value="${quoteType}">
								</c:set>
								<c:set var="action">
								<c:choose>
										<c:when test="${loadType eq 'promotion'}">${loadType}</c:when>
										<c:otherwise>expired</c:otherwise>
								</c:choose>
								</c:set>
								<c:set var="allParams">${jParam}${trackingParams}</c:set>
								<destUrl>${remoteLoadQuoteService.getActionQuoteUrl(quotePagePrefix,action,data.current.transactionId,allParams, trackingParams)}</destUrl>
							</c:when>

							<%-- GET LATEST --%>
							<c:when test="${loadAction eq 'latest' || loadAction eq 'load'}">
								<c:if test="${not empty param.newDate and param.newDate != ''}">
									<go:setData dataVar="data" xpath="quote/options/commencementDate" value="${param.newDate}" />
								</c:if>

								<core_v1:transaction touch="L" noResponse="true" />
								<destUrl>${remoteLoadQuoteService.getLatestQuoteUrl(quoteType, data.current.transactionId,jParam, trackingParams)}</destUrl>
								<%-- Have only made this happen for travel --%>
								<c:if test="${quoteType eq 'travel'}">
									<go:setData dataVar="data" value="true" xpath="userData/emailSent"/>
								</c:if>
						</c:when>

						<%-- GET CONFIRMATION --%>
						<c:when test="${loadAction eq 'confirmation'}">
							<destUrl>no url required for confirmation loading</destUrl>
						</c:when>

						<%-- ERROR --%>
						<c:otherwise>
							<error>INVALID_ACTION</error>
						</c:otherwise>
						</c:choose>
					</result>
				</c:set>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		${logger.warn('Proceedinator did not pass. {}', log:kv('proceedinator',proceedinator))}
		<c:set var="result">
			<result><error>This quote has been reserved by another user. Please try again later.</error></result>
		</c:set>
	</c:otherwise>
</c:choose>
${logger.debug('End Load Quote. {}', log:kv('result',result))}
<%-- Return the results as json --%>
${go:XMLtoJSON(result)}