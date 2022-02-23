<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<%@ attribute name="id"	 rtexprvalue="true"	 description="accordion's id" %>
<%@ attribute name="hidden"	 rtexprvalue="true"	 description="should the accordion start in a hidden state" %>

<health_v4:accordion id="${id}" hidden="${hidden}">
    <jsp:attribute name="title">
        <div class="bold inline">Switching is simple!</div> We'll handle the swap for you.
    </jsp:attribute>
    <jsp:body>
        <div class="accordion-content">
            <div class="accordion-content-icon-container">
                <span class="accordion-content-icon icon tick"></span>
            </div>
            <div>
                <div class="accordion-content-title">
                    Change funds anytime
                </div>
                <div>
                    You can change funds whenever you like. There are no cancellation fees for Health insurance. We’ll pass all your current insurance details to your new fund, for them to take care of the transfer details.</div>
            </div>
        </div>
        <div class="accordion-content">
            <div class="accordion-content-icon-container">
                <span class="accordion-content-icon icon tick"></span>
            </div>
            <div>
                <div class="accordion-content-title">
                    Your waiting periods transfer with you                
                </div>
                <div>
                    You won’t have to serve waiting periods again for the same level of benefits you were able to claim with your previous fund. Note: when it comes to Extras cover, any claims you have already made will be deducted from your new limits.</div>
            </div>
        </div>
        <div class="accordion-content">
            <div class="accordion-content-icon-container">
                <span class="accordion-content-icon icon tick"></span>
            </div>
            <div>
                <div class="accordion-content-title">
                    Get reimbursed
                </div>
                <div>
                    Your old fund will reimburse any premiums you’ve already paid in advance.
                </div>
            </div>
        </div>
    </jsp:body>
</health_v4:accordion>