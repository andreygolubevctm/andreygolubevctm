<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="verticalFeatures"	required="true"	 	rtexprvalue="true"	 description="The vertical using the tag" %>

<go:style marker="css-head">
	.cover_type .item,
	.cover_type input[type="checkbox"] + label span.lb{
		width: auto;
	}
	.cover_checkboxes{
		float: left;
	}
	.cover_type .item{
		margin-right: 60px;
	}
	.cover_type h2{
		height: auto;
	}
	.cover_type .column .insert{
		padding-left: 55px;
	}
</go:style>

<sql:setDataSource dataSource="jdbc/ctm"/>

<sql:query var="results">
	SELECT
		id,
		name,
		code
	FROM aggregator.features_product_type
	WHERE Vertical = ?;

	<sql:param>${fn:toUpperCase(verticalFeatures)}</sql:param>
</sql:query>

<div class="panel cover_type force-invisible-select">

	<input id="selected_types_hdn" type="hidden" name="${fn:toLowerCase(pageSettings.getVerticalCode())}_types" value=""/>

	<div class="column rightSide leftSide blue">

		<div class="insert">
			<h2>What type of cover are you looking for?</h2>
			<div class="cover_checkboxes">
				<c:forEach items="${results.rows}" var="type">
					<div class="item">
						<input id="${type.code}_check" type="checkbox" name="type" value="${type.id}" data-name="${type.name}" checked />
						<label for="${type.code}_check"><span class="ch"></span><span class="lb">${type.name}</span></label>
					</div>
				</c:forEach>
			</div>

			<div class="button_footer">
				<span id="count_txt"></span>
				<a id="next-step-real" class="btn orange arrow-right" href="javascript:;">Compare Now</a>
				<a id="next-step" style="display:none;" href="javascript:;">Next</a>
			</div>

		</div>

	</div>

</div>