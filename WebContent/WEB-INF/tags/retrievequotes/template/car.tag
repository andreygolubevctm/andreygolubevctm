<%@ tag description="Vertical Specific Template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="retrieve-car-template">

    <%-- Start fromDisc check --%>
    {{ if(obj.fromDisc == false) { }}

        {{ var vehicleDetails = typeof obj.vehicle !== 'undefined' ? obj.vehicle : {} }}
        {{ var regularDriver = typeof obj.drivers !== 'undefined' && typeof obj.drivers.regular !== 'undefined' ? obj.drivers.regular : {} }}
        {{ var youngDriver = typeof obj.drivers !== 'undefined' && typeof obj.drivers.young !== 'undefined' ? obj.drivers.young : {} }}

        <h5>{{= vehicleDetails.makeDes }} {{= vehicleDetails.model }} {{= vehicleDetails.year }}</h5>

        {{ if(typeof regularDriver.firstname != 'undefined' && typeof regularDriver.surname != 'undefined') { }}
        <div class="quote-detail">
            <strong>Regular Driver: </strong> {{= regularDriver.firstname }} {{= regularDriver.surname }}
            ({{= meerkat.modules.utils.returnAge(regularDriver.dob, true) }} y/o {{= meerkat.modules.retrievequotesListQuotes.getGenderString(regularDriver.gender) }})
        </div>
        {{ } }}

        {{ if(youngDriver.exists == "Y") { }}
        <div class="quote-detail">
            <strong>Youngest Driver: </strong> {{= meerkat.modules.utils.returnAge(youngDriver.dob, true) }} y/o {{= meerkat.modules.retrievequotesListQuotes.getGenderString(youngDriver.gender) }}
        </div>
        {{ } }}

        {{ var noClaimsDiscount = meerkat.modules.retrievequotesListQuotes.carFormatNcd(regularDriver.ncd); }}
        {{ if(noClaimsDiscount.length) { }}
        <div class="quote-detail">
            <strong>No Claims Discount: </strong> {{= noClaimsDiscount }}
        </div>
        {{ } }}

    {{ } }} <%-- End fromDisc check --%>
</core:js_template>