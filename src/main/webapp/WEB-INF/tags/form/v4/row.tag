<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a single row on a form with grid layout on sm+ of 4 - 8" %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ attribute name="hideRowBorder" required="false" rtexprvalue="true" description="toggle the row border" %>
<%@ attribute name="label" required="false" rtexprvalue="true" description="label for the field" %>
<%@ attribute name="subLabel" required="false" rtexprvalue="true" description="sublabel for the field" %>
<%@ attribute name="id" required="false" rtexprvalue="true" description="optional id for this row" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="additional css class attribute" %>
<%@ attribute name="smRowOverride" required="false" rtexprvalue="true" description="Override the SM value" %>
<%@ attribute name="isNestedField" required="false" rtexprvalue="true" description="Toggle to automatically set some styling values for the nested fields eg name_group.tag" %>
<%@ attribute name="isNestedStyleGroup" required="false" rtexprvalue="true" description="Toggle to remove the col-xs-12 class. If not removed breaks the nesting design introduced to health" %>
<%@ attribute name="rowContentClass" required="false" rtexprvalue="true" description="additional css class attribute" %>

<%-- Attributes to pass through --%>
<%@ attribute name="fieldXpath" required="false" rtexprvalue="true" description="The xpath of the field the label needs to point to" %>
<%@ attribute name="showHelpText" required="false" rtexprvalue="true" description="Trigger to display help icon as text rather than icon" %>
<%@ attribute name="helpId" required="false" rtexprvalue="true" description="Help tooltip ID" %>
<%@ attribute name="addForAttr" required="false" rtexprvalue="true" description="Bool to add or not the for attribute" %>

<%-- SETUP --%>
<c:if test="${empty addForAttr}"><c:set var="addForAttr" value="${true}" /></c:if>
<c:set var="showHelpIcon" value="${true}" />
<c:if test="${empty helpId}">
    <c:set var="helpId" value="" />
    <c:set var="showHelpIcon" value="${false}" />
</c:if>
<c:set var="showLabel" value="${true}" />
<c:if test="${empty label or label eq '' or label eq 'empty'}"><c:set var="showLabel" value="${false}" /></c:if>
<c:set var="inputWidthSm" value="8 " />
<c:if test="${not empty smRowOverride}"><c:set var="inputWidthSm" value="${smRowOverride} " /></c:if>
<c:set var="labelWidthXs" value="10" />
<c:if test="${showHelpIcon eq false}"><c:set var="labelWidthXs" value="12" /></c:if>
<c:set var="formGroupClasses" value="" />
<c:set var="labelClass" value="hidden-sm hidden-md hidden-lg" />
<c:set var="rowClass" value=" " />

<c:set var="rowBorderClass" value="" />
<c:if test="${hideRowBorder eq true}">
    <c:set var="rowBorderClass" value="hide-row-border " />
</c:if>
<c:if test="${not isNestedField eq true}">
    <c:set var="formGroupClasses" value="form-group row " />
    <c:set var="labelClass" value="" />
</c:if>
<c:if test="${isNestedStyleGroup eq true}">
    <c:set var="formGroupClasses" value="nestedGroup form-group " />
    <c:set var="inputClass" value="row " />
    <c:set var="labelClass" value="hidden-xs" />
</c:if>
<c:set var="inputOffsetSm" value="" />
<c:if test="${showLabel eq false}"><c:set var="inputOffsetSm" value="col-sm-offset-4 " /></c:if>
<%-- / SETUP --%>

<div class="${formGroupClasses} ${rowBorderClass} fieldrow ${className}"<c:if test="${not empty id}"> id="${id}"</c:if>>
    <%-- Row Label --%>
    <c:if test="${showLabel}">
        <div class="col-xs-<c:out value="${labelWidthXs} " /> col-sm-4 <c:out value="${labelClass}" />">
            <field_v2:label value="${label}" xpath="${fieldXpath}" addForAttr="${addForAttr}" helpId="${helpId}" showText="${showHelpText}" />
            <c:if test="${not empty subLabel}"><div class="control-sub-label">${subLabel}</div></c:if>
        </div>
        <%-- XS Help Tip: Only show if there's a label too. --%>
        <c:if test="${showHelpIcon eq true}">
            <div class="col-xs-2 text-right hidden-sm hidden-md hidden-lg">
                <field_v2:help_icon helpId="${helpId}" showText="${showHelpText}" />
            </div>
        </c:if>
    </c:if>
    <%-- Row Input --%>
    <div class="col-xs-12 col-sm-<c:out value="${inputWidthSm}" /> <c:out value="${inputClass}" /> <c:out value="${inputOffsetSm}" /> <c:out value="${rowContentClass}" /> row-content">
        <jsp:doBody />
    </div>
</div>