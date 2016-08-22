<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ tag description="Builds the CSS to create a cross browser compatible box shadow" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="pageType"   required="true"	 rtexprvalue="true"	 description="Where we are saving the email from (ie. QUOTE, SIGNUP, SAVE_QUOTE, etc.)" %>

<div class="bkg-image"><!-- empty --></div>
<div class="distil">
    <div class="header">
        <div class="logo"><!-- empty --></div>
    </div>

    <div class="content">
        <c:choose>
            <c:when test="${pageType eq 'captcha'}">
                <h1>Are you still at your computermabob?</h1>
                <p>Keep smiling and type in the characters below.</p>
                <!-- DISTIL CAPTCHA FORM -->
            </c:when>
            <c:otherwise>
                <h1>We seem to have blocked your computermabob</h1>
                <p>Give it some time and this block may be lifted.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>