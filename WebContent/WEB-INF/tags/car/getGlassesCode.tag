<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Get glasses code from redbook code"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="redbookCode" required="true" description="The redbook code"%>
<%@ attribute name="year" required="false" description="The Year of the car if known"%>

<%--

Only check for the current year and is only Jan to Mar of the current year. This
addresses the Release years of models.

Otherwise, just use the red code to get the year
--%>
<jsp:useBean id="now" class="java.util.GregorianCalendar" />

<c:set var="today"><read:return_date returnDatePattern="D"/></c:set>
<c:set var="theyear"><read:return_date returnDatePattern="YYYY" /></c:set>

<sql:setDataSource dataSource="jdbc/aggregator"/>

<c:choose>
	<c:when test="${today <= 91 }">
		<sql:query var="glasses">
			SELECT glasscode
			FROM aggregator.glasses_extract
			WHERE redbookCode = ? and
			year =?
			LIMIT 1;
			<sql:param>${redbookCode}</sql:param>
			<sql:param>${year}</sql:param>
		</sql:query>

		<c:choose>
			<c:when test="${glasses.rowCount != 0}">
				<c:set var="glassesCode">${glasses.rows[0].glasscode}</c:set>
			</c:when>
			<c:otherwise>
				<%-- we need to take one year off --%>
				<sql:query var="glasses2">
					SELECT glasscode
					FROM aggregator.glasses_extract
					WHERE redbookCode = ? and
					year =?
					LIMIT 1;
					<sql:param>${redbookCode}</sql:param>
					<sql:param>${year-1}</sql:param>
				</sql:query>
				<c:set var="glassesCode">${glasses2.rows[0].glasscode}</c:set>
			</c:otherwise>
		</c:choose>


	</c:when>
	<c:otherwise>
			<sql:query var="glasses3">
				SELECT glasscode
				FROM aggregator.glasses_extract
				WHERE redbookCode = ?
				LIMIT 1;
				<sql:param>${redbookCode}</sql:param>
			</sql:query>
				<c:set var="glassesCode">${glasses3.rows[0].glasscode}</c:set>
	</c:otherwise>

</c:choose>

${glassesCode}
