<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-health-template">

    {{ var situationDetail = typeof obj.situation != 'undefined' ? obj.situation : {}; }}
    {{ var healthCoverDetails = typeof obj.healthCover != 'undefined' ? obj.healthCover : {}; }}

    <h5>Health Insurance Quote {{= obj.id ? "#" + obj.id : "" }}</h5>

    {{ if(situationDetail.healthCvr && situationDetail.healthSitu) { }}
    <div class="quote-detail">
        <strong>Situation: </strong> {{= obj.situation.healthCvr }} - {{= obj.situation.healthSitu }}
    </div>
    {{ } }}
    {{ if(obj.benefits) { }}
    <div class="quote-detail">
        <strong>Benefits: </strong> {{= meerkat.modules.retrievequotesListQuotes.healthBenefitsList(obj.benefits) }}
    </div>
    {{ } }}
    {{ if(healthCoverDetails.dependants && healthCoverDetails.dependants != '') { }}
    <div class="quote-detail">
        <strong>Dependants: </strong> {{= healthCoverDetails.dependants }}
    </div>
    {{ } }}
    {{ if(healthCoverDetails.incomelabel) { }}
    <div class="quote-detail">
        <strong>Income: </strong> {{= healthCoverDetails.incomelabel }}
    </div>
    {{ } }}
</core:js_template>