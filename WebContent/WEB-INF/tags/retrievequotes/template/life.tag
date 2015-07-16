<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-life-template">

    {{ var quoteContent = typeof obj.content != 'undefined' ? obj.content : {}; }}

    <h5>{{= obj.primary.firstName }} {{= obj.primary.lastname }} Life Insurance</h5>

    {{ if(quoteContent.situation) { }}
    <div class="quote-detail">
        <strong>Situation: </strong> {{= quoteContent.situation }}
    </div>
    {{ } }}
    {{ if(quoteContent.term) { }}
    <div class="quote-detail">
        <strong>Term Life Cover: </strong> \${{= quoteContent.term }}
    </div>
    {{ } }}
    {{ if(quoteContent.tpd) { }}
    <div class="quote-detail">
        <strong>TPD Cover: </strong> \${{= quoteContent.tpd }}
    </div>
    {{ } }}
    {{ if(quoteContent.trauma) { }}
    <div class="quote-detail">
        <strong>Trauma Cover: </strong> \${{= quoteContent.trauma }}
    </div>
    {{ } }}
    {{ if(quoteContent.premium) { }}
    <div class="quote-detail">
        <strong>Premium: </strong> {{= quoteContent.premium }}
    </div>
    {{ } }}
</core:js_template>