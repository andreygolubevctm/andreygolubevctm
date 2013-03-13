<%@ tag description="Left-Hand side Filter/Sort panel"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%-- ATTRIBUTES --%>
<%@ attribute name="productCat" required="false"  rtexprvalue="true"	 description="product category" %>
<%@ attribute name="className" 	required="false"  rtexprvalue="true"	 description="additional css class attribute" %>
<%@ attribute name="id" 		required="false"  rtexprvalue="true"	 description="optional id for this slide"%>
<%@ attribute name="displayGroup" 	required="true"  rtexprvalue="true"	 description="display group on property_master"%>

<%-- CSS --%>
<go:style marker="css-head">
	/* Sliders */
	.filterSet .slider {
		width:128px;
		height:20px;
		margin-left:11px;
		border-width:0px;
		cursor:pointer;
		cursor:hand;		
	}
	.filterSet .sliderWrapper {
		margin-top:12px;
		margin-bottom:16px;
	}
	.filterSet .sliderWrapper.sliderToggle {
		background: transparent url('common/images/slider-background-small.gif') no-repeat 0 20px;
	}
	.filterSet .sliderWrapper.sliderValue, 
		.filterSet .sliderWrapper.sliderRange {
		background: transparent url('common/images/slidervalue-background-small.gif') no-repeat 0 20px;
	}	
	.filterSet .sliderWrapper label {
		font-weight: bold;
		font-size: 11px;
	}
	.filterSet .sliderWrapper span {
		color: #0554df;
		font-size: 11px;
	}
	.filterSet .help_icon {
		margin-top:-20px;
		margin-left:160px;
	}
	.filterSet .ui-slider-handle {
		border: none;
		background: transparent url('common/images/slider-handle-small.png') no-repeat top left;
		height: 16px;
		width: 23px;
		padding: 0;
		margin-left: -11px;
		margin-top: 8px;
		cursor:e-resize;
	}
	.filterSet .ui-slider-range {
	    background-color: #0932F4;
	    height: 9px;
	    background-image: url("common/images/travel-results-header.gif");
	    background-position: 0px -47px;
	    top: 8px;
	}	
	.filterSet .help_icon {
		width:19px;
		height:19px;
		background-image: url("common/images/info-small.png");
		background-color:white;
	}
</go:style>


<go:script marker="onready">
	var FilterSet = new Object();	
	
	FilterSet = {
		filterChanged : function(id){
			Console.log("Filter Changed :" + id);
		}
	}
	
	$("#${id} .help_icon").each(function(){
		$(this).tooltip({delay: 200, fade: true, left: '100'});
	});
</go:script>

<%-- HTML --%>
<div class="filterSet ${className}" id="${id}">
	<sql:setDataSource dataSource="jdbc/aggregator"/>
	
	<sql:query var="result">
		SELECT * from property_master 
		WHERE ProductCat='${productCat}' 
		AND DisplayGroup='${displayGroup}' 
		ORDER BY DisplaySeq
	</sql:query>
	<c:if test="${result.rowCount > 0}">
		<c:forEach items="${result.rows}" var="row" varStatus="status">
			<c:choose>
				<c:when test="${row.gadgetType=='SLIDERTOGGLE'}">
					<agg:filter_slidertoggle initValue="${row.defaultValue}" helpId="${row.helpId}" title="${row.label} : " id="filter${row.propertyId}" />
				</c:when>
				<c:when test="${row.gadgetType=='SLIDERVALUE'}">
					<agg:filter_slidervalue initValue="${row.defaultValue}" helpId="${row.helpId}" title="${row.label} : " id="filter${row.propertyId}" productCat="${productCat}" propertyId="${row.propertyId}"/>
				</c:when>
				<c:when test="${row.gadgetType=='SLIDERRANGE'}">
					<agg:filter_sliderrange initValue="${row.defaultValue}" helpId="${row.helpId}" title="${row.label} : " id="filter${row.propertyId}" productCat="${productCat}" propertyId="${row.propertyId}"/>
				</c:when>
				
			</c:choose>
		</c:forEach>
	</c:if>	
</div>
