<%@ tag description="Loading Progress Bar"%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%@ attribute name="id" 			required="false" rtexprvalue="true"	 description="optional id for classnames" %>
<%@ attribute name="title" 			required="false" rtexprvalue="true"	 description="optional title..." %>

<!-- CSS -->
<go:style marker="css-head">
	#${id}loading-anim {
		background: url("common/images/loading.gif") no-repeat scroll left top transparent;
		height: 49px;
		width: 452px;
		position:absolute;

	}
	#${id}loading-box {
		display:none;
		height:150px;
	}
</go:style>


<!-- HTML -->
<div id="${id}loading-box">
	<c:if test="${not empty title}">
		<h2>${title }</h2>
	</c:if>
	<span id="${id}loading-anim"></span>
</div>


