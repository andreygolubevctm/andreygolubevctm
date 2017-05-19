<%@ tag description="Australian Government Rebate rebate table"%>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

{{ if (obj.rebateTierTable) { }}
<div class="agrRebateTierTable">
    <table class="agrRebateTiers">
        <caption><span class="sr-only">Australian Government Private Health Insurance Rebate</span></caption>
        <thead>
            <tr>
                <th scope="col" class="rebateTier">TIER</th>
                <th scope="col" class="rebateIncomeRange">INCOME RANGE</th>
                <th scope="col" class="rebatePercent">REBATE</th>
            </tr>
        </thead>
        <tbody>
    {{ obj.rebateTierTable.forEach(function(rebateRow) { }}
            <tr class="rebateTier">
                <td>{{= rebateRow.label }}</td>
                <td class="rebateIncomeRange">
                    <span>{{= rebateRow.incomeRange }}</span>
                </td>
                <td class="rebatePercent">
                    <span>
                    {{ if (rebateRow.rebate > 0) { }}
                        {{= rebateRow.rebate+'%' }}
                    {{ } else { }}
                        {{= 'No Rebate' }}
                    {{ } }}
                    </span>
                </td>
            </tr>
    {{ }); }}
        </tbody>
    </table>
</div>
{{ } }}