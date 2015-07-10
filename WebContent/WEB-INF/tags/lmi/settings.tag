<%@ tag description="LMI JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{
    journeyStage: "<c:out value="${data[pageSettings.getVerticalCode()]['/journey/stage']}"/>",
    pageAction: '<c:out value="${param.action}"  escapeXml="true"/>',
    brands: '<c:out value="${data[pageSettings.getVerticalCode()]['brand']}" />'
}