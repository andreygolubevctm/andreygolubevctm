<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="emailPlaceHolder">
    <content:get key="emailPlaceHolder"/>
</c:set>

<script id="emailBrochuresTemplate" type="text/html">
    <form id="emailBrochuresForm" autocomplete="off" class="form-horizontal emailBrochuresForm" role="form" novalidate="novalidate">
        <div class="policyBrochures row">
            <div class="col-xs-12">
                <h2>Policy brochures</h2>
                <p>See your policy brochure{{= hospital && typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }} below for the full guide on policy limits, inclusions and exclusions</p>
            </div>
            <div class="col-xs-12 moreInfoEmailBrochures" novalidate="novalidate">

                <div class="row formInput">
                    <div class="col-sm-3 col-xs-12 ">
                        <p class="pbLabel">Your email address</p>
                    </div>
                    <div class="col-sm-5 col-xs-12">
                        <field_v2:email xpath="emailAddress"  required="true"
                                        className="sendBrochureEmailAddress"
                                        placeHolder="${emailPlaceHolder}" />
                    </div>
                    <div class="col-sm-4 hidden-xs">
                        <a href="javascript:;" class="btn btn-save disabled btn-email-brochure" <field_v1:analytics_attr analVal="email button" quoteChar="\"" />>Email Brochure{{= hospital && typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' && promo.hospitalPDF != promo.extrasPDF ? "s" : "" }}</a>
                    </div>
                </div>
                <div class="row row-content formInput optInMarketingRow">
                    <div class="col-sm-push-3 col-xs-12">
                        <field_v2:checkbox className="optInMarketing checkbox-custom"
                                           xpath="health/sendBrochures/optInMarketing" required="false"
                                           value="Y" label="true"
                                           title="Stay up to date with news and offers direct to your inbox" />
                    </div>
                </div>

                <div class="row row-content formInput hidden-sm hidden-md hidden-lg emailBrochureButtonRow">
                    <div class="col-xs-12">
                        <a href="javascript:;" class="btn btn-save disabled btn-email-brochure" <field_v1:analytics_attr analVal="email button" quoteChar="\"" />>Email Brochure{{= hospital && typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s" : "" }}</a>
                    </div>
                </div>
                <div class="row row-content moreInfoEmailBrochuresSuccess hidden">
                    <div class="col-xs-12">
                        <div class="success alert alert-success">
                            Success! Your policy brochure{{= hospital && hospitalCover && typeof hospitalCover !== 'undefined' &&  typeof extrasCover !== 'undefined' ? "s have" : " has" }} been emailed to you.
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </form>
</script>