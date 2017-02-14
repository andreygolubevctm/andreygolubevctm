<%@ tag description="The Health Journey's 'Application Details' Slide" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<layout_v3:slide formId="applicationDetailsForm" nextLabel="Proceed to Payment">

    <layout_v3:slide_content>
        <form_v3:fieldset_columns sideHidden="true">

            <jsp:attribute name="rightColumn">
			    <health_v4_payment:policySummary showProductDetails="true" />
            </jsp:attribute>

            <jsp:body>
                <health_v1:dual_pricing_settings />

                <%-- Product summary header for mobile --%>
                <div class="row productSummary-parent <c:choose><c:when test="${isDualPriceActive eq true}">hidden</c:when><c:otherwise>visible-xs</c:otherwise></c:choose>">
                    <div class="productSummary-affix affix-top visible-xs">
                        <health_v4_payment:policySummary />
                    </div>
                </div>

                <div id="health_application-warning">
                    <div class="fundWarning alert alert-danger">
                            <%-- insert fund warning data --%>
                    </div>
                </div>

                <health_v4_application:your_details />
                <health_v4_application:partner_details />
                <health_v4_application:dependants xpath="${pageSettings.getVerticalCode()}/application/dependants" />
            </jsp:body>
        </form_v3:fieldset_columns>

    </layout_v3:slide_content>

</layout_v3:slide>