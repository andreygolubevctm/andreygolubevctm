<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

<jsp:useBean id="providerDao" class="com.ctm.dao.ProviderDao" scope="page" />

<layout:simples_page fullWidth="true">
	<jsp:attribute name="head">
		<script src="${assetUrl}../../../framework/lib/js/trumbowyg.min.js?${revision}"></script>
	</jsp:attribute>
  <jsp:body>
    <div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminFundWarningMessage.refresh">
      <div class="container">
        <div class="row">
          <ul>
            <li class="col-lg-2">
              <a href="javascript:;" class="toggle sort-by" data-sortkey="data.providerName" data-sortdir="asc">
                <span class="icon"></span>
                <span>Provider</span>
              </a>
            </li>
            <li class="col-lg-5">
              <a href="javascript:;">
                <span class="icon"></span>
                <span>Message</span>
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
            <li class="col-lg-1">
              <button type="button" class="crud-new-entry btn btn-secondary btn-sm">Add New</button>
            </li>
          </ul>
        </div>
      </div>
    </div>

    <div id="admin-fund-warning-message-container" class="container sortable-results-container">
      <div class="row">
        <div class="col-sm-12 header">
          <h1>Fund Warning Messages <small></small></h1>
          <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
        </div>
        <div class="col-sm-12">
          <div class="sortable-results-table"></div>
        </div>
      </div>
    </div>
  </jsp:body>
</layout:simples_page>

<script type="text/javascript">
  var providers = [
        { value: '-1', text: "Select a Provider" },
        { value: 0, text: "All" },
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
        <h1>Edit Fund Warning Message</h1>
        <input type="hidden" name="messageId" value="{{= data.messageId }}">
      {{ } else if(data.modalAction === "clone") { }}
        <h1>Clone Fund Warning Message</h1>
      {{ } else { }}
        <h1>New Fund Warning Message</h1>
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
      <label>Message</label>
      <textarea name="messageContent" class="form-control editor">{{= data.messageContent }}</textarea>
    </div>
    <div class="form-group col-sm-4">
      <div class="row">
        <div class="form-group col-sm-12">
          <label>Provider</label>
          <select name="providerId" class="form-control">
            {{ for(var i in providers) { }}
              <option value="{{= providers[i].value }}" {{= data.providerId === providers[i].value ? "selected" : "" }}>{{= providers[i].text }}</option>
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
  <div class="sortable-results-row row" data-id="{{= data.messageId }}">
    <div class="col-lg-2">
      {{= data.providerName }}
    </div>
    <div class="col-lg-5">
      {{= data.messageContent }}
    </div>
    <div class="col-lg-2">
      {{= new Date(data.effectiveStart).toLocaleDateString('en-GB') }}
    </div>
    <div class="col-lg-2">
      {{= new Date(data.effectiveEnd).toLocaleDateString('en-GB') }}
    </div>
    <div class="col-lg-1">
      <button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
      <button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>
      <button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
    </div>
  </div>
</script>