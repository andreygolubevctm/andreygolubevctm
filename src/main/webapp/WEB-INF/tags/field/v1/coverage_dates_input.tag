<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents a person's insurance cover periods"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="field group's xpath"%>

<div>

	<%-- holds json array object data --%>
	<field_v2:validatedHiddenField xpath="${xpath}/dates/coverDates" title="Insurance Cover history is required" additionalAttributes=" required " />

	<c:set var="fieldxpathname" value="${xpath}/dates/controls/datesEntryValidationContainer" />
	<div id="${go:nameFromXpath(fieldxpathname)}" class="col-xs-12 row-content"></div>
	<div>
		<div class="fieldrow">
			<div class="col-xs-12 col-sm-6 col-lg-4   row-content">
				<c:set var="fieldxpathname" value="${xpath}/dates/controls/startDateInput" />
				<input type="date" name="${go:nameFromXpath(fieldxpathname)}" id="${go:nameFromXpath(fieldxpathname)}" class="form-control " value="" required="" aria-required="true">
			</div>
		</div>
		<div class="fieldrow">
			<div class="col-xs-12 col-sm-6 col-lg-4   row-content">
				<c:set var="fieldxpathname" value="${xpath}/dates/controls/endDateInput" />
				<input type="date" name="${go:nameFromXpath(fieldxpathname)}" id="${go:nameFromXpath(fieldxpathname)}" class="form-control " value="" required="" aria-required="true">
			</div>
		</div>
		<div class="fieldrow">
			<div class="col-xs-12 col-sm-6 col-lg-2   row-content">
				<c:set var="fieldxpathname" value="${xpath}/dates/controls/add" />
				<button id="${go:nameFromXpath(fieldxpathname)}" class="btn btn-form coverdates-add">Add</button>
				<c:set var="fieldxpathname" value="${xpath}/dates/controls/edit" />
				<button id="${go:nameFromXpath(fieldxpathname)}" class="btn btn-secondary coverdates-edit hidden">Save</button>
			</div>
		</div>
		<div class="fieldrow">
			<div class="col-xs-12 col-sm-6 col-lg-2   row-content">
				<c:set var="fieldxpathname" value="${xpath}/dates/controls/cancel" />
				<button id="${go:nameFromXpath(fieldxpathname)}" class="btn btn-danger coverdates-cancel hidden">Cancel</button>
			</div>
		</div>
	</div>

	<c:set var="fieldxpathname" value="${xpath}/dates/dataTableContainer" />
	<div id="${go:nameFromXpath(fieldxpathname)}" class="col-xs-12 row-content"></div>

</div>