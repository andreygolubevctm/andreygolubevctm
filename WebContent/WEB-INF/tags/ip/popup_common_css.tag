<%@ tag language="java" pageEncoding="ISO-8859-1"%>
<%@ tag description="Form to view and add comments to a quote"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- CSS --%>
<go:style marker="css-head">

.ui-dialog{ position: absolute; overflow:hidden; }

#ip-product-dialog {
	min-width:				737px;
	max-width:				737px;
	width:					737px;
	display: 				none;
	overflow:				hidden;
}

#ip-product-dialog .clear
{clear:both;}

#ip-product-dialog .dialog_footer {
	position:				absolute;
	left:					0;
	bottom:					0;
	background: 			url("common/images/dialog/footer_737.gif") no-repeat scroll left top transparent;
	width: 					737px;
	height: 				10px;
	clear: 					both;
}

#ip-product-dialog .dialog_header {
	position:				absolute;
	left:					0;
	top:					0;
	background: 			url("brand/ctm/images/ui-dialog-header_737_under.gif") no-repeat scroll left bottom transparent;
	width: 					737px;
	height: 				10px;
	clear: 					both;
}

.ui-dialog.ip-product-dialog .ui-dialog-titlebar {
	padding: 				0 !important;
	height: 				25px !important;
}

.ui-dialog.ip-product-dialog .ui-dialog-titlebar .ui-dialog-title {
	display: 				none !important;
}

.ui-dialog.ip-product-dialog .ui-dialog-titlebar .ui-dialog-titlebar-close {
	display: 				block !important;
	top: 					15px;
	right: 					1em;
}
.ui-dialog.ip-product-dialog .message-form, 
.ui-dialog #ip-product-dialog {
	padding:				0;
}

.ip-product-dialog .ui-dialog-titlebar {
	background-image:		url("brand/ctm/images/ui-dialog-header_737_over.gif") !important;
	height:					34px;
	-moz-border-radius-bottomright: 0;
	-webkit-border-bottom-right-radius: 0;
	-khtml-border-bottom-right-radius: 0;
	border-bottom-right-radius: 0;
	-moz-border-radius-bottomleft: 0;
	-webkit-border-bottom-left-radius: 0;
	-khtml-border-bottom-left-radius: 0;
	border-bottom-left-radius: 0;
}

.ip-product-dialog .ui-dialog-content {
	background-image:		url("brand/ctm/images/ui-dialog-content_737.png") !important;
}

.ip-product-dialog .ui-dialog-content .wrapper {
	padding:					15px 15px;
}

#ip-product-dialog .wrapper .column,
#ip-product-dialog .wrapper .column .inner {
	float:					left;
}

#ip-product-dialog .wrapper .column.left {
	width:					391px;
	/*height:					400px;*/
}

#ip-product-dialog .wrapper .column.right {
	width:					296px;
	/*height:					400px;*/
	margin-left:			20px;
}

#ip-product-dialog .wrapper .column.full {
	width:					707px;
}

#ip-product-dialog .wrapper .column.left .inner.top {
	width:					391px;
}

#ip-product-dialog .wrapper .column.left .inner.left {
	width:					391px/*216px*/;
}

#ip-product-dialog .wrapper .column.left .inner.right {
	width:					155px;
	margin-left:			20px;
}

#ip-product-dialog .wrapper .column.left .inner.bottom {
	width:					391px;
}

#ip-product-dialog .wrapper .panel {
	padding:					10px;
	margin:						0 0 10px 0;
	border:						1px solid #DAE0E4;
	-moz-border-radius: 		5px;
	-webkit-border-radius: 		5px;
	-khtml-border-radius: 		5px;
	border-radius: 				5px;
}

#ip-product-dialog .wrapper .panel.couple {
	float:						left;
	height:						41px;
}

#ip-product-dialog .wrapper .panel.couple h4 {
	margin:						0 0 5px 0;
}

#ip-product-dialog .wrapper .panel.couple.benefits {
	margin-right:				10px;
}

#ip-product-dialog .wrapper .panel.couple.benefits li {
	display:					inline;
	margin-right:				10px;
}

#ip-product-dialog .wrapper .panel.nobdr {
	border-color:				#FFFFFF;
}

#ip-product-dialog .wrapper .panel.nopad {
	padding:					0;
}

#ip-product-dialog .wrapper .panel.dark {
	background-color:			#F4F9FE;
}

#ip-product-dialog .wrapper p {
	font-size:					105%;
	line-height:				110%;
}

#ip-product-dialog .wrapper p.disclaimer {
	font-size:					90%;
}

#ip-product-dialog .wrapper h4,
#ip-product-dialog .wrapper h5 {
	margin:						15px 0 5px 0;
}

#ip-product-dialog .wrapper h4.first,
#ip-product-dialog .wrapper h5.first,
#ip-product-dialog .wrapper h6.first {
	margin-top:					0;
}

#ip-product-dialog .wrapper h5 {
	font-size:					140%;
}

#ip-product-dialog .wrapper h6 {
	font-size:					120%;
	margin:						0 0 5px 0;
}

#ip-product-dialog .wrapper ul.policy_benefits li {
	font-size:					100%;
	font-weight:				bold;
	padding:					5px 0 5px 25px;
	background:					transparent url(brand/ctm/images/checkbox_on.png) center left no-repeat;
}

#ip-product-dialog .wrapper .policy_details li {
	font-size:					100%;
	font-weight:				normal;
	padding:					2px 0 2px 10px;
	background:					transparent url(brand/ctm/images/bullet_edit.png) left 5px no-repeat;
}

#ip-product-dialog .wrapper .right-panel {
	margin-left:				0px !important;
}

#ip-product-dialog .wrapper .right-panel .right-panel-top,
#ip-product-dialog .wrapper .right-panel .right-panel-bottom {
	height:						5px !important;
}

#ip-product-dialog .wrapper .right-panel .right-panel-bottom {
	background-position:		bottom center !important;
}
	
#ip-product-dialog .wrapper .call-me-back {
	margin-bottom:				20px;
}
	
#ip-product-dialog .wrapper .call-me-back p.sub {
	padding:					0 35px;
	font-size:					80%;
}
	
#ip-product-dialog .wrapper .call-me-back p.ref {
	padding:					0 35px;
	font-size:					110%;
	text-align:					center;
	line-height:				120%;
}
	
#ip-product-dialog .wrapper .call-me-back p.ref span {
	font-weight:				900;
	font-size:					130%;
}
	
#ip-product-dialog .wrapper .call-me-back h5 {
	text-align:					center;
}
	
#ip-product-dialog .wrapper .call-me-back h5 em {
	font-size:					150%;
	font-style:					normal;
	color:						#1C3F94;
}
	
#ip-product-dialog .wrapper .call-me-back h5 em span {
	color:						#0CB24E;
}
	
#ip-product-dialog .wrapper .call-me-back > a {
    display:					block;
    width:						205px;
    height:						33px;
    cursor:						pointer;
	margin:						0 auto 0 auto;
	padding:					0 0 5px 0;
    text-decoration: 			none;
	background:					transparent url("brand/ctm/images/button_bg.png") top left no-repeat;
}

#ip-product-dialog .wrapper .call-me-back > a span {
    display: 					block;
	font-size:					11.25pt;
	font-weight:				bold;
	height: 					100%;
    width: 						100%;
    line-height: 				33px;
    margin:						0;
    padding:					0;
    text-align: 				center;
   	color: 						#ffffff;
	background: 				transparent url("brand/ctm/images/button_bg_right.png") top right no-repeat;
	text-shadow: 				0px 1px 1px rgba(0,0,0,0.5);
}

#ip-product-dialog .wrapper .right-panel-middle .panel {
    margin-bottom: 				0px;
}

#ip-product-dialog .wrapper .head {
	height:						60px;
}

#ip-product-dialog .wrapper .intro {
	border:						1px solid #FFFFFF;
	padding-right:				0px;
}

#ip-product-dialog .wrapper .head img,
#ip-product-dialog .wrapper .head div {
	float:						left;
	margin:						22px 0 0 10px;
	font-size:					130%;
	font-weight:				900;
}

#ip-product-dialog .wrapper .premium div {
	font-size:					120%;
}

#ip-product-dialog .wrapper .intro div {
	margin-left:				20px;
}

#ip-product-dialog .wrapper .intro div span {
	font-size:					130%;
}

#ip-product-dialog .wrapper .intro .logo {
	margin-top:					0px;
	margin-left:				0px;
}

#ip-product-dialog .wrapper .premium div {
	margin-top:					16px;
}

#ip-product-dialog .wrapper .premium div.text {
	font-size:					110%;
}

#ip-product-dialog .wrapper .premium .amount {
	margin-top:					7px;
	margin-left:				0px;
	width:						96px;
	height:						46px;
	background:					transparent url(brand/ctm/images/bg_premium_price.png) 50% 50% no-repeat;
}

#ip-product-dialog .wrapper .premium .amount span {
	display:					block;
	margin:						13px auto 0 auto;
	color:						#0CB24E;
	text-align:					center;
	font-size:					19px;
}

</go:style>