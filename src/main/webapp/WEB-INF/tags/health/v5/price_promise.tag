<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Price promise iframe widget"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="step" required="true" rtexprvalue="true" description="Journey Step" %>
<%@ attribute name="dismissible" required="false" rtexprvalue="true" description="Is the price promise dismissible" %>

<c:set var="iframeUrl"><content:get key="pricePromiseURL"/></c:set>

<c:if test="${pageSettings.getSetting('pricePromiseEnabled') eq 'Y'}">
    <div class="price-promise-container" data-dismissible="${dismissible}">
        <c:if test="${dismissible}">
            <div class="price-promise-close">
                <span class="icon icon-cross"></span>
            </div>
        </c:if>
        <div class="price-promise-banner">
            <div class="content">
                <table>
                    <tr class="hidden-md hidden-lg">
                        <td colspan="2" class="img"><div class="landscape" /></td>
                    </tr>
                    <tr>
                        <td class="img hidden-xs hidden-sm"><div class="portrait" /></td>
                        <td class="copy">
                            <h3>We don’t markup prices. Ever.</h3>
                            <p>If you find the same policy for a cheaper price, and buy that same policy through us, we’ll give you 110% of the difference for the first year.&nbsp;&nbsp;<a href="/wp-content/uploads/2018/04/Best-Price-Promise-terms-and-conditions.pdf" target="_blank">T&amp;C's apply</a></p>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

    </div>
</c:if>
