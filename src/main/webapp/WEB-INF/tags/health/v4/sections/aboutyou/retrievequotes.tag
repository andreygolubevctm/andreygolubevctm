<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Widget to take  users to the retrieve quotes site"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="retrieveQuotes" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "retrieveQuotes")}' />

<div class="retrieveQuotes">
    <div class="question">${retrieveQuotes.getSupplementaryValueByKey('questionText')}</div>
    <a href="${pageSettings.getBaseUrl()}retrieve_quotes.jsp" target="_blank" class="btn btn-secondary">Retrieve quote</a>
</div>