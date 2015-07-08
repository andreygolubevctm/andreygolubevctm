<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="more-info-template">

    {{ var template = $("#provider-logo-template").html(); }}
    {{ var companyLogo = _.template(template); }}
    {{ companyLogo = companyLogo(obj); }}

    <div class="displayNone more-info-content">
            <%-- Header --%>
        <div class="row headerBar">
            <div class="col-xs-12 col-sm-9">
                <div class="col-xs-3 col-sm-2 logoContainer">{{= companyLogo }}</div>
                <div class="col-xs-9 col-sm-7 verticalCenterContainer"><h2>{{= obj.des.replace('<br>',' ') }}</h2></div>
                <div class="col-xs-4 col-sm-3 priceColumn">
                    <h2 class="price">{{= obj.priceText }}</h2>
                    <div class="small-heading">Per Year</div>
                </div>
            </div>
            <div class="col-xs-12 col-sm-3 verticalCenterContainer">
                <a href="javascript:;" class="btn btn-cta btn-block btn-apply" data-productid="{{= obj.productId }}">
                    Continue Online</a>
            </div>
        </div>
            <%-- Benefits --%>
        <div class="row">
            <div class="col-xs-12">
                <table class="benefitsContainer">
                    {{ $.each(obj.sortOrder, function(index, tag){ }}
                    {{ if((typeof obj.info[tag[1]] === 'object') && obj.info[tag[1]].value && obj.info[tag[1]].value > 0 ) { }}
                    <tr>
                        <td class="col-xs-7 col-sm-6">{{= obj.info[tag[1]].desc }}</td>
                        <td class=" col-xs-5 col-sm-6">{{= obj.info[tag[1]].text }}</td>
                    </tr>
                    {{ } }}
                    {{ }); }}
                </table>
            </div>
        </div>
            <%-- Terms Link --%>
        <div class="row">
            <div class="col-xs-12 col-sm-6 col-sm-offset-3 ">
                <a href="{{= obj.termsLink }}" target="_blank" class="showDoc btn btn-block btn-download terms-btn"> Terms &amp; Conditions</a>
            </div>
        </div>
            <%-- About Provider --%>
        <div class="row about">
            <div class="col-xs-12">
                <p>{{= obj.infoDes}}</p>
            </div>
        </div>
    </div>
</core:js_template>

