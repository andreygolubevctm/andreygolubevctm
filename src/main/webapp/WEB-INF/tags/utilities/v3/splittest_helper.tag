<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Split test Code"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<jsp:useBean id="splitTestService" class="com.ctm.web.core.services.tracking.SplitTestService" />

<c:set var="splitTestEnabled"  scope="session">
    <content:get key="utilitiesRedesign" />
</c:set>