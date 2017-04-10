<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<div class="payment-frequency-buttons hidden">
    <div class="row">
        <div class="col-xs-8 col-xs-offset-2">
            <form_v2:row label="PAYMENT FREQUENCY" hideHelpIconCol="true">
                <field_v2:array_radio xpath="${xpath}" required="true"
                                      className="" items="monthly=Monthly,annual=Annual"
                                      id="${name}" title="" />
            </form_v2:row>
        </div>
    </div>
</div>