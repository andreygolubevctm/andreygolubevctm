<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<c:set var="logger" value="${log:getLogger('jsp.simples.admin.redemption')}" />

<session:getAuthenticated />

<layout_v1:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

    <jsp:body>

        <div class="row simples-redemption">
            <div class="col-sm-8">
                <div class="simples-redemption-buttons">
                    <form id="simples-redemption-search-navbar" class="navbar-form text-center" role="search">
                        <div class="form-group">
                            <input type="text" name="keywords" class="form-control input-lg" />
                        </div>
                        <button type="submit" class="btn btn-default btn-lg">Search Redemption</button>
                    </form>
                    <a href="javascript:;" class="btn btn-form btn-lg crud-new-entry">Ad Hoc Redemption <span class="icon icon-arrow-right"></span></a>
                </div>
            </div>
        </div>

        <div id="simples-redemption-details-container" class="hidden">
            <div class="sortable-header data-sorter container-fluid">
                <div class="container">
                    <div class="row">
                        <ul>
                            <li class="col-lg-1">
                                <a href="javascript:;">
                                    <span class="icon"></span>
                                    <span>Transaction Id</span>
                                </a>
                            </li>
                            <li class="col-lg-1">
                                <a href="javascript:;">
                                    <span class="icon"></span>
                                    <span>Root Id</span>
                                </a>
                            </li>
                            <li class="col-lg-1">
                                <a href="javascript:;">
                                    <span class="icon"></span>
                                    <span>Order Name</span>
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
                            <li class="col-lg-2">
                                <a href="javascript:;">
                                    <span class="icon"></span>
                                    <span>Order Status</span>
                                </a>
                            </li>
                            <li class="col-lg-2">
                                <button type="button" class="crud-new-entry btn btn-secondary btn-sm">Ad Hoc Redemption</button>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="container sortable-results-container">
                <div class="row">
                    <div class="col-sm-12 header">
                        <h1>Redemption Status Summary <small></small></h1>
                        <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
                    </div>
                    <div class="col-sm-12">
                        <div id="current-redemption-container" class="sortable-results-table"></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 header">
                        <h1>History <small></small></h1>
                        <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
                    </div>
                    <div class="col-sm-12">
                        <div id="past-redemption-container" class="sortable-results-table hidden"></div>
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
    <div class="sortable-results-row row" data-id="{{= data.cappingLimitsKey }}">
        <div class="col-lg-2">
            {{= data.rootId }}
        </div>
        <div class="col-lg-2">
            {{= data.orderName }}
        </div>
        <div class="col-lg-1">
            {{= data.address }}
        </div>
        <div class="col-lg-1">
            {{= data.email }}
        </div>
        <div class="col-lg-1">
            {{= data.phone }}
        </div>
        <div class="col-lg-1">
            {{= data.status }}
        </div>
        <div class="col-lg-1">
            {{= data.daysTillDispatch }}
        </div>
        <div class="col-lg-1">
            {{= data.dispatchDate }}
        </div>
        <div class="col-lg-2">
            {{ if(data.type === "current"){ }}
            <button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
            <button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
            {{ } }}
        </div>
    </div>
</script>
