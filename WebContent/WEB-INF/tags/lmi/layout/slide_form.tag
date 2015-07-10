<%@ tag description="LMI Start Form" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="xpath" value="${pageSettings.getVerticalCode()}"/>
<c:set var="pageUrl">
    <c:choose>
        <c:when test="${xpath eq 'carlmi'}">
            car_quote.jsp
        </c:when>
        <c:otherwise>home_contents_quote.jsp</c:otherwise>
    </c:choose>
</c:set>
<layout:slide formId="startForm" firstSlide="true" nextLabel="Compare Features">

    <layout:slide_columns>
        <jsp:attribute name="rightColumn">
			<ui:bubble variant="info" className="hidden-xs">
                <h4>Compare price</h4>

                <p>We also compare by price. Get a quote from our participating providers.</p>

                <div class="button_footer">
                    <a class="btn btn-cta" href="${pageSettings.getBaseUrl()}${pageUrl}">Get a Quote<span class="icon icon-arrow-right"></span></a>
                </div>
            </ui:bubble>
		</jsp:attribute>

        <jsp:body>
            <ui:bubble variant="chatty">
                <h4>Compare features</h4>

                <p>Simply select the Insurance providers you want to compare products for and start comparing features.
                    <br/>You can choose up to <strong>12 providers</strong> to compare.</p>

                <p>&nbsp;</p>
            </ui:bubble>
        </jsp:body>

    </layout:slide_columns>
    <div class="row brand-selector">
        <layout:slide_content>
            <div class="col-xs-12 col-md-4 brand-compare-price">
                <h2>Brands we compare on price & features</h2>

                <div class="children">
                    <lmi:brand_selections comparePrice="${true}"/>
                </div>
            </div>

            <div class="col-xs-12 col-md-8 brand-compare-features">
                <h2>Brands we compare on features only<br />&nbsp;</h2>

                <div class="children">
                    <lmi:brand_selections comparePrice="${false}"/>
                </div>
            </div>
        </layout:slide_content>
    </div>
</layout:slide>