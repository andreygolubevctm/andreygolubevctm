<%@ tag description="Simples Confirm all data is correct - confirm details of others"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ if (obj.partner || obj.dependants) { }}

<%-- TODO CHANGE THE CSS CLASSES below --%>
    <div class="agr-others-details-section agr-details-section">
        <h3>Please confirm the details of others on this policy</h3>

        <health_v2_confirmation:edit_details_btn />

        <div class="row">

            {{ if (obj.partner) { }}
                <div class="col-xs-12 col-sm-6">
                    {{ obj.partner.forEach(function(field, index) { }}
                        <form_v4:row label="{{= field.label }}">
                            {{= field.value }}
                        </form_v4:row>

                        {{ if (index === 3) { }}
                            <hr />
                        {{ } }}
                    {{ }); }}
                </div>
            {{ } }}

            {{ if (obj.dependants) { }}
                {{ obj.dependants.forEach(function(dependant) { }}
                    <div class="col-xs-12 col-sm-6">
                        {{ dependant.forEach(function(field, index) { }}
                            <form_v4:row label="{{= field.label }}">
                                {{= field.value }}
                            </form_v4:row>

                            {{ if (index === 3) { }}
                                <hr />
                            {{ } }}
                        {{ }); }}
                    </div>
                {{ }); }}
            {{ } }}
        </div>
    </div>
{{ } }}