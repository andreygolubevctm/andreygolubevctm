<%@ tag description="Journey slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout:slide formId="resultsForm" className="resultsSlide">
    <layout:slide_content>
        <utilities_new:results/>
        <utilities_new:results_snapshot />
    </layout:slide_content>
</layout:slide>