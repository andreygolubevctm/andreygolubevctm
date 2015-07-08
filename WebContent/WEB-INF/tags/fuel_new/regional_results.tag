<%@ tag description="Fuel Location" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="regional-results-template">

    {{ var general = Results.getReturnedGeneral(); }}
    {{ var hasSecondFuel = general.fuel2Text.length; }}
    {{ var numberOfCols = hasSecondFuel ? 3 : 4; }}
    <%-- Header --%>
    <div class="row headerBar">
        <div class="col-xs-12">
            <p>Unfortunately we do not have prices for individual service stations for your area.</p>

            <p>The prices displayed below are <strong>yesterday's average fuel prices</strong> for some regional cities in your state.</p>
        </div>
    </div>
    <%-- Benefits --%>
    <div class="row">
        <div class="col-xs-12">
            <table class="regionalFuelContainer">
                <tr>
                    <th class="col-xs-{{= numberOfCols }}">City</th>
                    <th class="col-xs-{{= numberOfCols }}">{{= general.fuel1Text }}</th>
                    {{ if(hasSecondFuel) { }}
                        <th class="col-xs-{{= numberOfCols }}">{{= general.fuel2Text }}</th>
                    {{ } }}
                    <th class="col-xs-{{= numberOfCols }}">Collected</th>
                </tr>
                {{ for(var i = 0; i < obj.length; i++) { }}
                {{ var fuelPrice = obj[i]; }}
                <tr>
                    <td>{{= fuelPrice.city }}</td>
                    <td>
                        {{ if(fuelPrice.priceText == "") { }}
                            <span class="small">Unavailable</span>
                        {{ } else { }}
                            <span class="price">{{= fuelPrice.priceText }}</span>
                        {{ } }}
                    </td>
                    {{ if(hasSecondFuel) { }}
                    <td>
                        {{ if(fuelPrice.price2Text == "") { }}
                            <span class="small">Unavailable</span>
                        {{ } else { }}
                            <span class="price">{{= fuelPrice.price2Text }}</span>
                        {{ } }}
                    </td>
                    {{ } }}
                    <td>
                        {{= fuelPrice.created }}
                    </td>
                </tr>
                {{ } }}
            </table>
        </div>
    </div>
    <div class="row">
        <div class="col-xs-12">
            <p class="small">Data supplied by Motormouth</p>
        </div>
    </div>

</core:js_template>