<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<div class="dropdown-container">
    <form class="benefits-component">

        <div class="scrollable row">

            <div class="hidden-xs col-sm-12">
                <h2>Choosing Your Cover</h2>
                <p>You can tailor your health insurance comparison by selecting benefits that best suit your needs and personal situation. Based on the information you have given us, we have
                    preselected a few benefits for you which you can select or unselect to suit your needs.</p>
                <p>The benefits you choose will help determine the price of the policies you are comparing. You can choose from <strong>Hospital</strong>, <strong>Extras</strong> or both by clicking
                    the YES/NO buttons for each, and then selecting your benefits.
                <p>Please note that some policies may automatically include unselected benefits as many health funds have package deals as part of their policy options.</p>

                <div class="hr mt"></div>
            </div>

            <div class="benefits-list col-sm-12">
                <div class="row benefit-row">
                    <%-- Note: ${resultTemplateItems} is a request scoped variable on health_quote.jsp page - as it is used in multiple places --%>
                    <c:forEach items="${resultTemplateItems}" var="selectedValue">
                        <health_v1:benefitsItem item="${selectedValue}"/>
                    </c:forEach>
                </div>

                <div class="row">
                    <div class="col-sm-12">
                        <simples:dialogue id="46" vertical="health" />
                        <simples:dialogue id="118" vertical="health" />
                    </div>
                </div>

                <div class="row accident-only-container">

                    <div class="col-sm-12">
                        <h4>Limited Cover</h4>
                        <c:set var="fieldXpath" value="health/situation/accidentOnlyCover"/>
                        <field_v2:checkbox xpath="${fieldXpath}" id="accidentCover" required="false" title="Limited Cover" value="Y" label="true"/>
                        <simples:dialogue id="44" vertical="health" mandatory="true" />
                    </div>
                </div>
            </div>

            <div class="ambulance col-sm-12">
                <div class="hr mb mt"></div>
                <%-- FYI, ambulance is not in the correct place as in the concept designs, if this is an issue and needs to move, you will have to do it via js --%>
                <h6>Ambulance Cover</h6>
                <p>Note that ambulance cover:</p>
                <ul class="themed">
                    <li>will vary between health funds and policies</li>
                    <li>can be covered under Hospital or Extras or both</li>
                    <li>is automatically covered by the State in both Queensland and Tasmania</li>
                </ul>
            </div>

        </div>
        <%-- /scrollable --%>


        <div class=" footer">
            <button type="button" class="btn btn-cancel popover-mode">Cancel</button>
            <button type="button" class="btn btn-save popover-mode">Save changes</button>
            <a class="btn btn-save journey-mode" href="javascript:;">Continue <span class="icon icon-arrow-right"></span></a>
        </div>

    </form>
</div>
