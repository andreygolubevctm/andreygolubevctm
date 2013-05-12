<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- Get all the URLs for scrapes --%>
<sql:setDataSource dataSource="jdbc/ctm"/>

<c:set var="errorPool" value="" />

<c:set var='where'>
	<c:choose>
		<c:when test="${not empty param.id}">WHERE `id`=?</c:when>
		<c:when test="${not empty param.brand}">WHERE `group`=?</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</c:set>

<c:catch var="error">
	<sql:query var="result">
		SELECT *
		FROM `ctm`.`scrapes`
		${where}
		<sql:param>
			<c:choose>
				<c:when test="${not empty param.id}">${param.id}</c:when>
				<c:when test="${not empty param.brand}">${param.brand}</c:when>
				<c:otherwise></c:otherwise>
			</c:choose>
		</sql:param>
	</sql:query>
</c:catch>

<c:choose>
	<%-- if error connecting to the db --%>
	<c:when test="${not empty error}">
		<c:set var="errorPool">The CTM update_scrapes cron job could not connect to the database - ${error.rootCause}</c:set>
	</c:when>

	<%-- if there are some results --%>
	<c:when test="${not empty result and result.rowCount > 0}">

		<%-- loop through all the scrapes in the db --%>
		<c:forEach var="scrape" items="${result.rows}">

			<%-- workaround because endsWith is buggy when comparing to "/" --%>
			<c:set var="urlEndsWithSlash">
				${fn:substring(scrape.url, fn:length(scrape.url)-1, fn:length(scrape.url)) == '/'}
			</c:set>
			<c:set var="pathStartsWithSlash">
				${fn:substring(scrape.path, 0, 1) == '/'}
			</c:set>

			<%-- normalizing the url --%>
			<c:set var="url">
				<c:choose>
					<c:when test="${urlEndsWithSlash && pathStartsWithSlash}">
						${scrape.url}${fn:substringAfter(scrape.path, '/')}
					</c:when>
					<c:when test="${ (urlEndsWithSlash && not pathStartsWithSlash) or (not urlEndsWithSlash && pathStartsWithSlash)}">
						${scrape.url}${scrape.path}
					</c:when>
					<c:otherwise>
						${scrape.url}/${scrape.path}
					</c:otherwise>
				</c:choose>
			</c:set>

			<%-- scraping the url's page or html selector if defined --%>
			<c:choose>
				<c:when test="${not empty scrape.cssSelector }">
					<c:set var="newScrape">
						<go:scrape sourceEncoding="UTF-8" url="${url}" cssSelector="${scrape.cssSelector}" sanitizeHtml="true" outputEncoding="ISO-8859-1" />
					</c:set>
				</c:when>
				<c:otherwise>
					<c:set var="newScrape">
						<go:scrape sourceEncoding="UTF-8" url="${url}" sanitizeHtml="true" outputEncoding="ISO-8859-1" />
					</c:set>
				</c:otherwise>
			</c:choose>

			<c:choose>

				<%-- Check the scraped content is not empty --%>
				<c:when test="${empty newScrape or newScrape == ''}">
					<c:if test="${not empty errorPool}">
						<c:set var="errorPool">${errorPool},</c:set>
					</c:if>
					<c:set var="selectorError" value="" />
					<c:if test="${not empty scrape.cssSelector }">
						<c:set var="selectorError" value=" (selector: ${scrape.cssSelector})" />
					</c:if>
					<c:set var="errorPool">${errorPool}Scraping of ${url}${selectorError} was empty</c:set>
				</c:when>

				<%-- if string returned includes an exception message, then scraping failed --%>
				<%-- @todo= go:scrape should throw exceptions and should be caught in a catch tag instead of this String check --%>
				<c:when test="${fn:startsWith(newScrape, 'java.io') or fn:startsWith(newScrape, 'java.net')}">

					<c:if test="${not empty errorPool}">
						<c:set var="errorPool">${errorPool},</c:set>
					</c:if>
					<c:set var="selectorError" value="" />
					<c:if test="${not empty scrape.cssSelector }">
						<c:set var="selectorError" value=" (selector: ${scrape.cssSelector})" />
					</c:if>

					<c:choose>
						<c:when test="${fn:startsWith(newScrape, 'java.io.IOException: ')}">
							<c:set var="errorPool">${errorPool}Scraping of ${url}${selectorError} failed - ${fn:substringAfter(newScrape, 'java.io.IOException: ')}</c:set>
						</c:when>

						<c:when test="${fn:startsWith(newScrape, 'java.net.MalformedURLException: ')}">
							<c:set var="errorPool">${errorPool}Scraping of ${url}${selectorError} failed - Malformed URL: ${fn:substringAfter(newScrape, 'java.net.MalformedURLException: ')}</c:set>
						</c:when>

						<c:when test="${fn:startsWith(newScrape, 'java.io.FileNotFoundException: ')}">
							<c:set var="errorPool">${errorPool}Scraping of ${url}${selectorError} failed - 404 error: ${fn:substringAfter(newScrape, 'java.io.FileNotFoundException: ')}</c:set>
						</c:when>
					</c:choose>

				</c:when>

				<%-- scraping worked --%>
				<c:otherwise>

					<%-- don't save if the scraped content has not changed since last time --%>
					<c:if test="${scrape.html != newScrape}">
						<%-- update the scrape with the new scrape content --%>
						<c:catch var="error">
							<sql:update var="count">
								UPDATE `ctm`.`scrapes`
								SET `html`=?, last_updated=NOW()
								WHERE `id`= ?
								<sql:param>${newScrape}</sql:param>
								<sql:param>${scrape.id}</sql:param>
							</sql:update>
						</c:catch>

						<c:if test="${not empty error}">
							<c:if test="${not empty errorPool}">
								<c:set var="errorPool">${errorPool},</c:set>
							</c:if>
							<c:set var="errorPool">${errorPool}Failed to update ${url} - ${error.rootCause}</c:set>
						</c:if>
					</c:if>

				</c:otherwise>

			</c:choose>

		</c:forEach>
	</c:when>

	<c:otherwise>
		<%-- No scrape results found --%>
	</c:otherwise>

</c:choose>

<%-- record all the errors in the database --%>
<c:forTokens items="${errorPool}" delims="," var="error">
	<c:choose>
		<c:when test="${fn:contains(error, ' - ')}">
			<c:set var="errorMsg" value="${fn:substringBefore(error, ' - ')}" />
			<c:set var="errorCode" value="${fn:substringAfter(error, ' - ')}" />
		</c:when>
		<c:otherwise>
			<c:set var="errorMsg" value="${error}" />
			<c:set var="errorCode" value="" />
		</c:otherwise>
	</c:choose>

	<sql:update var="count">
		INSERT INTO `test`.`error_log`(`property`,`origin`,`message`,`code`,`datetime`)
		VALUES('CTM','update_scrapes.jsp',?,?,NOW())
		<sql:param>${errorMsg}</sql:param>
		<sql:param>${errorCode}</sql:param>
	</sql:update>
</c:forTokens>