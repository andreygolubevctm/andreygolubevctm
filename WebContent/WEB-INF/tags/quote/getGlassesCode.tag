<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Get glasses code from redbook code"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="redbookCode" required="true" description="The redbook code"%>
<sql:setDataSource dataSource="jdbc/aggregator"/>
<sql:query var="glasses">
	SELECT glasscode
	FROM test.glasses_extract
	WHERE redbookCode = ?
	LIMIT 1;
	<sql:param>
		${redbookCode}
	</sql:param>
</sql:query>

<c:if test="${glasses.rowCount != 0}">
	${glasses.rows[0].glasscode}
</c:if>