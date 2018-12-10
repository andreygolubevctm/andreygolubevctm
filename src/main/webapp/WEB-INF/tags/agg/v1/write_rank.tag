<%@ tag import="com.ctm.web.core.email.model.EmailMode" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('tag.agg.write_rank')}" />

<core_v2:no_cache_header/>

<session:get settings="true"/>

<%@ attribute name="rootPath"		required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="rankBy"			required="true"	 rtexprvalue="true"	 description="eg. price-asc, benefitsSort-asc" %>
<%@ attribute name="rankParamName"	required="false"	 rtexprvalue="true"	 description="rankParamName" %>

<jsp:useBean id="fatalErrorService" class="com.ctm.web.core.services.FatalErrorService" scope="page" />

<sql:setDataSource dataSource="${datasource:getDataSource()}"/>
<c:set var="transactionId" value="${data['current/transactionId']}" />
<c:set var="calcSequenceSUFF" value="/calcSequence" />
<c:set var="prefix"><c:out value="${rootPath}" escapeXml="true"/></c:set>
<c:set var="calcSequence" value="${prefix}${calcSequenceSUFF}" />
<c:set var="calcSequence" value="${data[calcSequence]}" />

<c:if test="${empty transactionId}">
	<jsp:useBean id="fatalError" class="com.ctm.web.core.model.FatalError" scope="page" />
    ${fatalError.setStyleCodeId(pageSettings.getBrandId())}
    ${fatalError.setPage(pageContext.request.servletPath)}
    ${fatalError.setFatal("0")}
    ${fatalError.setSessionId(pageContext.session.id)}
    <%-- Set the new transaction id so we can write to the ranking tables --%>
    <c:set var="transactionId" value="${param.transactionId}" />
    <%-- If the param.transactionId is not empty, use param.transactionId --%>
    <c:if test="${not empty transactionId}">
		${fatalError.setTransactionId(param.transactionId)}
	</c:if>
	${fatalErrorService.logFatalError(fatalError)}
</c:if>

<c:if test="${empty calcSequence}">
	<%-- Current bug where by after performing a comparison the calcSequence value is lost and causes an SQL exception below --%>
	<c:set var="calcSequence" value="1" />
</c:if>

<c:if test="${param.rank_count > 0}">

	<c:set var="rankSequence">
		<sql:query var="maxSeq">
			SELECT max(RankSequence) AS prevRank
			FROM aggregator.ranking_master
			WHERE TransactionId=?
			AND CalcSequence=?
			<sql:param>${transactionId}</sql:param>
			<sql:param>${calcSequence}</sql:param>
		</sql:query>

		<c:choose>
			<c:when test="${maxSeq.rowCount != 0}">
				<c:out value="${maxSeq.rows[0].prevRank + 1}" />
			</c:when>
			<c:otherwise>0</c:otherwise>
		</c:choose>
	</c:set>

	<%-- Write the ranking master --%>
	<sql:update>
	 	INSERT INTO aggregator.ranking_master
	 	(TransactionId,CalcSequence,RankSequence,RankBy)
			values (?,?,?,?);
		<sql:param>${transactionId}</sql:param>
		<sql:param>${calcSequence}</sql:param>
			<sql:param>${rankSequence}</sql:param>
		<sql:param>${rankBy}</sql:param>
	 </sql:update>

	<c:if test="${empty rankParamName}">
		<c:set var="rankParamName" value="rank_productId"/>
	</c:if>

	<c:if test="${param.rootPath eq 'car' or param.rootPath eq 'home' or param.rootPath eq 'travel'}">
		<c:set var="rankParamPremium" value="rank_premium"/>
		<c:set var="addKnockouts" value="true"/>
	</c:if>
	<%-- Read through the params --%>
	<jsp:useBean id="insertParams" class="java.util.ArrayList" />
	<c:set var="sandbox">${insertParams.clear()}</c:set>
	<c:set var="sqlBulkInsert" value="${go:getStringBuilder()}" />
	${go:appendString(sqlBulkInsert ,'INSERT INTO aggregator.ranking_details (TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value) VALUES ')}

	<c:set var="count" value="0" />
	<c:forEach var="position" begin="0" end="${param.rank_count-1}" varStatus="status">
		<c:set var="paramName" value="${rankParamName}${position}" />
		<c:set var="productId" value="${param[paramName]}"/>
		<c:set var="paramPremium" value="${rankParamPremium}${position}" />
		<c:set var="premium" value="${param[paramPremium]}" />
		<c:if test="${addKnockouts and (empty premium or premium eq '9999999999')}">
			<c:set var="position"><c:out value="${position + 100}" /></c:set>
		</c:if>
		<c:if test="${not empty productId and productId != 'undefined'}">
			${go:appendString(sqlBulkInsert, '(')}
			${go:appendString(sqlBulkInsert, transactionId)}
			<c:set var="prefix" value=", " />
			${go:appendString(sqlBulkInsert, prefix)}
			${go:appendString(sqlBulkInsert, calcSequence)}
			${go:appendString(sqlBulkInsert, prefix)}
			${go:appendString(sqlBulkInsert, rankSequence)}
			${go:appendString(sqlBulkInsert, ", ?, 'productId', ?)")}

			<c:if test="${count ne param.rank_count-1}">
				${go:appendString(sqlBulkInsert, prefix)}
			</c:if>

			<c:set var="ignore">
				${insertParams.add(position)};
				${insertParams.add(productId)};
			</c:set>

			<c:if test="${pageSettings.getVerticalCode() == 'health'}">
				<health_v1:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
			</c:if>

			<c:if test="${pageSettings.getVerticalCode() == 'travel'}">
				<travel:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
			</c:if>

			<c:if test="${pageSettings.getVerticalCode() == 'life'}">
				<life_v1:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
			</c:if>
		</c:if>
		<c:set var="count" value="${count+1}" />
	</c:forEach>

	<%-- Don't need to insert into the ranking_details table if there are no available results --%>
	<c:if test="${not empty sqlBulkInsert}">
		<sql:update sql="${sqlBulkInsert.toString()}">
			<c:forEach var="item" items="${insertParams}">
				<sql:param value="${item}" />
			</c:forEach>
		</sql:update>
	</c:if>

	<c:if test="${pageSettings.getVerticalCode() == 'health' || pageSettings.getVerticalCode() == 'car' || pageSettings.getVerticalCode() == 'travel'}">
		<jsp:forward page="/spring/marketing-automation/sendEmail.json" />
	</c:if>



</c:if>
