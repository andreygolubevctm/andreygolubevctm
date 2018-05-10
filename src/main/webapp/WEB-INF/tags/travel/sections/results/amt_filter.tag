<%@ tag description="" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="col-xs-6 text-right">Destinations</div>
<div class="col-xs-6 drop-down-filter">
    <div class="dropdown">
        <a type="button" id="amtFilterDropdownBtn" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="filter-excess-value">
                <c:choose>
                    <c:when test="${data.travel.lastCoverTabLevel eq 'D'}">
                        Domestic
                    </c:when>
                    <c:otherwise>
                        International
                    </c:otherwise>
                </c:choose>
            </span>
            <i class="icon icon-angle-down"></i>
        </a>
        <div class="dropdown-menu dropdown-menu-excess-filter" aria-labelledby="amtFilterDropdownBtn">
            <div class="dropdown-item">
                <div class="radio">
                    <input type="radio" name="amt-toggle" id="travel_filter_international" class="radioButton-custom radio" data-label="International" value="I" <c:if test="${data.travel.lastCoverTabLevel ne 'D'}"> checked</c:if>>
                    <label for="travel_filter_international">International</label>
                </div>
            </div>
            <div class="dropdown-item">
                <div class="radio">
                    <input type="radio" name="amt-toggle" id="travel_filter_domestic" class="radioButton-custom radio" data-label="Domestic" value="D" <c:if test="${data.travel.lastCoverTabLevel eq 'D'}"> checked</c:if>>
                    <label for="travel_filter_domestic">Domestic</label>
                </div>
            </div>
        </div>
    </div>
</div>