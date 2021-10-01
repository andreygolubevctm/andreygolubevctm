<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="filterStyleCodeId" 			required="true"	 	rtexprvalue="true" 	description="The stylecode to use when popping items off the cli filter stack" %>
<%@ attribute name="filterVertical" 			required="true"	 	rtexprvalue="true" 	description="The vertical to filter the contact list" %>

<c:set var="cliVertical">
	<c:choose>
		<c:when test="${fn:contains('CAR|HEALTH|HOME', filterVertical)}">${filterVertical}</c:when>
		<c:otherwise>NONE</c:otherwise>
	</c:choose>
</c:set>

<div class="add-to-cli-filter">
	<h2>Add to CLI Filter</h2>
	<div class="simples-clifilter-pane-body">
		<div class="alert alert-success alert-success-${filterStyleCodeId} hidden"></div>
		<div class="alert alert-danger alert-danger-${filterStyleCodeId} hidden"></div>
		<form id="simples-add-clifilter-${filterStyleCodeId}-${cliVertical}" class="form-horizontal">
			<div class="form-group row">
				<label for="phone" class="col-xs-3 control-label">Phone Number</label>
				<div class="row-content col-xs-6">
					<input type="text" name="phone" class="form-control phone" placeholder="0x xxxx xxxx" size="10">
				</div>
				<div class="row-content col-xs-3">
					<span class="form-error text-danger"></span>
					<a data-provide="simples-clifilter-submit" data-filter-stylecode-id="${filterStyleCodeId}" data-filter-vertical="${cliVertical}" class="btn btn-warning">Add to CLI Filter</a>
				</div>
			</div>
		</form>
	</div>

</div>