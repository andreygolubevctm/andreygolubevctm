<%@ tag description="The Health Journey's 'All About You' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="resultsForm" className="resultsSlide">

    <layout_v3:slide_content>
        <health_v4_results:results />
        <c:if test="${data.health.currentJourney != null && data.health.currentJourney != 2}">
            <health_v4_moreinfo:more_info />
        </c:if>
        <c:if test="${data.health.currentJourney != null && data.health.currentJourney == 2}">
            <health_v4_moreinfo_v2:more_info />
        </c:if>
        <health_v4_results:prices_have_changed_notification />
        <health_v4:dual_pricing_modal />
        <health_v4:logo_price_template />
        <health_v4:logo_price_template_affixed_header />
        <health_v4:about_the_fund_template />
    </layout_v3:slide_content>

</layout_v3:slide>
