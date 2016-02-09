<%@ tag description="Display Random Supplimentary Content" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="cssClass" 		required="true" rtexprvalue="true"	 description="CSS class for wrapping div" %>
<%@ attribute name="contentKey"	required="true" rtexprvalue="true"	 description="Content Key" %>

<jsp:useBean id="random" class="com.ctm.web.core.utils.RandomNumberGenerator" scope="session" />

<c:set var="collection" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), contentKey)}' />
<c:set var="size" value="${collection.getSupplementary().size()}"/>
<c:set var="selected">${random.getRandomNumber(size)}</c:set>

<div class="${cssClass}">
    <c:forEach items="${collection.getSupplementary()}" var="item" >
        <c:if test="${collection.getSupplementary()[selected] == item}">
            <p>
                    ${item.getSupplementaryValue()}
            </p>
        </c:if>
    </c:forEach>
</div>