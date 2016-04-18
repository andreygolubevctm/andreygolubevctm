<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

    <layout_v3:slide_content>

        <health_v2:results/>
        <health_v3:more_info/>
        <health_v1:prices_have_changed_notification/>

    </layout_v3:slide_content>

</layout_v3:slide>