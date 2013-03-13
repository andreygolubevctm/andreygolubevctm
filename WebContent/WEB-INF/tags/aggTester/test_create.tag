<%@ tag description="Automated Test System"%>
<%@ tag language="java" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />


<%@ attribute name="providerType" required="true" rtexprvalue="true" description="provider Type like Travel" %>
<go:setData dataVar="data" value="${providerType}" xpath="siteName" />

<%-- Load the params into data --%>


<go:style marker="css-head">
	.button-wrapper #test {
    	left: 423px;
    	position: absolute;
    	top: 412px;
    	background: url("common/images/test_aggregator/add_test_btn.png") no-repeat scroll left top transparent;
	}
	 
	.button-wrapper #test:hover {
    	left: 423px;
    	position: absolute;
    	top: 412px;
    	background: url("common/images/test_aggregator/add_test_btn.png") no-repeat scroll left -40px transparent;
	}
	
	#content a.button {
	    display: block;
	    height: 37px;
	    width: 192px;
	}
	
	#addedTest {
		width: 100%;
		height: 50px;
		background: #e20909;
		position: absolute;
		top: 0;
		left: 0;
		display: none;
		font-size: 24px;
		color: #fff;
		text-align: center;
		line-height: 50px;
	}
	
	#desc-popup {
		width: 400px;
		height: 200px;
		background: #fff;
		border: 2px solid #e20909;
		z-index: 999;
		position: absolute;
		top: 200px;
		left: 250px;
		padding: 20px;
		text-align: left;
		-moz-border-radius: 15px;
		border-radius: 15px;
	}
	
	#desc-popup p {
		font-size: 1.2em;
		font-weight: bold;
		margin-bottom: 20px;
		color: #4c4c4c;
	}
	
	#desc-popup textarea {
		width: 400px;
		height: 100px;
	}
	
	#desc-popup-btn-wrapper {
		padding: 20px 0 0 235px;
		float: left;
	}
	
	#desc-popup-btn-wrapper a{
		display: block;
		text-indent: -9999px;
	}
	
	#desc-popup-exit {
		position: absolute;
		top: 0;
		right: 0;
		margin: 10px;

	}
	#desc-popup-exit-btn {
		text-decoration: none;
		color: #e20909;
		font-weight: bold;
	}
	
	#desc-popup-btn-wrapper #desc-popup-btn {
		background: url('common/images/test_aggregator/add_desc_btn.png') scroll left top no-repeat;
		width: 176px;
		height: 40px;
		
		
	}
	
	#desc-popup-btn-wrapper #desc-popup-btn:hover{
		background: url('common/images/test_aggregator/add_desc_btn.png') scroll left -40px no-repeat;
		width: 176px;
		height: 40px;
	}
	

</go:style>
<go:script marker="js-href" href="common/js/processTest.js" />
<go:script marker="onready">
	
	/* set description popup box */
	TestAdd.setDescription()
	$('#desc-popup').hide();
	
	
	$("#next-step").hide();
	$(".button-wrapper").append("<a id='test' class='button next' href='javascript:void(0);'>Add test Instance</a>");
	$("#test").click(function(){ $('#desc-popup').show(); });
	//$("#test").click(function(){ validate_form(true); });
	$("#desc-popup-btn").click(function(){ $('#desc-popup').hide(); validate_form(true); });
	$("#desc-popup-exit-btn").click(function(){ $('#desc-popup').hide(); });
	
	function validate_form(dosub){
		validation = true;
		//$("#mainform").validate().resetNumberOfInvalids();
		var numberOfInvalids = 0;
	
		$('#slide'+slideIdx + ' :input').each(function(index) {
			if($(this).attr("id")){
				$("#mainform").validate().element("#" + $(this).attr("id"));
			}
		});
		
		if($("#mainform").validate().numberOfInvalids() == 0) {
		
			if(!$("#helpToolTip").is(':hidden')){ 
				$("#helpToolTip").fadeOut(slideSpeed);
			}
			if(typeof(dosub)!='undefined' && dosub){			
				TestAdd.insertData();
			}
		}
	}
	
</go:script>





 
<div id="desc-popup">
	<p>Please enter Description of test:</p>
	<span id="desc-popup-exit"><a href="javascript:void(0);" id="desc-popup-exit-btn">X</a></span>
	<form:row label="" className="thin_label">
				<field:textarea rows="2" cols="20" xpath="travel/testDesc" title="Test Instance Description" required="false" className="thinner_input"></field:textarea>
	</form:row>
	
	<div id="desc-popup-btn-wrapper">
	<a id="desc-popup-btn" class="button next" href="javascript:void(0);">add description</a>
	</div>
</div>
