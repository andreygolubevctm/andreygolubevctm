<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Represents the colour of the person's Medicare card."%>

<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="xpath" required="true" rtexprvalue="true" description="variable's xpath" %>

<div id="health_medicareDetails_yellowCardMessage" class="hidden">
	Yellow card holders (reciprocal) have limited Medicare access and no benefit if you elect to be treated as a private patient in either a private or public hospital. You may choose private hospital cover for tax-purposes as the Medicare levy surcharge may still otherwise apply.
</div>

<c:set var="name" value="${go:nameFromXpath(xpath)}" />
<c:set var="value"><c:out value="${data[xpath]}" escapeXml="true"/></c:set>
<c:set var="id" value="${name}_${val}" />

<c:set var="title" value="your Medicare card colour. To proceed with this policy, you must have a green, blue or yellow medicare card. To proceed with this policy, you must have a green, blue or yellow medicare card. For overseas visitor cover, please go to https://www.comparethemarket.com.au/health-insurance/health-insurance-overseas-visitors/"  />

<c:set var="val1" value="green" />
<c:set var="des1" value="Green" />
<c:set var="checked1" value="" />
<c:set var="active1" value="" />

<c:if test="${val1 == value}">
	<c:set var="checked1" value="checked=\"checked\"" />
	<c:set var="active1" value=" active" />
</c:if>

<c:set var="val2" value="blue" />
<c:set var="des2" value="Blue" />
<c:set var="checked2" value="" />
<c:set var="active2" value="" />

<c:if test="${val2 == value}">
	<c:set var="checked2" value="checked=\"checked\"" />
	<c:set var="active2" value=" active" />
</c:if>


<c:set var="val3" value="yellow" />
<c:set var="des3" value="Green/Yellow (Reciprocal)" />
<c:set var="checked3" value="" />
<c:set var="active3" value="" />

<c:if test="${val3 == value}">
	<c:set var="checked3" value="checked=\"checked\"" />
	<c:set var="active3" value=" active" />
</c:if>

<c:set var="val4" value="none" />
<c:set var="des4" value="I don&apos;t have a Medicare card" />
<c:set var="checked4" value="" />
<c:set var="active4" value="" />

<c:if test="${val4 == value}">
	<c:set var="checked4" value="checked=\"checked\"" />
	<c:set var="active4" value=" active" />
</c:if>

<div class="btn-tile dontSubmit medicare" data-toggle="radio" id="${name}">
	<label class="btn btn-form-inverse ${active1}" >
		<div class="medicare-img-style medicare_green"><span class="sr-only">Medicare Card Green</span></div>
		<input type="radio" name="${name}" id="${name}_${val1}" value="${val1}" ${checked1} data-msg-required="Please choose ${title}" required="required" >
		Green
	</label>
	<label class="btn btn-form-inverse ${active2}" >
		<div class="medicare-img-style medicare_blue"><span class="sr-only">Medicare Card Blue Interim</span></div>
		<input type="radio" name="${name}" id="${name}_${val2}" value="${val2}" ${checked2} data-msg-required="Please choose ${title}" required="required" >
		Blue<br />(Interim card)
	</label>
	<label class="btn btn-form-inverse ${active3}" >
		<div class="medicare-img-style medicare_yellow"><span class="sr-only">Medicare Card Green/Yellow Reciprocal</span></div>
		<input type="radio" name="${name}" id="${name}_${val3}" value="${val3}" ${checked3} data-msg-required="Please choose ${title}" required="required" >
		Green/Yellow<br />(Reciprocal health care - Visitor)
	</label>
	<label class="btn btn-form-inverse ${active4}" >
		<div class="medicare-img-style medicare_none"><span class="sr-only">No Medicare card</span></div>
		<input type="radio" name="${name}" id="${name}_${val4}" value="${val4}" ${checked4} data-msg-required="Please choose ${title}" required="required" >
		None of the above
	</label>
</div>

<div class="medicare-disclaimer">
Use of the Medicare card image is for demonstrative purposes only and is not an endorsement from the Commonwealth.
</div>