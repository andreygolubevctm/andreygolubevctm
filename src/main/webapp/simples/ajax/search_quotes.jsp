<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="logger" value="${log:getLogger('jsp.simples.ajax.search_quotes')}" />

<session:getAuthenticated  />
<jsp:useBean id="data" class="com.ctm.web.core.web.go.Data" scope="request" />
<jsp:useBean id="searchService" class="com.ctm.web.simples.services.SimplesSearchService" scope="request" />

<go:setData dataVar="data" xpath="search_results" value="*DELETE" />

<c:set var="searchPhrase" value="${fn:trim(param.search_terms)}" />

${logger.info('Begin search Quotes. {}' , log:kv('searchPhrase',searchPhrase ))}

<c:set var="isOperator"><c:if test="${not empty authenticatedData['login/user/uid']}">${authenticatedData['login/user/uid']}</c:if></c:set>

<c:catch var="error">
	${searchService.init(pageContext)}
	${searchService.SearchTransactions()}

</c:catch>
<c:choose>
	<c:when test="${empty error}">
		<%-- Read the data bucket and formate results --%>
		<c:choose>
			<c:when test="${not empty data['no_results']}">
				{
					"errors": [{"message":"No results found for [${go:jsEscape(searchPhrase)}]"}] ,
					"searchPhrase": "${go:jsEscape(searchPhrase)}",
					"simplesMode": "${searchService.getSearchMode().toString()}"
				}
			</c:when>
			<c:otherwise>
				<c:import var="xslt" url="/WEB-INF/xslt/simples_search_results.xsl" />
				<c:set var="resultsXml">
					<x:transform doc="${go:getEscapedXml(data['search_results'])}" xslt="${xslt}" />
				</c:set>

				<%-- Convert XML results into JSON and delete all search data from data bucket --%>
				${go:XMLtoJSON(resultsXml)}
				<go:setData dataVar="data" xpath="search_results" value="*DELETE" />
				<x:transform doc="${go:getEscapedXml(data['search_results'])}" xslt="${xslt}" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		{
		"errors": [{"message":"${searchService.getError()}"}] ,
		"searchPhrase": "${go:jsEscape(searchPhrase)}",
		"simplesMode": "${searchService.getSearchMode().toString()}"
		}
	</c:otherwise>
</c:choose>
<%-- Safe side delete any search data from the databucket at the end--%>
<go:setData dataVar="data" xpath="search_results" value="*DELETE" />