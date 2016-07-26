<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

    <layout_v3:slide_content>
        <simples:dialogue id="62" vertical="health" className="hidden" />
        <health_v3:results />
        <health_v3:more_info/>
    </layout_v3:slide_content>

</layout_v3:slide>