<div class="row benefitRow">
    <div class="col-xs-7 newBenefitRow benefitRowTitle">
        {{ if (expanded) { }}
            <span class="selectedExtrasIcon"></span>
        {{ } }}
        <div class="benefitRowTableCell">
            {{= benefitName || key.replace(/([A-Z])/g, ' $1').trim() }}
            <a class="extrasCollapseContentLink" data-toggle="collapse" href="#extrasCollapsedContent-{{= key }}" aria-expanded="{{= expanded}}" aria-controls="collapseExample">
                <span class="{{= expanded ? 'icon-angle-up' : 'icon-angle-down' }}"></span><span>{{= expanded ? '&nbsp;Less details' : '&nbsp;More details' }}</span>
            </a>
        </div>
    </div>
    <div class="col-xs-2 newBenefitRow benefitRowTitle align-center">
        {{ var coverType = window.meerkat.modules.healthAboutYou.getSituation(); }}
        {{ if((coverType === 'C' || coverType === 'SPF' || coverType === 'F') && benefit.benefitLimits.perPerson && (benefit.benefitLimits.perPerson !== '-')) { }}
        <div>per person: {{= benefit.benefitLimits.perPerson ? benefit.benefitLimits.perPerson : '' }}</div>
        {{ } }}
        {{ if(benefit.benefitLimits.perPolicy !== '-') { }}
        <div>per policy: {{= benefit.benefitLimits.perPolicy ? benefit.benefitLimits.perPolicy : '' }}</div>
        {{ } }}
    </div>
    <div class="col-xs-1 newBenefitRow benefitRowTitle">
        <span class="newBenefitStatus benefitStatusIcon_{{= benefit.covered}}"></span>
    </div>
    <div class="col-xs-2 newBenefitRow benefitRowTitle align-center">
        {{= benefit.waitingPeriod.substring(0, 20) }}
    </div>
</div>
<div class="row collapse benefitCollapsedContent {{= expanded ? 'in' : '' }}" id="extrasCollapsedContent-{{= key }}" aria-expanded="{{= expanded}}">
    <div class="col-xs-12">
        <div class="row">
            <div class="col-xs-7">
                <div class="row">
                    <div class="col-xs-12 extraBenefitSubHeading"><strong>Annual Limits:</strong></div>
                    {{ if (benefit.benefitLimits !== undefined) { }}
                    <div class="col-xs-12">
                        {{ _.each(benefit.benefitLimits, function (option, key) { }}
                        {{ var situation = window.meerkat.modules.health.getSituation(); }}
                        {{ var isSingle = situation[0] === 'S' || situation === 'ESF'; }}
                        {{ var trimmedKey = key.replace(/([A-Z])/g, ' $1').trim().toLowerCase(); }}
                        {{ if(isSingle && trimmedKey === 'per person') { }}
                        {{ return; }}
                        {{ } }}
                        {{ if(key !== 'annualLimit') { }}
                        <div class="row">
                            <div class="col-xs-4 extraBenefitOption">
                                {{ var benefitLimitsName = key.replace(/([A-Z])/g, ' $1').trim(); }}
                                {{ if(featureIteratorChild) { }}
                                {{ _.each(featureIteratorChild.children, function (child) { }}
                                {{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
                                {{ benefitLimitsName = child.safeName; }}
                                {{ } }}
                                {{ }); }}
                                {{= benefitLimitsName }}
                                {{ } else { }}
                                {{= benefitLimitsName }}
                                {{ } }}
                            </div>
                            <div class="col-xs-8 extraBenefitOption align-center">
                                {{ if(!option || option.trim() === '-') { }}
                                None
                                {{ } else { }}
                                {{= option }}
                                {{ } }}
                            </div>
                        </div>
                        {{ } }}
                        {{ }); }}
                        {{ if(benefit.groupLimit) { }}
                        {{ _.each(benefit.groupLimit, function (option, key) { }}
                        {{ if(key !== 'annualLimit') { }}
                        <div class="row">
                            <div class="col-xs-4 extraBenefitOption">
                                {{ var benefitGroupLimitName = key.replace(/([A-Z])/g, ' $1').trim(); }}
                                {{ if(featureIteratorChild) { }}
                                {{ _.each(featureIteratorChild.children, function (child) { }}
                                {{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
                                {{ benefitGroupLimitName = child.safeName; }}
                                {{ } }}
                                {{ }); }}
                                {{= benefitGroupLimitName  }}
                                {{ } else { }}
                                {{= benefitGroupLimitName }}
                                {{ } }}
                            </div>
                            <div class="col-xs-8 extraBenefitOption align-center">
                                {{ if(!option || option.trim() === '-') { }}
                                None
                                {{ } else { }}
                                {{= option }}
                                {{ } }}
                            </div>
                        </div>
                        {{ } }}
                        {{ }); }}
                        {{ } }}
                    </div>
                    {{ } }}
                </div>
            </div>
            <div class="col-xs-5">
                <div class="row extraBenefitSection">
                    <div class="col-xs-12 extraBenefitSubHeading"><strong>Claim Benefit:</strong></div>
                    <div class="col-xs-12">
                        {{ if (benefit.benefits !== undefined) { }}
                        {{ var dentalBenefitsTotalCost = 0; }}
                        {{ _.each(benefit.benefits, function (option, key) { }}
                        {{ var situation = window.meerkat.modules.health.getSituation(); }}
                        {{ var isSingle = situation[0] === 'S' || situation === 'ESF'; }}
                        {{ var trimmedKey = key.replace(/[0-9]/g, '').replace(/([A-Z])/g, ' $1').trim(); }}
                        {{ if(isSingle && trimmedKey === 'per person') { }}
                        {{ return; }}
                        {{ } }}
                        <div class="row">
                            <div class="col-xs-9 extraBenefitOption">
                                {{ if(featureIteratorChild) { }}
                                {{ var benefitLimitsName = ''; }}
                                {{ _.each(featureIteratorChild.children, function (child) { }}
                                {{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
                                {{ benefitLimitsName = child.safeName; }}
                                {{ } }}
                                {{ }); }}
                                {{= benefitLimitsName }}
                                {{ } }}
                            </div>
                            <div class="col-xs-3 extraBenefitOption align-center">
                                {{ if(!option) { }}
                                None
                                {{ } else { }}
                                {{= option }}
                                {{ } }}
                            </div>
                        </div>
                        {{ }); }}
                        {{ if(benefitName === 'General Dental') { }}
                        {{ if(benefit.benefits.DentalGeneral012PeriodicExam.indexOf('$') !== -1) { }}
                        {{ if(benefit.benefits.DentalGeneral012PeriodicExam) { }}
                        {{ dentalBenefitsTotalCost += parseFloat(benefit.benefits.DentalGeneral012PeriodicExam.replace('$', '')); }}
                        {{ } }}
                        {{ if(benefit.benefits.DentalGeneral114ScaleClean) { }}
                        {{ dentalBenefitsTotalCost += parseFloat(benefit.benefits.DentalGeneral114ScaleClean.replace('$', '')); }}
                        {{ } }}
                        {{ if(benefit.benefits.DentalGeneral121Fluoride) { }}
                        {{ dentalBenefitsTotalCost += parseFloat(benefit.benefits.DentalGeneral121Fluoride.replace('$', '')); }}
                        {{ } }}
                        {{ dentalBenefitsTotalCost = '$' + String(dentalBenefitsTotalCost.toFixed(2)); }}
                        {{ } }}
                        {{ if(benefit.benefits.DentalGeneral012PeriodicExam.indexOf('%') !== -1) { }}
                        {{ dentalBenefitsTotalCost = benefit.benefits.DentalGeneral012PeriodicExam; }}
                        {{ } }}
                        <div class="row">
                            <div class="col-xs-9 extraBenefitOption">
                                <span class="text-highlight">So for your periodic check-up, scale and clean, and fluoride treatment, you'll receive:</span>
                            </div>
                            <div class="col-xs-3 extraBenefitOption align-center">
                                <span class="text-highlight">{{= dentalBenefitsTotalCost }}</span>
                            </div>
                        </div>
                        {{ } }}
                        {{ } }}
                        {{ _.each(benefit, function (option, key) { }}
                        {{ if (key === 'benefitPayableInitial' || key === 'benefitpayableSubsequent' || key === 'listBenefitExample') { }}
                        <div class="row">
                            <div class="col-xs-4 extraBenefitOption">
                                {{ if(featureIteratorChild) { }}
                                {{ var benefitLimitsName = ''; }}
                                {{ _.each(featureIteratorChild.children, function (child) { }}
                                {{ if(child.resultPath.substr(child.resultPath.lastIndexOf('.') + 1) === key) { }}
                                {{ benefitLimitsName = child.safeName; }}
                                {{ } }}
                                {{ }); }}
                                {{= benefitLimitsName }}
                                {{ } }}
                            </div>
                            <div class="col-xs-8 extraBenefitOption align-center">
                                {{ if(!option || option.trim() === '-') { }}
                                None
                                {{ } else { }}
                                {{= option }}
                                {{ } }}
                            </div>
                        </div>
                        {{ } }}
                        {{ }); }}
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="col-xs-4">&nbsp;</div>

    {{ if (benefit.hasSpecialFeatures) { }}
    <div class="col-xs-12">
        <div class="row">
            <div class="col-xs-12 extraBenefitSubHeading"><strong>Extra info:</strong></div>
            <div class="col-xs-12 extraBenefitOption">{{= benefit.hasSpecialFeatures }}</div>
        </div>
    </div>
    {{ } }}
</div>