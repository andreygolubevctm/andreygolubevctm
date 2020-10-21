<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Places dialogue markers for call center staff"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<c:set var="logger" value="${log:getLogger('tag.simples.dialogue')}" />
<jsp:useBean id="date" class="java.util.Date" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 			required="true"	 	rtexprvalue="true" 	description="The database id for the dialogue message e.g. 12" %>
<%@ attribute name="vertical"		required="true"	 	rtexprvalue="true" 	description="Vertical to associate this dialogue with e.g. health" %>
<%@ attribute name="className" 		required="false"	rtexprvalue="true" 	description="Additional css class (colour variations are green/red/purple)" %>
<%@ attribute name="mandatory" 		required="false"	rtexprvalue="true" 	description="Flag for whether the prompt is a mandatory tickbox" %>
<%@ attribute name="dynamic" 		required="false"	rtexprvalue="true" 	description="Flag for whether the dialogue box has dynamic values" %>
<%@ attribute name="checkboxXPath" 	required="false"	rtexprvalue="true" 	description="XPath override to apply to checkbox" %>
<%@ attribute name="dialogueText"	required="false"	rtexprvalue="true"	description="Manually pass in text to render in dialog" %>

<%@ attribute fragment="true" required="false" name="body_start" %>

<c:if test="${callCentre}">
	<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />

	<c:set var="continuousCoverYear" value="${financialYearUtils.getContinuousCoverYear()}" />

	<%-- VARIABLES --%>
	<c:set var="mandatory">
	<c:if test="${mandatory=='true'}">${true}</c:if>
	</c:set>

    <c:choose>
        <c:when test="${empty dialogueText}">
            <c:catch var="error">
                <sql:query var="result" dataSource="${datasource:getDataSource()}" maxRows="1">
                    SELECT text FROM ctm.dialogue
                    WHERE dialogueID = ?
                    AND (styleCodeId = ? OR styleCodeId = 0)
                    ORDER BY dialogueId, styleCodeId DESC
                    LIMIT 1
                    <sql:param value="${id}" />
                    <sql:param value="${styleCodeId}" />
                </sql:query>
                <c:set var="dialogueText" value="${result.rows[0]['text']}" />
                <c:set var="dialogueText" value="${fn:replace(dialogueText, '%10YEARSAGO%', continuousCoverYear)}" />
            </c:catch>
            <c:if test="${error}">
                ${logger.warn('Exception querying database. {},{}',log:kv('id', id), log:kv('styleCodeId',styleCodeId ), error)}
            </c:if>
        </c:when>
        <c:otherwise>
            <c:set var="id" value="${miscUtils:getRandomUUID()}" />
        </c:otherwise>
    </c:choose>

	<%-- OUTPUT: display and test for additional flags --%>
	<div id="simples-dialogue-${id}" class="simples-dialogue-${id} simples-dialogue row-content ${className}<c:choose><c:when test="${not empty mandatory && mandatory == true}"> mandatory</c:when><c:otherwise> optionalDialogue</c:otherwise></c:choose>">
		<jsp:invoke fragment="body_start" />

		<c:set var="checkboxXPathStr">
			<c:choose>
				<c:when test="${not empty checkboxXPath}">${checkboxXPath}</c:when>
				<c:otherwise>${vertical}/simples/dialogue-checkbox-${id}</c:otherwise>
			</c:choose>
		</c:set>

		<c:choose>
			<c:when test="${not empty mandatory && mandatory == true}">
				<div class="wrapper">

					<field_v2:checkbox
						xpath="${checkboxXPathStr}"
						value="Y"
						required="true"
						label="true"
						errorMsg="Please confirm each mandatory dialog has been read to the client"
						className="checkbox-custom simples_dialogue-checkbox-${id}"
						title="${dialogueText}" />

				</div>
			</c:when>
			<c:otherwise>
				${dialogueText}
			</c:otherwise>
		</c:choose>
		<jsp:doBody />

		<c:choose>
			<c:when test="${not empty dynamic && dynamic == true}">
				{{= meerkat.modules.simplesDynamicDialogue.parse(${id}) }}
			</c:when>
		</c:choose>
	</div>
</c:if>