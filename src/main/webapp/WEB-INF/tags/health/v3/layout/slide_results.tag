<%@ tag description="The Health Journey's 'Results' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

    <layout_v3:slide_content>
        <simples:dialogue id="57" className="simples-dialogue-results" vertical="health" />
        <simples:dialogue id="33" className="simples-dialogue-results" vertical="health" />
        <simples:dialogue id="58" className="simples-dialogue-results" vertical="health" />
        <simples:dialogue id="60" className="simples-dialogue-more-info" vertical="health" />

        <health_v3:results />
        <health_v3:more_info/>

        <simples:dialogue id="24" vertical="health" />
        <simples:dialogue id="59" vertical="health" />
    </layout_v3:slide_content>

</layout_v3:slide>
<simples:dialogue id="62" vertical="health" className="hidden" />