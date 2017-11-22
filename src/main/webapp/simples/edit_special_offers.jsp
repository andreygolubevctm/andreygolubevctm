<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<jsp:useBean id="providerDao" class="com.ctm.web.core.dao.ProviderDao" scope="page" />
<jsp:useBean id="brandsDao" class="com.ctm.web.core.dao.BrandsDao" scope="page" />

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />

<layout_v1:simples_page fullWidth="true">
	<jsp:attribute name="head">
	</jsp:attribute>
	<jsp:attribute name="body_end">
		<script src="${assetUrl}js/bundles/plugins/trumbowyg${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
	</jsp:attribute>

	<jsp:body>
		<div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminSpecialOffers.refresh">
			<div class="container">
				<div class="row">
					<ul>
						<li class="col-lg-1">
							<a href="javascript:;" class="toggle sort-by" data-sortkey="data.providerName,data.effectiveStart" data-sortdir="asc">
								<span class="icon"></span>
								<span>Fund</span>
							</a>
						</li>
						<li class="col-lg-2">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Offer</span>
							</a>
						</li>
						<li class="col-lg-3">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Conditions</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>State</span>
							</a>
						</li>
                        <li class="col-lg-1">
                            <a href="javascript:;">
                                <span class="icon"></span>
                                <span>Cover Type</span>
                            </a>
                        </li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>Brand Code</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;" class="toggle" data-sortkey="data.effectiveStart,data.providerName" data-sortdir="asc">
								<span class="icon"></span>
								<span>Start Date</span>
							</a>
						</li>
						<li class="col-lg-1">
							<a href="javascript:;">
								<span class="icon"></span>
								<span>End Date</span>
							</a>
						</li>
						<li class="col-lg-1">
							<button type="button" class="crud-new-entry btn btn-secondary btn-sm">Add New Offer</button>
						</li>
					</ul>
				</div>
			</div>
		</div>
	
		<div id="special-offers-container" class="container sortable-results-container">
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Current Special Offers <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="current-special-offers-container" class="sortable-results-table"></div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Future Special Offers <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="future-special-offers-container" class="sortable-results-table"></div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12 header">
					<h1>Past Special Offers <small></small></h1>
					<button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
				</div>
				<div class="col-sm-12">
					<div id="past-special-offers-container" class="sortable-results-table" style="display: none;"></div>
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
		],
		brands = [
			{ value: '-1', text: "Select a Brand" },
			<c:set var="brands" value="${brandsDao.getBrands()}" />
			<c:forEach items="${brands}" var="brand">
				{ value: ${brand.getId()}, text: "${brand.getName()}" },
			</c:forEach>
		];
</script>

<script id="special-offers-modal-template" class="crud-modal-template" type="text/html">
	<div class="row">
		<div class="col-sm-12">
			<br>
			{{ if(data.modalAction === "edit") { }}
				<h1>Edit Special Offer</h1>
				<input type="hidden" name="offerId" value="{{= data.offerId }}">
			{{ } else if(data.modalAction === "clone") { }}
				<h1>Clone Special Offer</h1>
			{{ } else { }}
				<h1>Create Special Offer</h1>
			{{ } }}
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<ul class="error-list"></ul>
		</div>
	</div>

	<div class="row">
		<div class="form-group col-sm-3">
			<label>Brand</label>
			<select name="styleCodeId" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
			{{ for(var i in brands) { }}
				<option value="{{= brands[i].value }}" {{= brands[i].value !== "" && data.styleCodeId === brands[i].value ? "selected" : "" }}>{{= brands[i].text }}</option>
			{{ } }}
			</select>
		</div>

		<div class="form-group col-sm-3">
			<label>Provider</label>
			<select name="providerId" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
			{{ for(var i in providers) { }}
				<option value="{{= providers[i].value }}" {{= providers[i].value !== "" && data.providerId === providers[i].value ? "selected" : "" }}>{{= providers[i].text }}</option>
			{{ } }}
			</select>
		</div>

		<div class="form-group col-sm-3">
			<label>State</label>
			<select name="state" class="form-control" >
				<c:set var="stateOptions" value="=Select a State,0=All,ACT=Australian Capital Territory,NSW=New South Wales,NT=Northern Territory,QLD=Queensland,SA=South Australia,TAS=Tasmania,VIC=Victoria,WA=Western Australia" />
				<c:forTokens items="${stateOptions}" delims="," var="state">
					<c:set var="val" value="${fn:substringBefore(state,'=')}" />
					<c:set var="des" value="${fn:substringAfter(state,'=')}" />

					<option value="${val}" {{= "${val}" === data.state ? "selected" : "" }}>${des}</option>
				</c:forTokens>
			</select>
		</div>

        <div class="form-group col-sm-3">
            <label>Cover Type</label>
            <select name="coverType" class="form-control" >
                <c:set var="coverTypeOptions" value="=Select a CoverType,0=All,H=Hospital,E=Extras,C=Combined" />
                <c:forTokens items="${coverTypeOptions}" delims="," var="coverType">
                    <c:set var="val" value="${fn:substringBefore(coverType,'=')}" />
                    <c:set var="des" value="${fn:substringAfter(coverType,'=')}" />

                    <option value="${val}" {{= "${val}" === data.coverType ? "selected" : "" }}>${des}</option>
                </c:forTokens>
            </select>
        </div>
	</div>

	<div class="row">
		<div class="form-group col-sm-6">
			<label>Offer</label>
			<textarea name="content" class="form-control editor">{{= data.content }}</textarea>
		</div>

		<div class="form-group col-sm-6">
			<label>Conditions</label>
			<textarea name="terms" class="form-control editor">{{= data.terms }}</textarea>
		</div>
	</div>

	<div class="row">
		<div class="form-group col-sm-6">
			<label>Effective Start</label>
			<input type="date" name="effectiveStart" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveStart : "" }}">
		</div>

		<div class="form-group col-sm-6">
			<label>Effective End</label>
			<input type="date" name="effectiveEnd" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveEnd : "" }}">
		</div>
	</div>

	<div class="form-group">
		<button type="button" class="crud-save-entry btn btn-secondary">Save</button>
	</div>
</script>

<script id="special-offers-row-template" class="crud-row-template" type="text/html">
	<div class="sortable-results-row row" data-id="{{= data.offerId }}">
		<div class="col-lg-1">
			{{= data.providerName }}
		</div>
		<div class="col-lg-2">
			{{= data.content }}
		</div>
		<div class="col-lg-3">
			{{= data.terms }}
		</div>
		<div class="col-lg-1">
			{{= data.state === "0" ? "All States" : data.state }}
		</div>
        <div class="col-lg-1">
            {{= data.coverType === "0" ? "All Cover Types" : data.coverType }}
        </div>
		<div class="col-lg-1">
			{{= data.styleCode }}
		</div>
		<div class="col-lg-1">
			{{= new Date(data.effectiveStart).toLocaleDateString('en-GB') }}
		</div>
		<div class="col-lg-1">
			{{= new Date(data.effectiveEnd).toLocaleDateString('en-GB') }}
		</div>
		<div class="col-lg-1">
			{{ if(data.type === "current" || data.type === "future") { }}
				<button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
				<button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>

				{{ if(data.type === "future") { }}
					<button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
				{{ } }}
			{{ } else { }}
				<button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>
			{{ } }}
		</div>
	</div>
</script>