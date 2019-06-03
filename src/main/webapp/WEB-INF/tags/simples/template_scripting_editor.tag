<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<jsp:useBean id="financialYearUtils" class="com.ctm.web.health.utils.FinancialYearUtils" />
<c:set var="continuousCoverYear" value="${financialYearUtils.getContinuousCoverYear()}" />

<c:set var="styleCodeId">${pageSettings.getBrandId()}</c:set>

	<c:catch var="error">
		<sql:query var="result" dataSource="${datasource:getDataSource()}" maxRows="1">
			SELECT text FROM ctm.dialogue
			WHERE dialogueID = ?
			AND (styleCodeId = ? OR styleCodeId = 0)
			ORDER BY dialogueId, styleCodeId DESC
			LIMIT 1
			<sql:param value="${obj.id}" />
			<sql:param value="${styleCodeId}" />
		</sql:query>
		<c:set var="dialogueText" value="${result.rows[0]['text']}" />
		<c:set var="dialogueText" value="${fn:replace(dialogueText, '%10YEARSAGO%', continuousCoverYear)}" />
	</c:catch>
	<c:if test="${error}">
		${logger.warn('Exception querying database. {},{}',log:kv('id', id), log:kv('styleCodeId',styleCodeId ), error)}
	</c:if>

<script id="simples-template-scripting-editor" type="text/html">
<div class="simples-scripting-editor-modal">
		<div id="simples-scripting-editor-modal-header" class="row">
			<div class="col-xs-12">
				<h2>Simples Dialogue Editor</h2>
			</div>
			<div>
				HELLO THERE!
				${dialogueText}
			</div>
			<div class="col-xs-8 text-right">
				<form class="simples-scripting-editor form-inline" role="search">
					<div class="form-group">
						<input type="text" name="keywords" class="form-control input-sm" value="${dialogueText}">
					</div>
					<button type="submit" class="btn btn-default btn-sm">Save</button>
				</form>
			</div>
		</div>
</div>

</script>
