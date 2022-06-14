<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="transactionId"	required="true"	 rtexprvalue="true"	 description="current transaction ID" %>
<%@ attribute name="calcSequence"	required="true"	 rtexprvalue="true"	 description="Calc Sequence from WriteRank" %>
<%@ attribute name="rankSequence"	required="true"	 rtexprvalue="true"	 description="Rank Sequence from WriteRank" %>
<%@ attribute name="rankPosition"	required="true"	 rtexprvalue="true"	 description="Rank Position from WriteRank" %>

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<c:set var="oriPrefix" value="rank_" />
<c:set var="suffixes"
	   value="lhc,rebate,price_actual,price_shown,frequency,discounted,provider,providerName,productName,productCode,premium,premiumText,healthMembership,coverLevel,healthSituation,benefitCodes,coverType,primaryCurrentPHI,hospitalPdsUrl,extrasPdsUrl,specialOffer,specialOfferTerms,premiumTotal,excessPerAdmission,excessPerPerson,excessPerPolicy,coPayment,altPremiumDate" />
<jsp:useBean id="insertParams" class="java.util.ArrayList" />
<c:set var="sandbox">${insertParams.clear()}</c:set>
<c:set var="sqlBulkInsert" value="${go:getStringBuilder()}" />
${go:appendString(sqlBulkInsert ,'INSERT INTO aggregator.ranking_details (TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value) VALUES ')}

<%-- Located expected params using the suffixes list and add to rankings_data --%>
<c:forEach var="suffix" items="${suffixes}" varStatus="status">
	<c:set var="paramName" value="${oriPrefix}${suffix}${rankPosition}" />
	<c:if test="${not empty param[paramName]}">

		<c:if test="${!status.first}">
			${go:appendString(sqlBulkInsert, prefix)}
		</c:if>

		${go:appendString(sqlBulkInsert, '(')}
		${go:appendString(sqlBulkInsert, transactionId)}
		<c:set var="prefix" value=", " />
		${go:appendString(sqlBulkInsert, prefix)}
		${go:appendString(sqlBulkInsert, calcSequence)}
		${go:appendString(sqlBulkInsert, prefix)}
		${go:appendString(sqlBulkInsert, rankSequence)}
		${go:appendString(sqlBulkInsert, ", ?, ?, ?)")}

		<c:set var="ignore">
			${insertParams.add(rankPosition)};
			${insertParams.add(suffix)};
			${insertParams.add(param[paramName])};
		</c:set>
	</c:if>
</c:forEach>

<c:if test="${not empty sqlBulkInsert}">
	<sql:update sql="${sqlBulkInsert.toString()}">
		<c:forEach var="item" items="${insertParams}">
			<sql:param value="${item}" />
		</c:forEach>
	</sql:update>
</c:if>