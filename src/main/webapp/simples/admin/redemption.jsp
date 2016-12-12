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

        <div class="row">
            <div class="col-sm-8 simples-redemption">
                <div class="simples-redemption-buttons">
                    <form id="simples-redemption-search-navbar" class="navbar-form text-center" role="search">
                        <div class="form-group">
                            <input type="text" name="keywords" class="form-control input-lg" />
                        </div>
                        <button type="submit" class="btn btn-default btn-lg">Search Redemption</button>
                    </form>
                    <a href="javascript:;" class="btn btn-form btn-lg message-inbound">Ad Hoc Redemption <span class="icon icon-arrow-right"></span></a>
                </div>
                <div class="simples-redemption-details-container">
                </div>
            </div>
        </div>

    </jsp:body>
</layout_v1:simples_page>
