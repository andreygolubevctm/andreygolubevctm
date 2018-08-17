<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>
 
<layout_v1:simples_page fullWidth="true">
	<jsp:attribute name="head"></jsp:attribute>
	<jsp:body>
		<div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminFundProductCappingSummary.refresh">
			<div class="container">
				<div class="row">
					<ul>
						<li class="col-lg-6">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.providerName" data-sortdir="asc">
								<span class="icon"></span>
								<span>Provider</span>
							</a>
						</li>
						<li class="col-lg-5">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Active Caps</span>
							</a>
						</li>
						<li class="col-lg-1">
							&nbsp;
						</li>
					</ul>
				</div>
			</div>
		</div>
	
		<div id="fund-product-capping-summary-container" class="container sortable-results-container">
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Product Capping Summary</h1>
				</div>
				<div class="col-sm-12">
					<div id="product-capping-summary-container" class="sortable-results-table"></div>
				</div>
			</div>
		</div>
	</jsp:body>
</layout_v1:simples_page>

<script class="crud-row-template" type="text/html">
	<div class="sortable-results-row row" data-id="{{= data.providerCode }}">
		<div class="col-lg-6">
			{{= data.providerName }}
			<input type="hidden" name="providerId" value="{{= data.providerId }}">
			<input type="hidden" name="providerCode" value="{{= data.providerCode }}">
			<input type="hidden" name="providerName" value="{{= data.providerName }}">
		</div>
		<div class="col-lg-5">
			{{= data.currentProductCapCount }}
		</div>
		<div class="col-lg-1">
			<a target="simplesiframe" href="product_capping_limits.jsp?providerId={{= data.providerId }}&providerCode={{= data.providerCode }}&providerName={{= data.providerName }}" class="btn btn-secondary btn-sm">Open</a>
		</div>
	</div>
</script>