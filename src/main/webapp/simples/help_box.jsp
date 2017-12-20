<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>

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
        <div class="sortable-header data-sorter container-fluid" data-refreshcallback="meerkat.modules.adminHelpBox.refresh">
            <div class="container">
                <div class="row">
                    <ul>
                        <li class="col-lg-6">
                            <a href="javascript:;" class="toggle sort-by" data-sortkey="data.effectiveStart" data-sortdir="asc">
                                <span class="icon"></span>
                                <span>Text</span>
                            </a>
                        </li>
                        <li class="col-lg-2">
                            <a href="javascript:;">
                                <span class="icon"></span>
                                <span>Operator</span>
                            </a>
                        </li>
                        <li class="col-lg-1">
                            <a href="javascript:;">
                                <span class="icon"></span>
                                <span>Brand Code</span>
                            </a>
                        </li>
                        <li class="col-lg-1">
                            <a href="javascript:;" class="toggle" data-sortkey="data.effectiveStart" data-sortdir="asc">
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
                            <button type="button" class="crud-new-entry btn btn-secondary btn-sm">Add New</button>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <div id="help-box-container" class="container sortable-results-container">
            <div class="row">
                <div class="col-sm-12">
                    <h1>Help Box</h1>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 header">
                    <h1>Current<small></small></h1>
                    <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle"><span></span></button>
                </div>
                <div class="col-sm-12">
                    <div id="current-help-box-container" class="sortable-results-table"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 header">
                    <h1>Future<small></small></h1>
                    <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
                </div>
                <div class="col-sm-12">
                    <div id="future-help-box-container" class="sortable-results-table" style="display: none;"></div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 header">
                    <h1>Past<small></small></h1>
                    <button type="button" class="btn btn-tertiary btn-sm crud-results-toggle table-hidden"><span></span></button>
                </div>
                <div class="col-sm-12">
                    <div id="past-help-box-container" class="sortable-results-table" style="display: none;"></div>
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

<script id="help-box-modal-template" class="crud-modal-template" type="text/html">
    <div class="row">
        <div class="col-sm-12">
            <br>
            {{ if(data.modalAction === "edit") { }}
            <h1>Edit Help Box</h1>
            <input type="hidden" name="helpBoxId" value="{{= data.helpBoxId }}">
            {{ } else if(data.modalAction === "clone") { }}
            <h1>Clone Help Box</h1>
            {{ } else { }}
            <h1>Create Help Box Content</h1>
            {{ } }}
        </div>
    </div>

    <div class="row">
        <div class="col-sm-12">
            <ul class="error-list"></ul>
        </div>
    </div>

    <div class="row">
        <div class="form-group col-xs-9">
            <label>Content</label>
            <textarea name="content" class="form-control editor">{{= data.content }}</textarea>
        </div>
        <div class="form-group col-sm-3">
            <label>Brand</label>
            <select name="styleCodeId" class="form-control" {{= data.modalAction === "edit" ? "disabled" : "" }}>
            {{ for(var i in brands) { }}
            <option value="{{= brands[i].value }}" {{= brands[i].value !== "" && data.styleCodeId === brands[i].value ? "selected" : "" }}>{{= brands[i].text }}</option>
            {{ } }}
            </select>
        </div>
    </div>

    <div class="row">
        <div class="form-group col-xs-6">
            <label>Effective Start</label>
            <input type="date" name="effectiveStart" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveStart : "" }}">
        </div>

        <div class="form-group col-xs-6">
            <label>Effective End</label>
            <input type="date" name="effectiveEnd" class="form-control" value="{{= data.modalAction === "edit" ? data.effectiveEnd : "" }}">
        </div>
    </div>

    <div class="form-group">
        <button type="button" class="crud-save-entry btn btn-secondary">Save</button>
    </div>
</script>

<script id="help-box-row-template" class="crud-row-template" type="text/html">
    <div class="sortable-results-row row" data-id="{{= data.helpBoxId }}">
        <div class="col-lg-6">
            {{= data.content }}
        </div>
        <div class="col-lg-2">
            {{= data.operator }}
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