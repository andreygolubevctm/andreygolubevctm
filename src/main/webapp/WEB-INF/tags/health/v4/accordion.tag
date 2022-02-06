<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="id"	 rtexprvalue="true"	 description="accordion's id" %>
<%@attribute name="title" fragment="true" %>
<%@ attribute name="hidden"	 rtexprvalue="true"	 description="should the accordion start in a hidden state" %>
<%@ attribute name="iconClass"	 rtexprvalue="true"	 description="overrides default expand icon" %>

<div class="accordion-container ${hidden ? 'hidden' : ''}" id="${id}">
    <div class="accordion-title-container">
        <div class="accordion-title">
            <jsp:invoke fragment="title" />
        </div>
        <c:choose>
            <c:when test="${iconClass eq 'plus'}">
                <span class="accordion-plus-icon icon expander">+</span>
            </c:when>
            <c:otherwise>
                <span class="accordion-expand-icon icon expander"></span>
            </c:otherwise>
        </c:choose>
    </div>
    <div class="accordion-content-container">
      <jsp:doBody/>
    </div>
</div>
