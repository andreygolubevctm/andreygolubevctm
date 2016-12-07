<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Select element for what sort of relationship status a user eg Family, single, couple etc..."%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="medicareCheck" value='${contentService.getContentWithSupplementary(pageContext.getRequest(), "medicareCheck")}' />

<c:set var="hospitalFamilyYoung" value="" />

<div class="row medicareCheck">
	<div class="col-sm-12">
		<div class="question">${medicareCheck.getSupplementaryValueByKey('questionText')}</div>
		<div class="action"><a href="${medicareCheck.getSupplementaryValueByKey('url')}" target="_new">${medicareCheck.getSupplementaryValueByKey('actionText')}</a> ></div>
	</div>
</div>