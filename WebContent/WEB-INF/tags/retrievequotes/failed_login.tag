<%@ tag description="Failed Login" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<core:js_template id="failed-login-template">

    <div class="row">

        <div class="col-xs-12">

            <p>Unfortunately we were unable to retrieve your insurance quotes.</p>
            {{ if(obj.suspended) { }}
                <p>
                    Your account has been suspended for 30 minutes or until you
                    <a id="js-too-many-attempts" href="javascript:;">
                        <strong>reset your password</strong></a>.
                </p>
            {{ } else { }}
                <p>{{= obj.errorMessage }}</p>
            {{ } }}
            <p>
                Click the button below to return to the "Retrieve Your Quotes" page and try again.
            </p>

        </div>
    </div>
</core:js_template>