<%@tag import="java.util.ArrayList"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core_new:no_cache_header/>

<session:get settings="true"/>

<%@ attribute name="rootPath"		required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="rankBy"			required="true"	 rtexprvalue="true"	 description="eg. price-asc, benefitsSort-asc" %>
<%@ attribute name="rankParamName"	required="false"	 rtexprvalue="true"	 description="rankParamName" %>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:set var="calcSequenceSUFF" value="/calcSequence" />
<c:set var="prefix" value="${rootPath}" />
<c:set var="calcSequence" value="${prefix}${calcSequenceSUFF}" />

<c:set var="transactionId" value="${data['current/transactionId']}" />
<c:set var="calcSequence" value="${data[calcSequence]}" />

<c:if test="${calcSequence == null}">
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

<%-- Read through the params --%>
<c:forEach var="position" begin="0" end="${param.rank_count-1}" varStatus="status">
	<c:set var="paramName" value="${rankParamName}${position}" />
	<c:set var="productId" value="${param[paramName]}"/>
		<c:if test="${not empty productId and productId != 'undefined'}">
	<sql:update>
	 	INSERT INTO aggregator.ranking_details 
				(TransactionId,CalcSequence,RankSequence,RankPosition,Property,Value)
				VALUES (?,?,?,?,'productId',?);
		<sql:param>${transactionId}</sql:param>
		<sql:param>${calcSequence}</sql:param>
		<sql:param>${rankSequence}</sql:param>
				<sql:param>${position}</sql:param>
				<sql:param>${productId}</sql:param>
	</sql:update>

			<c:if test="${pageSettings.getVerticalCode() == 'health'}">
				<health:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
			</c:if>

			<c:if test="${pageSettings.getVerticalCode() == 'travel'}">
				<travel:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
		</c:if>
		</c:if>
</c:forEach>

	<c:choose>
		<c:when test="${pageSettings.getVerticalCode() == 'health'}">
			<%-- Attempt to send email only once and only if not call centre user --%>
			<c:if test="${empty authenticatedData.login.user.uid and not empty data.health.contactDetails.email && empty data.userData.emailSent}">
				<agg:email_send brand="${pageSettings.getBrandCode()}" vertical="${pageSettings.getVerticalCode()}" email="${data.health.contactDetails.email}" mode="bestprice" tmpl="${pageSettings.getVerticalCode()}" />
			</c:if>
		</c:when>

<%-- TODO: remove this once we are off DISC --%>
		<c:when test="${pageSettings.getVerticalCode() == 'car'}">
		<go:setData dataVar="data" xpath="ranking/results" value="*DELETE" />

		<c:set var="TemplateInfo">EX</c:set>
		<go:setData dataVar="data" xpath="ranking/TemplateInfo/Prefix" value="${TemplateInfo}" />

		<c:set var="count" >0</c:set>

		<c:forEach var="position" begin="0" end="${param.rank_count-1}" varStatus="status">
			<c:set var="paramName" value="rank_productId${position}" />
			<c:set var="paramName2" value="rank_premium${position}" />
			<c:set var="productId" value="${param[paramName]}"/>
			<c:set var="premium" value="${param[paramName2]}"/>
			<c:if test="${productId != 'CURR'}">
				<go:setData dataVar="data" xpath="ranking/results/prodid${count}" value="${productId}" />
				<go:setData dataVar="data" xpath="ranking/results/prm${count}" value="${premium}" />
				<c:set var="count" value="${count + 1}" />
			</c:if>
		</c:forEach>

		<go:log level="DEBUG">Writing Ranking to DISC ${data.xml['ranking']}</go:log>

	<go:call pageId="AGGTRK" transactionId="${data.text['current/transactionId']}" xmlVar="${data.xml['ranking']}" />
		</c:when>

		<c:otherwise><%-- ignore --%></c:otherwise>
	</c:choose>
</c:if>