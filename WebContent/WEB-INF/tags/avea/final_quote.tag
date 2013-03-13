<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ tag description="Group for vehicle selection"%>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>



<div class="processing_quote">
	Carsure.com.au is currently<br />
	processing your request...

	<div class="loading_bar"></div>

	<core:clear />
</div>


<div class="processing_sideimg"></div>


<core:clear />

	
<!-- CSS -->
<go:style marker="css-head">
	.processing_quote{
		width:400px;
		height:120px;
		border:1px solid #88f;
		background-color:#cef;
		padding:20px;
		padding-top:40px;
		position:relative;
		left:60px;
		top:30px;
		font-size:16px;
		text-align:center;
	}

</go:style>
