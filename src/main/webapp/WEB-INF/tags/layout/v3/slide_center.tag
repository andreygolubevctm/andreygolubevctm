<%@ tag description="Layout to be centered using Push Columns" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xsWidth" required="false" rtexprvalue="true" description="Numeric: How wide the grid should be at XS, centered" %>
<%@ attribute name="smWidth" required="false" rtexprvalue="true" description="Numeric: How wide the grid should be at SM, centered" %>
<%@ attribute name="mdWidth" required="false" rtexprvalue="true" description="Numeric: How wide the grid should be at MD, centered" %>
<%@ attribute name="lgWidth" required="false" rtexprvalue="true" description="Numeric: How wide the grid should be at LG, centered" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="Extra Class Name" %>

<%-- Set Predefined Columns as Full Width if not provided --%>
<c:if test="${empty xsWidth}">
    <c:set var="xsWidth" value="0"/>
</c:if>
<c:if test="${empty smWidth}">
    <c:set var="smWidth" value="0"/>
</c:if>
<c:if test="${empty mdWidth}">
    <c:set var="mdWidth" value="0"/>
</c:if>
<c:if test="${empty lgWidth}">
    <c:set var="lgWidth" value="0"/>
</c:if>

<fmt:parseNumber var="xsWidth" type="number" value="${xsWidth}" />
<fmt:parseNumber var="smWidth" type="number" value="${smWidth}" />
<fmt:parseNumber var="mdWidth" type="number" value="${mdWidth}" />
<fmt:parseNumber var="lgWidth" type="number" value="${lgWidth}" />

<fmt:parseNumber var="xsPushCols" type="number" value="${(12-xsWidth)/2}" />
<fmt:parseNumber var="smPushCols" type="number" value="${(12-smWidth)/2}" />
<fmt:parseNumber var="mdPushCols" type="number" value="${(12-mdWidth)/2}" />
<fmt:parseNumber var="lgPushCols" type="number" value="${(12-lgWidth)/2}" />

<c:set var="xsPushColsClass" value="" />
<c:if test="${xsPushCols > 0 && xsPushCols < 12}">
    <c:set var="xsPushColsClass" value=" col-xs-push-${xsPushCols}"/>
</c:if>
<c:set var="smPushColsClass" value=""/>
<c:if test="${smPushCols > 0 && smPushCols ne xsPushCols && smPushCols < 12 && smPushCols ne mdPushCols && smPushCols ne lgPushCols}">
    <c:set var="smPushColsClass" value=" col-sm-push-${smPushCols}"/>
</c:if>
<c:set var="mdPushColsClass" value=""/>
<c:if test="${mdPushCols > 0 && mdPushCols ne smPushCols && mdPushCols < 12 && mdPushCols ne xsPushCols && mdPushCols ne lgPushCols}">
    <c:set var="mdPushColsClass" value=" col-md-push-${mdPushCols}"/>
</c:if>
<c:set var="lgPushColsClass" value=""/>
<c:if test="${lgPushCols > 0 && lgPushCols ne mdPushCols && lgPushCols < 12 && lgPushCols ne xsPushCols && lgPushCols ne smPushCols}">
    <c:set var="lgPushColsClass" value=" col-lg-push-${lgPushCols}"/>
</c:if>

<c:set var="xsColsClass" value=""/>
<c:if test="${xsWidth > 0}">
    <c:set var="xsColsClass" value=" col-xs-${xsWidth}"/>
</c:if>
<c:set var="smColsClass" value=""/>
<c:if test="${smWidth > 0 && smWidth ne xsWidth}">
    <c:set var="smColsClass" value=" col-sm-${smWidth}"/>
</c:if>
<c:set var="mdColsClass" value=""/>
<c:if test="${mdWidth > 0 && mdWidth ne smWidth}">
    <c:set var="mdColsClass" value=" col-md-${mdWidth}"/>
</c:if>
<c:set var="lgColsClass" value=""/>
<c:if test="${lgWidth > 0 && lgWidth ne mdWidth}">
    <c:set var="lgColsClass" value=" col-lg-${lgWidth}"/>
</c:if>

<div class="row">
    <div class="${className} ${xsColsClass}${xsPushColsClass}${smColsClass}${smPushColsClass}${mdColsClass}${mdPushColsClass}${lgColsClass}${lgPushColsClass}">
        <jsp:doBody/>
    </div>
</div>
