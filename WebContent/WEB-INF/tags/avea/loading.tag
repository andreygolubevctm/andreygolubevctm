<%@ tag description="Loading Progress Bar"%>
<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<!-- CSS -->
<go:style marker="css-head">
	#loading-anim {
	    background: url("common/images/loading.gif") no-repeat scroll left top transparent;
    	height: 49px;
	    width: 452px;
	    top: 100px;
	    position:absolute;
	    left:400px;
	}
</go:style>


<!-- HTML -->
<div>
	<span id="loading-anim"></span>
</div>


