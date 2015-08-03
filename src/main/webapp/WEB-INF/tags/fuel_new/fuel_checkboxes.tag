<%@ tag description="Fuel Type Selection"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="xpath" %>

<field_new:validatedHiddenField xpath="${xpath}/hidden" required="false" />

<div id="checkboxes-all" class="row">
    <div id="checkboxes-petrol" class="col-sm-4">
        <h6>Unleaded</h6>
        <field_new:checkbox xpath="${xpath}/type/petrol/E10" label="true" value="6" title="E10" required="false" />
        <field_new:checkbox xpath="${xpath}/type/petrol/ULP" label="true" value="2" title="Unleaded" required="false" />
        <field_new:checkbox xpath="${xpath}/type/petrol/PULP" label="true" value="5" title="Premium Unleaded 95" required="false" />
        <field_new:checkbox xpath="${xpath}/type/petrol/PULP98" label="true" value="7" title="Premium Unleaded 98" required="false" />
    </div>
    <div id="checkboxes-diesel" class="col-sm-4">
        <h6>Diesel</h6>
        <field_new:checkbox xpath="${xpath}/type/diesel/D" label="true" value="3" title="Diesel" required="false" />
        <field_new:checkbox xpath="${xpath}/type/diesel/D20" label="true" value="8" title="Bio-Diesel 20" required="false" />
        <field_new:checkbox xpath="${xpath}/type/diesel/PD" label="true" value="9" title="Premium Diesel" required="false" />
    </div>
    <div id="checkboxes-lpg" class="col-sm-4">
        <h6>LPG</h6>
        <field_new:checkbox xpath="${xpath}/type/lpg/LPG" label="true" value="4" title="LPG" required="false" />
    </div>
</div>

<go:script marker="onready">
    $.validator.addMethod("fuelSelected", function(value, element) {
        var $inputs = $("#checkboxes-all").find("input"),
            $checked = $inputs.filter(":checked"),
            isValid = ($checked.length > 0 && $checked.length <= 2);

        $inputs.toggleClass("has-error", !isValid);
        return isValid;
    }, "");
</go:script>

<go:validate selector="${go:nameFromXpath(xpath)}_hidden" rule="fuelSelected" parm="true" message="Please select up to 2 fuels types" />