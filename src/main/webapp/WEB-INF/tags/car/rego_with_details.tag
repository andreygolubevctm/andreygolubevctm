<%@ tag description="Details of your Car with Rego" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<form_v2:fieldset legend="Details of Your Car" id="RegoFieldSet">
    <div class="row quoteSnapshot snapshot">
        <div class="hidden-xs hidden-sm hidden-md col-lg-2"><span class="icon icon-car"></span></div>
        <div class="col-xs-8 col-lg-6">
            <div class="vehicle-details-title"><span data-source="#quote_vehicle_make"></span> <span data-source="#quote_vehicle_model"></span></div>
            <ul class="rego-car-details-row">

                <li><span data-source="#quote_vehicle_year"></span></li>
                <li><span data-source="#quote_vehicle_colour"></span></li>
                <li><span data-source="#quote_vehicle_body"></span></li>
                <li><span data-source="#quote_vehicle_trans"></span></li>
                <li><span data-source="#quote_vehicle_fuel"></span></li>
            </ul>
            <div class="clearfix"></div>
            <ul class="rego-car-details-row">
                <li>
                    <span data-source="#quote_vehicle_redbookCode"></span>
                </li>
            </ul>
        </div>
        <div class="col-xs-4 col-lg-4 text-right">
            <p class="rego-text invisible">
                <span class="sessioncamhidetext" data-source="meerkat.site.vehicleSelectionDefaults.searchRego" data-type="object">&nbsp;</span>
            </p>
            <a href="javascript:;" data-slide-control="previous" class="small text-warning rego-not-my-car" title="Enter your car's details instead">this is not my car</a>
        </div>
    </div>

</form_v2:fieldset>
