<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<jsp:useBean id="productDao" class="com.ctm.web.core.dao.ProductDao" scope="page" />
<jsp:useBean id="familyTypeDao" class="com.ctm.web.health.dao.HealthFamilyTypeDao" scope="page" />

<c:set var="providerId" value="${param.providerId}" />
<c:set var="providerCode" value="${param.providerCode}" />
<c:set var="providerName" value="${param.providerName}" />

<layout_v1:simples_page fullWidth="true">
	<jsp:attribute name="head"></jsp:attribute>
	<jsp:body>
		<div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminProductCappingLimits.refresh" data-providerId="${param.providerId}">
			<div class="container">
				<div class="row">
					<ul>
						<li class="col-lg-3">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.productName,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>Product Name</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.state,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>State</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.healthCvr,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>Family Type</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.limitType,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>Limit Type</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Capping Amount</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Current Progress</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Limit Left</span>
							</a>
						</li>
						<li class="col-lg-2">
							<a href="javascript:;" class="toggle" data-sortkey="data.effectiveStart,data.productName" data-sortdir="asc">
								<span class="icon"></span>
								<span>Effective Start</span>
							</a>
						</li>
						<li class="col-lg-2">
							<a href="javascript:;" class="toggle" data-sortkey="data.effectiveEnd,data.productName" data-sortdir="asc">
								<span class="icon"></span>
								<span>Effective End</span>
							</a>
						</li>
						<li class="col-lg-2">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.category,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>Category</span>
							</a>
						</li>
						<li class="col-lg-1">
							<button type="button" class="crud-new-entry btn btn-secondary btn-sm">Add New Cap</button>
						</li>
					</ul>
				</div>
			</div>
		</div>

		<div id="product-capping-limits-container" class="container sortable-results-container">
			<div class="row">
				<div class="col-sm-12 header">
					<h1>${providerName}  <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="current-cappings-container" class="sortable-results-table"></div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Future <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="future-cappings-container" class="sortable-results-table hidden"></div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Past <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="past-cappings-container" class="sortable-results-table hidden"></div>
				</div>
			</div>

		</div>
	</jsp:body>
</layout_v1:simples_page>

<script>
	var products = [
			{ value: '-1', text: "Select a Product" },
			<c:set var="products" value="${productDao.getProductNames('HEALTH', providerId, true)}" />
			<c:forEach items="${products}" var="product">
			{ value: "${product.getLongTitle()}", text: "${product.getLongTitle()}" },
			</c:forEach>
		];
</script>

<script>
	var familyType = [
			{ value: '-1', text: "Select Family type" },
			{ value: '0', text: "All" },
			<c:set var="familyType" value="${familyTypeDao.getFamilyTypes(false)}" />
			<c:forEach items="${familyType}" var="item">
			{ value: "${item.getCode()}", text: "${item.getDescription()}" },
			</c:forEach>
		];
</script>

<script class="crud-modal-template" type="text/html">
	<div class="row">
		<div class="col-sm-12">
			<br>
			<input type="hidden" name="providerId" value="${providerId}">
			{{ if(data.modalAction === "edit") { }}
				<h1>Edit Record</h1>
				<input type="hidden" name="cappingLimitId" value="{{= data.cappingLimitId }}">
			{{ } else if(data.modalAction === "clone") { }}
				<h1>Clone Record</h1>
			{{ } else { }}
				<h1>New Record</h1>
			{{ } }}
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<ul class="error-list"></ul>
		</div>
	</div>
	<div class="row">

		<%-- TODO productName vs LongTitle  --%>
		<div class="form-group col-sm-4">
			<label>Product Name</label>
			<select name="productName" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
				{{ for(var i in products) { }}
					<option value="{{= products[i].value }}" {{= data.productName === products[i].value ? "selected" : "" }}>{{= products[i].text }}</option>
				{{ } }}
			</select>
		</div>
		<div class="form-group col-sm-4">
			<label>State</label>
			<select name="state" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
				<c:set var="stateOptions" value="=Select a State,0=All,ACT=Australian Capital Territory,NSW=New South Wales,NT=Northern Territory,QLD=Queensland,SA=South Australia,TAS=Tasmania,VIC=Victoria,WA=Western Australia" />
				<c:forTokens items="${stateOptions}" delims="," var="state">
					<c:set var="val" value="${fn:substringBefore(state,'=')}" />
					<c:set var="des" value="${fn:substringAfter(state,'=')}" />
					<option value="${val}" {{= "${val}" === data.state ? "selected" : "" }}>${des}</option>
				</c:forTokens>
			</select>
		</div>
		<div class="form-group col-sm-4">
			<label>Family Type</label>
			<select name="healthCvr" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
				{{ for(var i in familyType) { }}
					<option value="{{= familyType[i].value }}" {{= data.healthCvr === familyType[i].value ? "selected" : "" }}>{{= familyType[i].text }}</option>
				{{ } }}
			</select>
		</div>
	</div>
	<div class="row">
		<div class="form-group col-sm-4">
			<label>Limit Type</label>
			<select name="limitType" class="form-control" id="modal-limit-type" {{= data.modalAction === "edit" ? "disabled" : "" }}>
				<option>Select a Limit Type</option>
				<option value="Daily" {{= data.limitType === "Daily" ? "selected" : "" }}>Daily</option>
				<option value="Monthly" {{= data.limitType === "Monthly" ? "selected" : "" }}>Monthly</option>
			</select>
		</div>
		<div class="form-group col-sm-4">
			<label>Capping Amount</label>
			<input type="number" class="form-control" name="cappingAmount" value="{{= data.cappingAmount }}">
		</div>
		<div class="form-group col-sm-4">
			<label>Category</label>
			<select name="cappingLimitCategory" class="form-control" id="modal-category">
				<option>Select a Category</option>
				<option value="S" {{= data.cappingLimitCategory === "S" ? "selected" : "" }}>Soft</option>
				<option value="H" {{= data.cappingLimitCategory === "H" ? "selected" : "" }}>Hard</option>
			</select>
		</div>
	</div>
	<div class="row">
		<div class="form-group col-sm-4">
			<label>Effective Start</label>
			<input type="date" name="effectiveStart" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveStart : "" }}">
		</div>
		<div class="form-group col-sm-4">
			<label>Effective End</label>
			<input type="date" name="effectiveEnd" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveEnd : "" }}">
		</div>
	</div>
	<div class="form-group">
		<button type="button" class="crud-save-entry btn btn-secondary">Save</button>
	</div>
</script>

<script class="crud-row-template" type="text/html">
	<div class="sortable-results-row row" data-id="{{= data.cappingLimitId }}"> <%--  data-id="{{= data.cappingLimitId }}    data-id="{{= data.cappingLimitsKey }} --%>
		<div class="col-lg-3">
			{{= data.productName }}
		</div>
		<div class="col-lg-1">
			{{= data.state }}
		</div>
		<div class="col-lg-1">
			{{= data.healthCvr }}
		</div>
		<div class="col-lg-1">
			{{= data.limitType }}
		</div>
		<div class="col-lg-1">
			{{= data.cappingAmount }}
		</div>
		<div class="col-lg-1">
			{{= data.currentJoinCount }}
		</div>
		<div class="col-lg-1">
			{{= data.limitLeft }}
		</div>
		<div class="col-lg-2">
			{{= new Date(data.effectiveStart).toLocaleDateString('en-GB') }}
		</div>
		<div class="col-lg-2">
			{{= new Date(data.effectiveEnd).toLocaleDateString('en-GB') }}
		</div>
		<div class="col-lg-2">
			{{= data.category }}
		</div>
		<div class="col-lg-1">
			<button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>
			{{ if(data.type === "current" || data.type === "future"){ }}
				<button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
				<button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
			{{ } }}
		</div>
	</div>
</script>