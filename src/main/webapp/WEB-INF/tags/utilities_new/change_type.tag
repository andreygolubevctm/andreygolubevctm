<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="change-type-template">

    <div class="change-type-modal">
        <div class="modal-closebar">
            <a href="javascript:;" class="btn btn-close-dialog btn-close-more-info"><span
                    class="icon icon-cross"></span></a>
        </div>
        <div class="row">
            <div class="col-xs-12 col-md-8 paragraphedContent">
                <p>Select the energy type to quote:</p>

                <c:set var="fieldXPath" value="utilities/results/whatToCompareReset" />
                    <field_new:array_radio xpath="${fieldXPath}"
                                           required="true"
                                           className="what-to-compare-reset"
                                           items="E=<i class='energy-electricity'></i>Electricity,G=<i class='energy-gas'></i>Gas,EG=<i class='energy-combined'></i>Electricity and Gas"
                                           id="${go:nameFromXpath(fieldXPath)}"
                                           title="which energies to compare." />
            </div>
        </div>
    </div>
</core:js_template>