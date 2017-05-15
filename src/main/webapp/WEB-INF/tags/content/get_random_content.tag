<%@ tag description="Display Random Supplimentary Content" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="cssClass" 		required="true" rtexprvalue="true"	 description="CSS class for wrapping div" %>
<%@ attribute name="contentKey"	required="true" rtexprvalue="true"	 description="Content Key" %>

<jsp:useBean id="randomContentService" class="com.ctm.web.core.content.services.RandomContentService" scope="session" />
${randomContentService.init(contentService,pageContext.getRequest(), contentKey)}
<div class="${cssClass}">
    <c:if test="${randomContentService.hasSupplementaryValue()}">
        <p>
        ${randomContentService.supplementaryValue}
        </p>
    </c:if>
</div>