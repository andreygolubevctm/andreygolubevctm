<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="title" required="true" rtexprvalue="true" description="Title of the snapshot" %>
<%@ attribute name="content" required="true" rtexprvalue="true" description="Content for the snapshot" %>

<div class="sidebar-box hidden-xs">
    <h4>${title}</h4>
    ${content}
</div>