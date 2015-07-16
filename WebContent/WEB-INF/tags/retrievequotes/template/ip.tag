<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-ip-template">

    {{ var quoteContent = typeof obj.content != 'undefined' ? obj.content : {}; }}

    <h5>Income Protection Quote</h5>

    <div class="quote-detail">
        <strong>Occupation: </strong> {{= obj.primary.occupationTitle }}
    </div>

    {{ if(quoteContent.situation) { }}
    <div class="quote-detail">
        <strong>Situation: </strong> {{= quoteContent.situation }}
    </div>
    {{ } }}
    {{ if(quoteContent.income) { }}
    <div class="quote-detail">
        <strong>Income: </strong> \${{= quoteContent.income }}
    </div>
    {{ } }}
    {{ if(quoteContent.amount) { }}
    <div class="quote-detail">
        <strong>Benefit Amount: </strong> \${{= quoteContent.amount }}
    </div>
    {{ } }}
    {{ if(quoteContent.premium) { }}
    <div class="quote-detail">
        <strong>Premium: </strong> {{= quoteContent.premium }}
    </div>
    {{ } }}
</core:js_template>