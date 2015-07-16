<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-homeloan-template">

    <h5>Home Loan Quote</h5>

    {{ if(obj.details.location) { }}
    <div class="quote-detail">
        <strong>Live in: </strong> {{= obj.details.location }}
    </div>
    {{ } }}

    {{ if(obj.details.situation) { }}
    <div class="quote-detail">
        <strong>Situation: </strong> {{= meerkat.modules.retrievequotesListQuotes.getHomeloanSituation(obj.details.situation) }}
    </div>
    {{ } }}

    {{ if(obj.details.goal) { }}
    <div class="quote-detail">
        <strong>Goal: </strong> {{= meerkat.modules.retrievequotesListQuotes.getHomeloanGoal(obj.details.goal) }}
    </div>
    {{ } }}

    {{ if(obj.loanDetails) { }}
    <div class="quote-detail">
        <strong>Purchase Price: </strong> {{= obj.loanDetails.purchasePriceentry }}
    </div>
    {{ } }}

    {{ if(obj.loanDetails) { }}
    <div class="quote-detail">
        <strong>Loan Amount: </strong> {{= obj.loanDetails.loanAmountentry }}
    </div>
    {{ } }}
</core:js_template>