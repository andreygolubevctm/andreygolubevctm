<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm">

    <layout_v3:slide_content>
        <health_v4_results:simples_top />
        <health_v4_results:results />
        <health_v4_moreinfo:more_info />
        <%--
        <health_v1:prices_have_changed_notification />--%>
        <health_v4_results:simples_bottom />

    </layout_v3:slide_content>

</layout_v3:slide>