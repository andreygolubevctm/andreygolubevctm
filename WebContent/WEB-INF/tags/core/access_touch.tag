<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Checks the transactions access history to determine whether it is accessible"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />

<c:catch var="error">
	
	<%-- ATTRIBUTES --%>
	<%@ attribute name="quoteType" 			required="true"		description="The vertical this quote is for"%>
	<%@ attribute name="transaction_id" 	required="true"		description="The transaction id of the quote to be tracked"%>
	<%@ attribute name="type" 				required="true"		description="The type of action to be recorded against the transaction"%>
	<%@ attribute name="comment" 			required="false"	description="The comment to be added to simples"%>
	
	<go:log>access touch - transaction_id: ${transaction_id} - (${type})</go:log>
	
	<%-- VARIABLES --%>
	<c:set var="operator">
		<c:choose>
			<c:when test="${not empty data.login.user.uid}">${data.login.user.uid}</c:when>
			<c:otherwise>ONLINE</c:otherwise>
		</c:choose>
	</c:set>
	
	<sql:setDataSource dataSource="jdbc/ctm"/>
		
	<c:catch var="error">	
		<sql:update var="result">
			INSERT INTO ctm.touches (id, transaction_id, date, time, operator_id, type)
			VALUES
			(0,?,Now(),Now(),?,?);
			<sql:param value="${transaction_id}" />
			<sql:param value="${operator}" />
			<sql:param value="${type}" />
		</sql:update>
	</c:catch>
	
	<c:if test="${type eq 'F' and not empty comment}">
		<c:catch var="error">
			<c:set var="addcomment">
				<c:import url="/ajax/json/comments_add.jsp?transactionid=${transaction_id}&userOverride=yes&comment=${comment}" />
			</c:set>
		</c:catch>
	</c:if>
	
</c:catch>