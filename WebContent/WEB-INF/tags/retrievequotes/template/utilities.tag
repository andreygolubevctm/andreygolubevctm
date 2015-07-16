<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-utilities-template">
    <h5>Utilities Quote</h5>

    {{ if(obj.householdDetails) { }}
        {{ if(obj.householdDetails.location) { }}
            <div class="quote-detail">
                <strong>Location: </strong> {{= obj.householdDetails.location }}
            </div>
        {{ } }}

        {{ if(obj.householdDetails.whatToCompare) { }}
            <div class="quote-detail">
                <strong>Comparing: </strong>
                    {{ var compare = obj.householdDetails.whatToCompare; }}
                    {{ if(compare === "E") { }}
                        Electricity
                    {{ } else if(compare === "G") { }}
                        Gas
                    {{ } else if(compare === "EG") { }}
                        Electricity &amp; Gas
                    {{ } }}
            </div>
        {{ } }}
    {{ } }}
</core:js_template>