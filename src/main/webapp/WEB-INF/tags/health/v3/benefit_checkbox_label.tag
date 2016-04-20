<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="item" required="true" type="com.ctm.web.core.results.model.ResultsTemplateItem" %>
<%@ attribute name="category" required="true" description="Which category - Hospital or Extras" %>

<c:set var="logger" value="${log:getLogger('jsp.ajax.json.benefits')}" />
<c:set var="isHospital" value="${item.getShortlistKey()}" />

${logger.warn('Item. {}',log:kv('item',item.getShortlistKey() ), error)}
<c:if test="${item.isShortlistable() and item.hasShortlistableChildren() and item.getShortlistKey() eq category}">
    <c:forEach items="${item.getChildren()}" var="selectedValue">
        <c:if test="${selectedValue.isShortlistable()}">

            <field_v2:checkbox xpath="${pageSettings.getVerticalCode()}/filters/benefits/${selectedValue.getShortlistKey()}" value="Y" required="false" label="true"
                               title="${selectedValue.getName()}" helpId="${selectedValue.getHelpId()}" theme="none"/>
        </c:if>
    </c:forEach>

</c:if>