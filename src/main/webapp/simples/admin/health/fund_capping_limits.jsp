<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>
 
 <jsp:useBean id="providerDao" class="com.ctm.web.core.dao.ProviderDao" scope="page" />
 
<layout_v1:simples_page fullWidth="true">
	<jsp:attribute name="head"></jsp:attribute>
	<jsp:body>
		<div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminFundCappingLimits.refresh">
			<div class="container">
				<div class="row">
					<ul>
						<li class="col-lg-<c:if test="${isRoleElevatedSupervisor ne true}">4</c:if><c:if test="${isRoleElevatedSupervisor}">2</c:if>">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.providerName,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>Provider</span>
							</a>
						</li>
						<li class="col-lg-2">
							<a href="javascript:;">
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
						<li class="col-lg-1">
							<a href="javascript:;" class="toggle" data-sortkey="data.effectiveStart,data.providerName" data-sortdir="asc">
								<span class="icon"></span>
								<span>Effective Start</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Effective End</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Category</span>
							</a>
						</li>
						<c:if test="${isRoleElevatedSupervisor}">
						<li class="col-lg-2">
							<button type="button" class="crud-new-entry btn btn-secondary btn-sm">Add New Cap</button>
						</li>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	
		<div id="fund-capping-limits-container" class="container sortable-results-container">
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Fund Capping Limits <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="current-cappings-container" class="sortable-results-table"></div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 header">
					<h1>History <small></small></h1>
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
	var providers = [
			{ value: '-1', text: "Select a Provider" },
			<c:set var="providers" value="${providerDao.getProviders('HEALTH', 0, true)}" />
			<c:forEach items="${providers}" var="provider">
			{ value: ${provider.getId()}, text: "${provider.getName()}" },
			</c:forEach>
		];
</script>

<script class="crud-modal-template" type="text/html">
	<div class="row">
		<div class="col-sm-12">
			<br>
			{{ if(data.modalAction === "edit") { }}
				<h1>Edit Record</h1>
				<input type="hidden" name="providerId" value="{{= data.providerId }}">
				<input type="hidden" name="sequenceNo" value="{{= data.sequenceNo }}">
				<input type="hidden" name="status" value="{{= data.status }}">
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
		<div class="form-group col-sm-4">
			<label>Provider</label>
			<select name="providerId" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
				{{ for(var i in providers) { }}
					<option value="{{= providers[i].value }}" {{= data.providerId === providers[i].value ? "selected" : "" }}>{{= providers[i].text }}</option>
				{{ } }}
			</select>
		</div>
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
	</div>
	<div class="row">
		<div class="form-group col-sm-4">
			<label>Category</label>
			<select name="cappingLimitCategory" class="form-control" id="modal-category">
				<option>Select a Category</option>
				<option value="S" {{= data.cappingLimitCategory === "S" ? "selected" : "" }}>Soft</option>
				<option value="H" {{= data.cappingLimitCategory === "H" ? "selected" : "" }}>Hard</option>
			</select>
		</div>
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
	<div class="sortable-results-row row" data-id="{{= data.cappingLimitsKey }}">
		<div class="col-lg-<c:if test="${isRoleElevatedSupervisor ne true}">4</c:if><c:if test="${isRoleElevatedSupervisor}">2</c:if>">
			{{= data.providerName }}
		</div>
		<div class="col-lg-2">
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
		<div class="col-lg-1">
			{{= new Date(data.effectiveStart).toLocaleDateString('en-GB') }}
		</div>
		<div class="col-lg-1">
			{{= new Date(data.effectiveEnd).toLocaleDateString('en-GB') }}
		</div>
		<div class="col-lg-1">
			{{= data.category }}
		</div>
		<c:if test="${isRoleElevatedSupervisor}">
		<div class="col-lg-2">
			<button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>
			{{ if(data.type === "current"){ }}
				<button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
				<button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
			{{ } }}
		</div>
		</c:if>
	</div>
</script>