<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:set var="logger" value="${log:getLogger('jsp.simples.admin.reward')}" />

<session:getAuthenticated />

<c:choose>
    <c:when test="${empty isRoleCcRewards or !isRoleCcRewards}">
        <%@ include file="/security/simples_noaccess.jsp" %>
    </c:when>
    <c:otherwise>

        <layout_v1:simples_page fullWidth="true">
            <jsp:attribute name="head"></jsp:attribute>
            <jsp:body>

                <div id="simples-reward-search-bar" class="row simples-reward">
                    <div class="col-sm-8">
                        <div class="simples-reward-buttons">
                            <form id="simples-reward-search-navbar" class="navbar-form text-center" role="search">
                                <div class="form-group">
                                    <input type="text" name="keywords" class="form-control input-lg" />
                                </div>
                                <button type="submit" class="btn btn-default btn-lg">Search Orders</button>
                            </form>
                            <a href="javascript:;" class="btn btn-form btn-lg crud-new-entry">Ad Hoc Order <span class="icon icon-arrow-right"></span></a>
                        </div>
                    </div>
                </div>

                <div id="simples-reward-details-container" class="hidden">
                    <div class="sortable-header data-sorter container-fluid navbar-affix" data-affix-after="#simples-reward-search-bar">
                        <div class="container">
                            <div class="row">
                                <ul>
                                    <%--<li class="col-lg-1">--%>
                                        <%--<a href="javascript:;">--%>
                                            <%--<span class="icon"></span>--%>
                                            <%--<span>Transaction Id</span>--%>
                                        <%--</a>--%>
                                    <%--</li>--%>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Root Id</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Reward Selected</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Name</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-2">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Shipping Address</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-2">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Email Address</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Phone Number</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Order Status</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Sale Status</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <a href="javascript:;">
                                            <span class="icon"></span>
                                            <span>Date to Issue</span>
                                        </a>
                                    </li>
                                    <li class="col-lg-1">
                                        <button type="button" class="crud-new-entry btn btn-secondary btn-sm">Ad Hoc Order</button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="container sortable-results-container">
                        <div class="row">
                            <div class="col-sm-12 header">
                                <h1>Order Status Summary <small></small></h1>
                                <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
                            </div>
                            <div class="col-sm-12">
                                <div id="current-reward-container" class="sortable-results-table"></div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 header">
                                <h1>History <small></small></h1>
                                <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
                            </div>
                            <div class="col-sm-12">
                                <div id="past-reward-container" class="sortable-results-table hidden"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </jsp:body>
        </layout_v1:simples_page>

        <script class="crud-modal-template" type="text/html">
            <reward:redemption_form isSimplesAdmin="true" />
        </script>

        <script class="crud-row-template" type="text/html">
            {{ var orderHeader = data.orderForm.orderHeader }}
            {{ var orderLine= orderHeader.orderLine || {} }}
            {{ var reward = orderLine.rewardType || {} }}

            <div class="sortable-results-row row" data-id="{{= orderLine.encryptedOrderLineId }}">
                <div class="col-lg-1">
                    {{= orderHeader.rootId }}
                </div>
                <div class="col-lg-1">
                    {{= reward.rewardType }}
                </div>
                <div class="col-lg-1">
                    {{= orderLine.firstName }} {{= orderLine.lastName }}
                </div>
                <div class="col-lg-2">
                    {{var shippingAddress = orderLine.orderAddresses.length > 0 ? orderLine.orderAddresses.filter(function(address){ }}
                        {{ return address.addressType === 'P' }}
                    {{ })[0].fullAddress : '' }}

                    {{= shippingAddress }}
                </div>
                <div class="col-lg-2">
                    {{= orderLine.contactEmail }}
                </div>
                <div class="col-lg-1">
                    {{= orderLine.phoneNumber }}
                </div>
                <div class="col-lg-1">
                    {{= orderLine.orderStatus }}
                    {{ if (orderLine.orderStatus === 'Dispatched' && orderLine.trackingCode !== null) { }}
                        <br />
                        {{= orderLine.trackingCode }}
                    {{ } }}
                </div>
                <div class="col-lg-1">
                    {{= orderHeader.saleStatus }}
                </div>
                <div class="col-lg-1">
                    {{= orderLine.dateToIssue }}
                </div>
                <div class="col-lg-1">
                    {{ if(data.type === "current" && ['Requisitioned', 'Dispatched', 'Cancelled', 'Declined'].indexOf(orderLine.orderStatus) < 0){ }}
                    <button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
                    <button type="button" class="crud-cancel-entry btn btn-primary btn-sm">Cancel</button>
                    {{ } }}
                </div>
            </div>
        </script>

    </c:otherwise>
</c:choose>