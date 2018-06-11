<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- @todo: reimplement --%>
<c:forEach items="${resultTemplateItems}" var="selectedValue">
    <health_v2:benefitsHiddenItem item="${selectedValue}" />
</c:forEach>

<c:set var="fieldValue" value="N" />
<c:if test="${data['health/situation/accidentOnlyCover'] != '' && not empty data['health/situation/accidentOnlyCover']}">
    <c:set var="fieldValue"><c:out value="${data['health/situation/accidentOnlyCover']}" escapeXml="true"/></c:set>
</c:if>
<input type="hidden" name="health_situation_accidentOnlyCover" class="benefit-item" value="${fieldValue}" data-skey="accidentOnlyCover" />
<c:set var="maxMilliToGetResults">
    <content:get key="maxMilliSecToWait"/>
</c:set>
<c:choose>
    <c:when test="${not empty maxMilliToGetResults}">
        <input type="hidden" id="maxMilliSecToWait" value="${maxMilliToGetResults}"/>
    </c:when>
    <c:otherwise>
        <input type="hidden" id="maxMilliSecToWait" value="0"/>
    </c:otherwise>
</c:choose>
<input type="hidden" id="waitMessage" value="<content:get key='waitMessage'/>"/>

<field_v1:hidden xpath="health/renderingMode" />
<field_v1:hidden xpath="health/rebate" />
<field_v1:hidden xpath="health/rebateChangeover" />
<field_v1:hidden xpath="health/previousRebate" />
<field_v1:hidden xpath="health/loading" />
<field_v1:hidden xpath="health/primaryCAE" />
<field_v1:hidden xpath="health/partnerCAE" />
<field_v1:hidden xpath="health/situation/location" />

<form_v1:operator_id xpath="${pageSettings.getVerticalCode()}/operatorid" />
<core_v1:referral_tracking vertical="${pageSettings.getVerticalCode()}" />
<core_v2:authToken authToken="${param['authToken']}"/>

<field_v1:hidden xpath="health/brochureEmailHistory" />
