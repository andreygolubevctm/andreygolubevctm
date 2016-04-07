<%@ tag description="Loading of the Life Settings JS Object"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{
    journeyStage: "<c:out value="${data['ip/journey/stage']}"/>",
    pageAction: '<c:out value="${param.action}"  escapeXml="true"/>',
    previousTransactionId: "<c:out value="${data['current/previousTransactionId']}"/>",
    isNewQuote: <c:out value="${isNewQuote eq true}" />,
    navMenu: {
        type: 'offcanvas',
        direction: 'right'
    }
}