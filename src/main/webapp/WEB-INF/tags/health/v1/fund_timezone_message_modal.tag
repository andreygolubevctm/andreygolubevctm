<%@ tag description="Health Funds Timezone message modal"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="message">
    <c:choose>
        <c:when test="${callCentre}">
            Just to let you know, {{= obj.fundCode }} is based in {{= obj.timezone }}, at the moment, in that state it's now {{= obj.coverStartDate }}, so what that means is, your policy will start on {{= obj.coverStartDate }}{{ if (!_.isNull(obj.deductionDate)) { }} and your payment will be deducted on {{= obj.deductionDate }}{{ } }}.
        </c:when>
        <c:otherwise>
            Hi {{= obj.firstname }}, {{= obj.fundCode }} is based in {{= obj.timezone }}, the date here is now {{= obj.coverStartDate }} your policy will therefore commence on {{= obj.coverStartDate }}{{ if (!_.isNull(obj.deductionDate)) { }} and your payment will be deducted on {{= obj.deductionDate }}{{ } }}. Click submit to take out this policy.
        </c:otherwise>
    </c:choose>
</c:set>

<%-- HTML --%>
<core_v1:js_template id="fund-timezone-offset-modal-template">
    <p>${message}</p>
</core_v1:js_template>