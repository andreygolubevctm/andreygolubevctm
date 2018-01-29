<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select box built from general table." %>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="variable's xpath" %>
<%@ attribute name="required" required="false" rtexprvalue="true" description="is this field required?" %>
<%@ attribute name="className" required="false" rtexprvalue="true" description="additional css class attribute" %>
<%@ attribute name="title" required="false" rtexprvalue="true" description="subject of the select box" %>
<%@ attribute name="type" required="false" rtexprvalue="true" description="type code on general table" %>
<%@ attribute name="initialText" required="false" rtexprvalue="true" description="Text used to invite selection" %>
<%@ attribute name="tabIndex" required="false" rtexprvalue="true" description="additional tab index specification" %>
<%@ attribute name="additionalAttributes" required="false"	rtexprvalue="true"	 description="additional attributes to apply to the select" %>
<%@ attribute name="disableErrorContainer" 	required="false" 	rtexprvalue="true"    	 description="Show or hide the error message container" %>
<%@ attribute name="additionalLabelAttributes" required="false"	rtexprvalue="true"	 description="additional attributes to apply to the select" %>
<%@ attribute name="additionalOptions" required="false"	rtexprvalue="true"	 description="additional options to add to the select if required. Format: value1=des 1,value2=des 2" %>

<%-- VARIABLES --%>
<c:set var="name" value="${go:nameFromXpath(xpath)}"/>
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>

<c:if test="${empty type}">
    <c:set var="type" value="emptyset"/>
</c:if>

<c:if test="${empty initialText}">
    <c:set var="initialText" value="Please choose&hellip;"/>
</c:if>
<c:if test="${empty comboBox}">
    <c:set var="comboBox" value="false"/>
</c:if>

<c:if test="${value == ''}">
    <c:set var="sel" value="selected" />
</c:if>

<c:if test="${disabled == 'true'}">
    <c:set var="disabled" value="selected"/>
</c:if>

<c:if test="${disableErrorContainer eq true}">
    <c:set var="additionalAttributes" value='${additionalAttributes}  data-disable-error-container="true" '/>
</c:if>

<c:if test="${empty additionalOptions}">
    <c:set var="additionalOptions" value=""/>
</c:if>

<%-- HTML --%>
<sql:setDataSource dataSource="${datasource:getDataSource()}"/>

<sql:query var="result">
    SELECT code, description FROM aggregator.general WHERE type = ? AND (status IS NULL OR status != 0) ORDER BY orderSeq
<sql:param>${type}</sql:param>
</sql:query>


<div class="select">
	<span class=" input-group-addon">
		<i class="icon-sort"></i>
	</span>
    <select name="${name}" id="${name}" class="form-control ${className}"<c:if test="${not empty tabIndex}"> tabindex="${tabIndex}"</c:if><c:if test="${required}"> required data-msg-required="Please enter the ${title}"</c:if> ${additionalAttributes}>
        <%-- Write the initial "please choose" option --%>
        <option value="">${initialText}</option>

        <%-- Write the options for each row --%>
        <c:forEach var="row" items="${result.rows}">
            <option value="${row.code}"
                    <c:if test="${row.code == value}"> selected="selected" </c:if>
                    <c:if test="${not empty row.hannoverCode}"> data-hannovercode="${row.hannoverCode}" </c:if>>
                    ${row.description}
            </option>
        </c:forEach>
        <c:forTokens items="${additionalOptions}" delims="," var="optionItem">
            <c:set var="val" value="${fn:substringBefore(optionItem,'=')}" />
            <c:set var="des" value="${fn:substringAfter(optionItem,'=')}" />
            <option value="${val}"
                    <c:if test="${val == value}"> selected="selected" </c:if>>
                    ${des}
            </option>
        </c:forTokens>
    </select>
</div>

