<%@ tag description="Australian Government Rebate rebate table"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<table class="agrRebateTier20170401to20170331">
    <%-- this is example table data --%>
    <caption>Health Insurance Rebate tier 1 April 2017 to 31 March 2018</caption>
    <tr>
        <th>TIER</th>
        <th>INCOME RANGE</th>
        <th>REBATE</th>
    </tr>
    <tr>
        <td>Base tier</td>
        <td>
            <span class="single">$90,000 or less</span>
            <span class="family">$180,000 or less</span></td>
        <td>
            <span class="under65">25.934%</span>
            <span class="65to69">30.256%</span>
            <span class="70plus">34.579%</span>
        </td>
    </tr>
    <tr>
        <td>Tier 1</td>
        <td><span class="single">$90,001 - $105,000</span><span class="family">$180,001 - $210,000</span></td>
        <td>
            <span class="under65">17.289%</span>
            <span class="65to69">21.612%</span>
            <span class="70plus">25.934%</span>
        </td>
    </tr>
    <tr>
        <td>Tier 2</td>
        <td><span class="single">$105,001 - $140,000</span><span class="family">$210,001 - $280,000</span></td>
        <td>
            <span class="under65">8.644%</span>
            <span class="65to69">12.966%</span>
            <span class="70plus">17.289%</span>
        </td>
    </tr>
    <tr>
        <td>Tier 3</td>
        <td><span class="single">$140,001 +</span><span class="family">$280,001 +</span></td>
        <td>No Rebate</td>
    </tr>
</table>