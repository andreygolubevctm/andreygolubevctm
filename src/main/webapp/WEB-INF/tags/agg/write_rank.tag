<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Write client details to the client database"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('tag:agg.write_rank')}" />

<core_new:no_cache_header/>

<session:get settings="true"/>

<%@ attribute name="rootPath"		required="true"	 rtexprvalue="true"	 description="root Path like (e.g. travel)" %>
<%@ attribute name="rankBy"			required="true"	 rtexprvalue="true"	 description="eg. price-asc, benefitsSort-asc" %>
<%@ attribute name="rankParamName"	required="false"	 rtexprvalue="true"	 description="rankParamName" %>

<jsp:useBean id="fatalErrorService" class="com.ctm.services.FatalErrorService" scope="page" />


	<sql:setDataSource dataSource="jdbc/ctm"/>
<c:set var="transactionId" value="${data['current/transactionId']}" />
<c:set var="calcSequenceSUFF" value="/calcSequence" />
<c:set var="prefix"><c:out value="${rootPath}" escapeXml="true"/></c:set>
<c:set var="calcSequence" value="${prefix}${calcSequenceSUFF}" />


<c:set var="calcSequence" value="${data[calcSequence]}" />

<c:if test="${empty transactionId}">
	<%-- If the transactionId is empty, revert back to the param.transactionId otherwise it fails to write to the fatal_error_log table --%>
	${fatalErrorService.logFatalError(0,  pageSettings.getBrandId(), pageContext.request.servletPath , pageContext.session.id, false, transactionId)}

	<%-- Set the new transaction id so we can write to the ranking tables --%>
	<c:set var="transactionId" value="${transactionId}" />
</c:if>

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
				<health:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
			</c:if>

			<c:if test="${pageSettings.getVerticalCode() == 'travel'}">
				<travel:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
		</c:if>

				<c:if test="${pageSettings.getVerticalCode() == 'life'}">
					<life:write_rank_extra calcSequence="${calcSequence}" rankPosition="${position}" rankSequence="${rankSequence}" transactionId="${transactionId}" />
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

<jsp:useBean id="emailService" class="com.ctm.services.email.EmailService" scope="page" />
	<c:choose>
		<c:when test="${pageSettings.getVerticalCode() == 'travel'}">
			<%-- Attempt to send email only after best price has been set and only if not call centre user --%>
			<c:if test="${empty authenticatedData.login.user.uid and not empty data.travel.email && empty data.userData.emailSent}">

					<%-- enums are not will handled in jsp --%>
				<% request.setAttribute("BEST_PRICE", com.ctm.model.email.EmailMode.BEST_PRICE); %>
				<c:catch var="error">
					${emailService.send(pageContext.request, BEST_PRICE , data.travel.email, transactionId)}
				</c:catch>
				<go:setData dataVar="data" value="true" xpath="userData/emailSent"/>
				<%--
				This will either be a RuntimeException or SendEmailException
				If this fails it is not a show stopper so log and keep calm and carry on
				--%>
				<c:if test="${not empty error}">
					${logger.error('Failed to send best price for {},{}',log:kv('transactionId',transactionId ), log:kv('data.travel.email',data.travel.email ), error)}
					${fatalErrorService.logFatalError(error, pageSettings.getBrandId(), pageContext.request.servletPath , pageContext.session.id, false, transactionId)}
				</c:if>
				</c:if>
			</c:when>
		<c:when test="${pageSettings.getVerticalCode() == 'health'}">
			<%-- Attempt to send email only once and only if not call centre user --%>
			<c:if test="${empty authenticatedData.login.user.uid and not empty data.health.contactDetails.email && empty data.userData.emailSent}">
				<%-- <jsp:useBean id="emailService" class="com.ctm.services.email.EmailService" scope="page" />--%>
				<%-- enums are not will handled in jsp --%>
				<% request.setAttribute("BEST_PRICE", com.ctm.model.email.EmailMode.BEST_PRICE); %>
				<c:catch var="error">
					${emailService.send(pageContext.request, BEST_PRICE , data.health.contactDetails.email, transactionId)}
				</c:catch>
				<go:setData dataVar="data" value="true" xpath="userData/emailSent"/>
				<%--
				This will either be a RuntimeException or SendEmailException
				If this fails it is not a show stopper so log and keep calm and carry on
				--%>
				<c:if test="${not empty error}">
					${fatalErrorService.logFatalError(error, pageSettings.getBrandId(), pageContext.request.servletPath , pageContext.session.id, false, transactionId)}
				</c:if>
			</c:if>
		</c:when>
		<c:when test="${pageSettings.getVerticalCode() == 'home'}">
			<%-- Attempt to send email only once and only if not call centre user MUST BE AT LEAST 5 products --%>
				<c:if test="${empty authenticatedData.login.user.uid and not empty data.home.policyHolder.email && empty data.userData.emailSent}">
				<agg:email_send brand="${pageSettings.getBrandCode()}" vertical="${pageSettings.getVerticalCode()}" email="${data.home.policyHolder.email}" mode="bestprice" tmpl="${pageSettings.getVerticalCode()}" />
			</c:if>
		</c:when>
		<c:when test="${pageSettings.getVerticalCode() == 'car'}">
			<%-- Attempt to send email only once and only if not call centre user MUST BE AT LEAST 5 products --%>
				<c:if test="${empty authenticatedData.login.user.uid and not empty data.quote.contact.email && empty data.userData.emailSent}">
				<agg:email_send brand="${pageSettings.getBrandCode()}" vertical="${pageSettings.getVerticalCode()}" email="${data.quote.contact.email}" mode="bestprice" tmpl="${pageSettings.getVerticalCode()}" />
			</c:if>

			<%-- THIS IS ALL DISC STUFF AND WILL NEED REMOVING --%>

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

		</c:when>

		<c:otherwise><%-- ignore --%></c:otherwise>
	</c:choose>
</c:if>