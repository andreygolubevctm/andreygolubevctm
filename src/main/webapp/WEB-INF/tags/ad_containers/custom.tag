<%@ tag description="Ad Container for custom position"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>


<%@ attribute name="customId" required="true"  rtexprvalue="true" description="The unique id of the custom ad container"%>

<div class="ad-custom-${customId}" data-id="ad-custom-${customId}"></div>