<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Widget to take  users to the brochureware site if they don't have a green medicare card"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="medicareCheck" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "medicareCheck")}' />

<c:set var="hospitalFamilyYoung" value="" />

<div class="medicareCheck">
	<div class="question">${medicareCheck.getSupplementaryValueByKey('questionText')}</div>
	<div class="action"><a href="${medicareCheck.getSupplementaryValueByKey('url')}" target="_new" <field_v1:analytics_attr analVal="nav link" quoteChar="\"" />>${medicareCheck.getSupplementaryValueByKey('actionText')}</a> ></div>
</div>