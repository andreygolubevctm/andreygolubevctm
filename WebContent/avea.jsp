<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>
<%@ include file="/WEB-INF/include/page_vars.jsp" %>
<jsp:useBean id="data" class="com.disc_au.web.go.Data" scope="session" />
<jsp:useBean id="now" class="java.util.Date" />


<%-- DIE IF REQUIRED DATA NOT SET --%>
<c:if test="${param.prdId == null 
			or data['quote'] == null 
			or data['quote/options/commencementDate'] == null 
			or empty data['quote/options/commencementDate']
			or data['quote/drivers/regular/dob'] == null 
			or empty data['quote/drivers/regular/dob']}"> 
	Session timeout
</c:if>

<%-- PROCEED IF REQUIRED DATA SET --%>
<c:if test="${param.prdId != null 
			&& data['quote'] != null 
			&& data['quote/options/commencementDate'] != null 
			&& not empty data['quote/options/commencementDate']
			&& data['quote/drivers/regular/dob'] != null 
			&& not empty data['quote/drivers/regular/dob']}"> 

<%-- SETTINGS --%>
<c:import url="brand/avea/settings.xml" var="settingsXml" />
<go:setData dataVar="data" value="*DELETE" xpath="settings" />
<go:setData dataVar="data" xml="${settingsXml}" />

<c:set var="prdId" value="${param.prdId}" />
<c:set var="leadNoPath" value="quote/${prdId}/leadNo" />

<%-- PREFILL DATA FROM CAPTAIN COMPARE CAPTURE --%> 
<fmt:parseDate var="driverDob" type="date" value="${data['quote/drivers/regular/dob']}" pattern="dd/MM/yyyy" parseLocale="en_GB" />
<fmt:formatDate value="${go:AddDays(driverDob, (data['quote/drivers/regular/licenceAge']*365))}" var="firstYearLicenced" type="date" pattern="yyyy"/>

<go:setData dataVar="data" xpath="quote/avea/driver0/firstYearLicenced" value="${firstYearLicenced}" />
<go:setData dataVar="data" xpath="quote/avea/driver0/dob" value="${data['quote/drivers/regular/dob']}" />
<go:setData dataVar="data" xpath="quote/avea/driver0/firstName" value="${data['quote/drivers/regular/firstname']}" />
<go:setData dataVar="data" xpath="quote/avea/driver0/lastName" value="${data['quote/drivers/regular/surname']}" />
<go:setData dataVar="data" xpath="quote/avea/leadNo" value="${data[leadNoPath]}" />

<c:if test="${fn:contains(data['quote/vehicle/annualKilometres'], '.')}">
	<go:setData dataVar="data" xpath="quote/avea/driver0/kilometresDriven" value="${fn:substringBefore(data['quote/vehicle/annualKilometres'], '.')}" /> 
</c:if>
<c:if test="${!fn:contains(data['quote/vehicle/annualKilometres'], '.')}">
	<go:setData dataVar="data" xpath="quote/avea/driver0/kilometresDriven" value="${data['quote/vehicle/annualKilometres']}" /> 
</c:if>

<%-- PREFILL Regular Driver Title --%> 
<c:if test="${data['quote/drivers/regular/gender'] == 'M'}">
	<go:setData dataVar="data" xpath="quote/avea/driver0/title" value="MR" />
</c:if>
<c:if test="${data['quote/drivers/regular/gender'] == 'F'}">
	<c:if test="${data['quote/drivers/regular/maritalStatus'] == 'M'}">
		<go:setData dataVar="data" xpath="quote/avea/driver0/title" value="MRS" />
	</c:if>
	<c:if test="${data['quote/drivers/regular/maritalStatus'] != 'M'}">
		<go:setData dataVar="data" xpath="quote/avea/driver0/title" value="MISS" />
	</c:if>
</c:if>

<%-- PREFILL Youngest Driver --%> 
<c:if test="${data['quote/drivers/young/exists'] == 'Y'}">
	<c:set var="youngExists" value="Y"/>
	<c:if test="${data['quote/drivers/young/gender'] == 'M'}">
		<go:setData dataVar="data" xpath="quote/avea/drivers/driver1/title" value="MR" />
	</c:if>
	<c:if test="${data['quote/drivers/young/gender'] == 'F'}">
		<go:setData dataVar="data" xpath="quote/avea/drivers/driver1/title" value="MISS" />
	</c:if>
	<fmt:parseDate var="youngDob" type="date" value="${data['quote/drivers/young/dob']}" pattern="dd/MM/yyyy" parseLocale="en_GB" />
	<fmt:formatDate value="${go:AddDays(youngDob, (data['quote/drivers/young/licenceAge']*365))}" var="youngFirstYearLicenced" type="date" pattern="yyyy"/> 
	<go:setData dataVar="data" xpath="quote/avea/drivers/driver1/dob" value="${data['quote/drivers/young/dob']}" />
	<go:setData dataVar="data" xpath="quote/avea/drivers/driver1/firstYearLicenced" value="${youngFirstYearLicenced}" />
	<go:setData dataVar="data" xpath="quote/avea/drivers/driver1/kilometresDriven" value="${data['quote/drivers/young/annualKilometres']}" />
</c:if> 

<%-- IF NO YOUNGEST, ENSURE TITLE IS CLEARED --%> 
<c:if test="${data['quote/drivers/young/exists'] != 'Y'}">
	<go:setData dataVar="data" xpath="quote/avea/drivers/driver1/title" value="" />
</c:if>

<%-- PREFILL FROM XML --%> 
<c:if test="${param.preload == '1'}">  
	<go:setData dataVar="data" value="*DELETE" xpath="quote/avea" />	
	<c:import url="test_data/avea_preload.xml" var="quoteXml" />
	<go:setData dataVar="data" xml="${quoteXml}" />		
</c:if>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<go:html>
	<core:avea_head title="Avea Quote Capture" />
	
	<body class="engine">
	
		<form:avea_form action="avea_results.jsp" method="POST" id="mainform" name="frmMain">

			<div id="wrapper">
			
				<avea:header />		
				
				<div id="page">
					
					<avea:progress_bar />
					
					<div id="content">

						<!-- Main Quote Engine content -->
						<avea:slideContainer className="sliderContainer">
	
							<avea:slide id="slide0" title="Additional Information">
								<avea:disclaimer/><core:clear/>
							</avea:slide>

							<avea:slide id="slide1" title="Buy Online">
								<avea:payment/><core:clear/>
							</avea:slide>

							<avea:slide id="slide2" title="Payment and Policy Confirmation">
								<avea:payment_confirmation/><core:clear/>
							</avea:slide>
							
							<core:clear/>
						</avea:slideContainer>
						
						<core:clear/>
						
						<!-- Bottom "step" buttons -->
						<div class="button-wrapper">
							<a href="javascript:void(0);" class="button prev" id="prev-step">Previous step</a>
							<a href="javascript:void(0);" class="button next" id="next-step">Next step</a>
							<div class="buy-grey"></div>
						</div>
						
					<!-- End main QE content -->

					</div>

					<avea:footer_links/>
	
					<avea:help/>

				</div>
						
				<form:footer/>
				
			</div>
			
		</form:avea_form>
		
		<%-- Copyright notice --%>
		<quote:copyright_notice />
		
		<%-- Duty of Disclosure --%>
		<avea:duty_disclosure/>
		
		<%-- Product Disclosure Statement --%>
		<avea:product_disclosure/>
		
		<%-- Carsure Terms --%>
		<avea:carsure_terms/>
		
		<%-- Carsure Privacy Policy --%>
		<avea:carsure_privacy/>
		
		<%-- Unacceptable Risk --%>
		<avea:unaccept/>

		<%-- Omniture Reporting --%>
		<avea:omniture />		
		
		<%-- Including all go:script and go:style tags --%>
		<avea:includes />
		
	</body>
	
</go:html>

</c:if>
