<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<jsp:useBean id="providerDao" class="com.ctm.web.core.dao.ProviderDao" scope="page" />
<jsp:useBean id="providerContentDao" class="com.ctm.web.health.dao.ProviderContentDao" scope="page" />
<jsp:useBean id="brandsDao" class="com.ctm.web.core.dao.BrandsDao" scope="page" />

<c:set var="providers" value="${providerDao.getProviders('HEALTH', 0, true)}" />
<c:set var="providerContentTypes" value="${providerContentDao.fetchProviderContentTypes()}" />

<c:set var="assetUrl" value="/${pageSettings.getContextFolder()}assets/" />
<c:set var="revision" value="${webUtils.buildRevisionAsQuerystringParam()}" />

<layout_v1:simples_page fullWidth="true">

  <jsp:attribute name="head">
	</jsp:attribute>
  <jsp:attribute name="body_end">
		<script src="${assetUrl}js/bundles/plugins/trumbowyg${pageSettings.getSetting('minifiedFileString')}.js?${revision}"></script>
  </jsp:attribute>
  <jsp:body>
    <div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminProviderContent.refresh">
      <div class="container">
        <div class="row">
          <ul>
            <li class="col-lg-1">
              <a href="javascript:;" class="toggle sort-by" data-sortkey="data.providerName" data-sortdir="asc">
                <span class="icon"></span>
                <span>Provider</span>
              </a>
            </li>
            <li class="col-lg-1">
              <a href="javascript:;">
                <span class="icon"></span>
                <span>Type</span>
              </a>
            </li>
            <li class="col-lg-<c:if test="${isRoleElevatedSupervisor ne true}">5</c:if><c:if test="${isRoleElevatedSupervisor}">4</c:if>">
              <a href="javascript:;">
                <span class="icon"></span>
                <span>Text</span>
              </a>
            </li>
            <li class="col-lg-4">
              <a href="javascript:;">
                <span class="icon"></span>
                <span>Brand Code</span>
              </a>
            </li>
            <li class="col-lg-2">
              <a href="javascript:;" class="toggle" data-sortkey="data.effectiveStart" data-sortdir="asc">
                <span class="icon"></span>
                <span>Effective Start</span>
              </a>
            </li>
            <li class="col-lg-2">
              <a href="javascript:;" class="toggle" data-sortkey="data.effectiveEnd" data-sortdir="asc">
                <span class="icon"></span>
                <span>Effective End</span>
              </a>
            </li>
            <c:if test="${isRoleElevatedSupervisor}">
            <li class="col-lg-1">
              <button type="button" class="crud-new-entry btn btn-secondary btn-sm">Add New</button>
            </li>
            </c:if>
          </ul>
        </div>
      </div>
    </div>

    <div id="admin-provider-content-container" class="container sortable-results-container">
      <div class="row">
        <div class="col-sm-12 header">
          <c:set var="pageTitle" value="Provider Content" />
          <c:forEach items="${providerContentTypes}" var="providerContentType">
            <c:if test="${providerContentType.getCode() == param.contentType}">
              <c:set var="pageTitle" value="${providerContentType.getDescription()}" />
            </c:if>
          </c:forEach>
          <h1>${pageTitle} <small></small></h1>
          <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
        </div>
        <div class="col-sm-12">
          <div class="sortable-results-table"></div>
        </div>
      </div>
    </div>

    <div class="side-menu-container">
      <ul class="nav nav-pills nav-stacked">
        <c:forEach items="${providerContentTypes}" var="providerContentType">
          <li class="${providerContentType.getCode() == param.contentType ? 'active' : ''}">
            <a href="?contentType=${providerContentType.getCode()}">${providerContentType.getDescription()}</a>
          </li>
        </c:forEach>
      </ul>
    </div>
  </jsp:body>
</layout_v1:simples_page>

<script type="text/javascript">
  var providers = [
    { value: '-1', text: "Select a Provider" },
    { value: 0, text: "All" },
    <c:forEach items="${providers}" var="provider">
    { value: ${provider.getId()}, text: "${provider.getName()}" },
    </c:forEach>
  ];
  var providerContentTypes = [
    { value: '-1', code: '', text: "Select a Content Type" },
    <c:forEach items="${providerContentTypes}" var="providerContentType">
    { value: ${providerContentType.getId()}, code: "${providerContentType.getCode()}", text: "${providerContentType.getDescription()}" },
    </c:forEach>
  ];
  var providerContentTypeCode = '${param.contentType}';

  var brands = [
      { value: '-1', text: "Select a Brand" },
      <c:set var="brands" value="${brandsDao.getBrands()}" />
      <c:forEach items="${brands}" var="brand">
      { value: ${brand.getId()}, text: "${brand.getName()}" },
      </c:forEach>
  ];
</script>

<script class="crud-modal-template" type="text/html">
  <div class="row">
    <div class="col-sm-12">
      <br>
      {{ if(data.modalAction === "edit") { }}
        <h1>Edit Provider Content</h1>
        <input type="hidden" name="providerContentId" value="{{= data.providerContentId }}">
      {{ } else if(data.modalAction === "clone") { }}
        <h1>Clone Provider Content</h1>
      {{ } else { }}
        <h1>New Provider Content</h1>
      {{ } }}
      <input type="hidden" name="verticalId" value="4">
    </div>
  </div>
  <div class="row">
    <div class="col-sm-12">
      <ul class="error-list"></ul>
    </div>
  </div>
  <div class="row">
    <div class="form-group col-sm-8">
      <label>Text</label>
      <textarea name="providerContentText" class="form-control editor">{{= data.providerContentText }}</textarea>
    </div>
    <div class="form-group col-sm-4">
      <div class="row">
        <div class="form-group col-sm-12">
          <label>Brand</label>
          <select name="styleCodeId" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
          {{ for(var i in brands) { }}
          <option value="{{= brands[i].value }}" {{= brands[i].value !== "" && data.styleCodeId === brands[i].value ? "selected" : "" }}>{{= brands[i].text }}</option>
          {{ } }}
          </select>
        </div>
        <div class="form-group col-sm-12">
          <label>Provider</label>
          <select name="providerId" class="form-control">
            {{ for(var i in providers) { }}
              <option value="{{= providers[i].value }}" {{= data.providerId === providers[i].value ? "selected" : "" }}>{{= providers[i].text }}</option>
            {{ } }}
          </select>
        </div>
        <div class="form-group col-sm-12">
          <label>Content Type</label>
          <select name="providerContentTypeId" class="form-control">
            {{ for(var i in providerContentTypes) { }}
            <option value="{{= providerContentTypes[i].value }}" {{= data.providerContentTypeId === providerContentTypes[i].value ? "selected" : "" }}>{{= providerContentTypes[i].text }}</option>
            {{ } }}
          </select>
        </div>
        <div class="form-group col-sm-12">
          <label>Effective Start</label>
          <input type="date" name="effectiveStart" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveStart : "" }}">
        </div>
        <div class="form-group col-sm-12">
          <label>Effective End</label>
          <input type="date" name="effectiveEnd" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveEnd : "" }}">
        </div>
      </div>
    </div>
  </div>
  <div class="form-group">
    <button type="button" class="crud-save-entry btn btn-secondary">Save</button>
  </div>
</script>

<script class="crud-row-template" type="text/html">
  <div class="sortable-results-row row" data-id="{{= data.providerContentId }}">
    <div class="col-lg-1">
      {{= data.providerName }}
    </div>
    <div class="col-lg-1">
      {{= data.providerContentTypeCode }}
    </div>
    <div class="col-lg-<c:if test="${isRoleElevatedSupervisor ne true}">5</c:if><c:if test="${isRoleElevatedSupervisor}">4</c:if>">
      {{= data.providerContentText }}
    </div>
    <div class="col-lg-1">
      {{= data.styleCode }}
    </div>
    <div class="col-lg-2">
      {{= new Date(data.effectiveStart).toLocaleDateString('en-GB') }}
    </div>
    <div class="col-lg-2">
      {{= new Date(data.effectiveEnd).toLocaleDateString('en-GB') }}
    </div>
    <c:if test="${isRoleElevatedSupervisor}">
    <div class="col-lg-1">
      <button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
      <button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>
      <button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
    </div>
    </c:if>
  </div>
</script>