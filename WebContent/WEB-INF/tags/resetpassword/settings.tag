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
    resetPasswordId: "<c:out value="${param.get('id')}" escapeXml="true" />"
}