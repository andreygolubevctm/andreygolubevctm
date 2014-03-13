<%@ tag description="Load the application settings"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="vertical" 	required="false"  rtexprvalue="true"	 description="Whether to load the logging or not" %>

<%-- Page settings --%>
<jsp:useBean id="pageSettings" class="com.disc_au.web.go.Data" scope="request" />

<go:setData dataVar="pageSettings" xpath="vertical" value="${vertical}" />
<go:setData dataVar="pageSettings" xpath="brand" value="ctm" />

<%-- @todo = get rid of first line, uncomment second line when core_new:load_application_settings is complete --%>
<go:setData dataVar="pageSettings" xpath="currentBrand/brand/name" value="Compare The Market" />
<%--
<go:setData dataVar="pageSettings" xpath="currentBrand" xml="${applicationSettings['application/brands/ctm/brand']}" />
--%>

<%--
	HEALTH
	This should all be done properly in a java class that loads all DB settings...
--%>
<c:if test="${pageSettings.vertical == 'health'}">
	<%-- Dual pricing --%>
		<jsp:useBean id="date" class="java.util.Date" />
		<fmt:formatDate value="${date}" pattern="yyyy" var="currentYear" />
		<sql:setDataSource dataSource="jdbc/test" />
		<c:catch var="error">
			<sql:query var="find_setting">
				SELECT description
				FROM test.general
				WHERE type = 'healthSettings' AND code = 'dual-pricing'
				LIMIT 1;
			</sql:query>
		</c:catch>

		<%-- Switch to 0 to disable all rendering of alt premium content --%>
		<c:set var="healthDualpricing">
			<c:choose>
				<c:when test="${empty error and not empty find_setting}">
					<c:choose>
						<c:when test="${find_setting.rows[0]['description'] ne '0'}">${find_setting.rows[0]['description']}</c:when>
						<c:otherwise>0</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>0</c:otherwise>
			</c:choose>
		</c:set>

		<go:setData dataVar="pageSettings" xpath="healthDualpricing" value="${healthDualpricing}" />
</c:if>
