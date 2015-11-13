<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<settings:setVertical verticalCode="SIMPLES" />
<%@ include file="/WEB-INF/security/core.jsp" %>
<jsp:useBean id="verticalsDao" class="com.ctm.web.core.dao.VerticalsDao" scope="page" />

<layout:simples_page>
	<jsp:attribute name="head">
	</jsp:attribute>

    <jsp:body>
        <script src="/${pageSettings.getContextFolder()}framework/jquery/plugins/jquery.rowsorter.min.js"></script>

        <div id="opening-hours-container" class="container">
            <div class="row">
                <div class="col-sm-10">
                    <h1>Product Capping Limits</h1>
                </div>
                <div class="col-sm-2">
                    <button type="button" class="btn btn-sm btn-info opening-hours opening-hours-refresh right">Refresh</button>
                </div>
            </div>
            <div id="hours-normal" class="row">
                <h2 class="col-sm-10">Normal Hours</h2>
                <div class="col-sm-2">
                    <button type="button" class="btn btn-sm btn-default opening-hours opening-hours-new right">New Capping Limit</button>
                </div>
                <div class="col-sm-12">
                    <table id="hours-normal-row-container" class="opening-hours-table table table-hover" data-hourstype="N">
                        <thead>
                        <tr>
                            <th><span class="icon icon-reorder"></span></th>
                            <th>Fund</th>
                            <th>Effective Start</th>
                            <th>Effective End</th>
                            <th>Limit Type</th>
                            <th>Limit Amount</th>
                            <th>Limit Progress</th>
                            <th colspan="2">Actions</th>
                        </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
    </jsp:body>
</layout:simples_page>

<c:set var="allVerticals" value="${verticalsDao.getVerticals()}" />

<script>
    var openingHoursVerticals = {
            <c:forEach items="${allVerticals}" var="vertical">"${vertical.getId()}": "${vertical.getName()}",</c:forEach>
    };
</script>

<script id="opening-hours-row-noresults-template" type="text/html">
    <tr id="opening-hours-noresults">
        <td colspan="100">Tick, tock. No hours are available. Why not <a href="javascript:;" class="opening-hours-new">add some?</a></td>
    </tr>
</script>

<script id="opening-hours-row-template" type="text/html">
    <tr id="opening-hours-{{= openingHoursId }}" data-id="{{= openingHoursId }}" data-hourstype="{{= hoursType }}">
        {{ if(hoursType === "N") { }}
        <td class="daySequence sorter">
            <span data-daysequence="{{= daySequence }}" class="icon icon-reorder"></span>
        </td>
        {{ } }}
        <td class="description">
            {{ if(hoursType == "S") { }}
            <input type="text" class="hidden" value="{{= description }}" />
            {{ } else { }}
            <select class="hidden">
                <option value="Monday" {{= (description === "Monday" ? "selected" : "") }}>Monday</option>
                <option value="Tuesday" {{= (description === "Tuesday" ? "selected" : "") }}>Tuesday</option>
                <option value="Wednesday" {{= (description === "Wednesday" ? "selected" : "") }}>Wednesday</option>
                <option value="Thursday" {{= (description === "Thursday" ? "selected" : "") }}>Thursday</option>
                <option value="Friday" {{= (description === "Friday" ? "selected" : "") }}>Friday</option>
                <option value="Saturday" {{= (description === "Saturday" ? "selected" : "") }}>Saturday</option>
                <option value="Sunday" {{= (description === "Sunday" ? "selected" : "") }}>Sunday</option>
            </select>
            {{ } }}
            <span>{{= description }}</span>
        </td>
        {{ if(hoursType === "S") { }}
        <td class="date">
            <input type="date" class="hidden" value="{{= date }}" />
            <span>{{= new Date(date).toLocaleDateString() }}</span>
        </td>
        {{ } }}
        <td class="effectiveStart">
            <input type="date" class="hidden" value="{{= effectiveStart }}" />
            <span>{{= new Date(effectiveStart).toLocaleDateString() }}</span>
        </td>
        <td class="startTime">
            <input type="time" class="hidden" value="{{= startTime }}" />
            <span>{{= startTime }}</span>
        </td>
        <td class="effectiveEnd">
            <input type="date" class="hidden" value="{{= effectiveEnd }}" />
            <span>{{= new Date(effectiveEnd).toLocaleDateString() }}</span>
        </td>
        <td class="endTime">
            <input type="time" class="hidden" value="{{= endTime }}" />
            <span>{{= endTime }}</span>
        </td>
        <td class="verticalId">
            <select class="hidden">
                <c:forEach items="${allVerticals}" var="vertical">
                    <option value="${vertical.getId()}" {{= (verticalId === ${vertical.getId()} ? "selected" : "") }}>${vertical.getName()}</option>
                </c:forEach>
            </select>
            <span>{{= openingHoursVerticals[verticalId] }}</span>
        </td>
        <td>
            <button class="btn btn-sm btn-success save hidden" type="button" data-id="{{= openingHoursId }}">Save</button>
            <button class="btn btn-sm btn-primary edit" type="button" data-id="{{= openingHoursId }}">Edit</button>
        </td>
        <td>
            <button class="btn btn-sm btn-info cancel hidden" type="button" data-id="{{= openingHoursId }}">Cancel</button>
            <button class="btn btn-sm btn-danger delete" type="button" data-id="{{= openingHoursId }}">Delete</button>
        </td>
    </tr>
</script>