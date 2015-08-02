<%@ tag description="Setup of the JS Object" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{
    isCallCentreUser: false,
    isFromBrochureSite: false,
    brochureValues: {},
    navMenu: {
        type: 'offcanvas',
        direction: 'right'
    },
    session: {
        firstPokeEnabled: false
    },
    responseJson: <c:out value="${responseJson}" escapeXml="false" />,
    loggedIn: <c:out value="${isLoggedIn}" escapeXml="false" />
}