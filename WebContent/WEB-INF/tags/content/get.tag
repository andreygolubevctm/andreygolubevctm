<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="key" required="true" rtexprvalue="true"  %>

<session:core />

${contentService.getContentValue(pageContext.getRequest(), key)}