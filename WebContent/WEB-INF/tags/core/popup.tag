<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Create help popup tag"%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="id" 		required="true"	 rtexprvalue="true"	 description="id for the popup panel" %>
<%@ attribute name="title" 		required="true" rtexprvalue="false" description="title for the panel" %>
<%@ attribute name="className" 	required="false" rtexprvalue="true"	 description="additional css class attribute" %>
<c:choose>
<c:when test="not empty className">
	<c:set var="cls" value="${className}" />
</c:when>
<c:otherwise>
	<c:set var="cls" value="popup_450" />
</c:otherwise>
</c:choose>

<go:style marker="css-head">
	.popup {
		z-index:3001;
		height:auto;
		display: none;		
	}
	.popup h5 {
	    display: block;
	    font-size: 22px;
	    font-weight: 300;
	    height: 38px;
	    padding-left: 1em;
	    padding-top: 16px;
	    width: 450px;
	    margin-bottom: -10px;
	    font-family: "SunLT Light","Open Sans",Helvetica,Arial,sans-serif;
	}
	.popup .content {
		padding:10px;
		overflow:none;
		height:auto;	
	}
	.popup .close-button {
	    left: 424px;
	}
	.popup .popup-buttons {
		margin-top:30px;
		position:relative;
		top:12px;
		text-align:middle;
	}
	.popup_450 {
		width:450px;
	}
	.popup_450 h5 {
	    background: url("common/images/dialog/header_450.gif") no-repeat scroll 0 0 transparent;
	}
	.popup_450 .content {
		background: white url("common/images/dialog/content_450.gif") repeat-y;
	}
	.popup_450 .fieldrow {
    	width: 430px;
    }
	.popup_450 .buttons {
		background: transparent url("common/images/dialog/buttonpane_450.gif") no-repeat;
		width:450px;
		height:57px;
		display:block;
	}
</go:style>

<go:script href="common/js/popup.js" marker="js-href" />

<%-- CODE --%>
<div id="${id}" class="popup ${cls}">
	<a href="javascript:void(0);" class="close-button"></a>
	
	<h5>${title}</h5>
	
	<div class="content">
		<jsp:doBody />
	</div>
	
	<div class="buttons">
	</div>
	
</div>