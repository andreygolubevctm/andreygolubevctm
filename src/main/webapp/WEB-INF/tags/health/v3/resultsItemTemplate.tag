<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<c:set var="vertical" value="${pageSettings.getVerticalCode()}"/>
<%-- NOTE: We don't use new lines in a few places here to save on extra empty text nodes needing to be created when the template renders --%>
<core_v1:js_template id="feature-template">
    {{ var featureIterator = obj.childFeatureDetails || Features.getPageStructure(obj.featuresStructureIndexToUse); }}
    {{ var module = meerkat.modules.healthResultsTemplate; }}
    {{ var coverDate = module.getCoverDate(obj); }}
    {{ for(var i = 0; i < featureIterator.length; i++) { var ft = module.getItem(obj, featureIterator[i]); if(ft.doNotRender === true) { continue; } }}
    <div class="cell {{= ft.classString }}">
        {{ if(ft.displayItem) { }}
        {{ if(ft.type == 'category') { }}
        {{ var resultPath = ft.resultPath; }}
        {{ var benefitGroup = ''; }}
        {{ if(!_.isEmpty(resultPath)) { }}
        {{      if(resultPath.indexOf('hospital') === 0) { }}
        {{          benefitGroup = 'hospital'; }}
        {{      } else if (resultPath.indexOf('extras') === 0) { }}
        {{          benefitGroup = 'extras'; }}
        {{      } }}
        {{ } }}
        <div class="labelInColumn {{= ft.classStringForInlineLabel }}" {{=ft.labelInColumnTitle }}>
            <div class="content {{= ft.classStringForInlineLabelCover }}" data-featureId="{{= ft.id }}">
                <div class="contentInner" data-analytics="compare BL {{= benefitGroup }}">
                    <div>
                        <span class="health-icon {{= ft.iconClass }}"></span> {{= ft.safeName }} {{ if(ft.hasChildFeatures) { }}<span class="icon expander"></span>{{ } }}
                    </div>

                    <div class="benefit-container">
                        <div class="benefit-container-item {{= ft.labelInColumnContentClass }}">
                            {{ if(ft.beforeChangeDate && coverDate) { }}
                                <span {{= ft.labelInColumnContentClassApril }}>Now</span>
                            {{ } }}
                            <span class="benefit-icon" />
                        </div>
                        {{ if(ft.beforeChangeDate && coverDate) { }}
                            <div class="benefit-container-item april {{= ft.labelInColumnContentClassApril }}">
                                <span class="benefit-container-item-date">{{= coverDate}}</span>
                                <span class="benefit-icon" />
                            </div>
                        {{ } }}
                    </div>

                </div>
            </div>
        </div>{{ } }}

        {{ var hiddenResultPathsNew = ['extras.Optical.benefits.Frames', 'extras.Optical.benefits.ContactLenses', 'extras.Optical.benefits.SingleVision', 'extras.Optical.benefits.MultiVision', 'extras.DentalGeneral.benefits.DentalMajor322Extraction'] }}
        {{ var hiddenResultPathsOld = ['extras.Optical.benefits.OpticalSingleVisionLenses', 'extras.Optical.benefits.OpticalMultiFocalLenses', 'extras.DentalGeneral.benefits.DentalGeneral322Extraction', 'extras.Endodontic.benefits.AcutePeriodonalInfection','extras.Endodontic.benefits.ClinicalPeriodontalAnalysis','extras.Endodontic.benefits.RootPlanningPerTooth','extras.Endodontic.benefits.GingivectomyPerTooth','extras.Endodontic.benefits.PeriodontalFlapSurgery','extras.Endodontic.benefits.GingivalGraftImplant','extras.Endodontic.benefits.NonSurgicalPeriodonticTreatment','extras.Endodontic.benefits.PreparationOfRootCanal','extras.Endodontic.benefits.CompleteChemoMechanicalPreparationRootCanal','extras.Endodontic.benefits.RootCanalObturation', 'extras.Orthodontic.benefits.PassiveRemovableAppliance','extras.Orthodontic.benefits.MaxillaryExpansionAppliance','extras.Orthodontic.benefits.BracesProvidedGeneralDentist', 'extras.DentalMajor.benefits.AcutePeriodonalInfection','extras.DentalMajor.benefits.ClinicalPeriodontalAnalysis','extras.DentalMajor.benefits.GingivectomyPerTooth','extras.DentalMajor.benefits.PeriodontalFlapSurgery','extras.DentalMajor.benefits.GingivalGraftImplant','extras.DentalMajor.benefits.ToothColouredFilling','extras.DentalMajor.benefits.FullCrownAcrylicResinIndirect','extras.DentalMajor.benefits.FullCrownNonMetallicIndirect','extras.DentalMajor.benefits.FullCrownMetallicIndirect','extras.DentalMajor.benefits.BridgeDirectPontic','extras.DentalMajor.benefits.BridgeIndirectPontic','extras.DentalMajor.benefits.RepairCrownBridge','extras.DentalMajor.benefits.RemovalOfImplantRetentionDevice','extras.DentalMajor.benefits.ProsthesisAttachedImplant','extras.DentalMajor.benefits.InsertionOfEndosseousImplant','extras.DentalMajor.benefits.InsertionOfImplant','extras.DentalMajor.benefits.DenturesFullLower','extras.DentalMajor.benefits.DenturesFullUpper','extras.DentalMajor.benefits.CompleteMaxillaryMandibularDenture','extras.DentalMajor.benefits.OcclusalSplint', 'extras.GeneralDental.benefits.ComprehensiveExamination','extras.GeneralDental.benefits.XRay','extras.GeneralDental.benefits.CleanPolish','extras.GeneralDental.benefits.BleachingExternalToothBenefit','extras.GeneralDental.benefits.BleachingHomeApplication','extras.GeneralDental.benefits.ProvisionOfMouthguard','extras.GeneralDental.benefits.NonSurgicalExtraction','extras.GeneralDental.benefits.AdhesiveFilling1SurfacesFront','extras.GeneralDental.benefits.AdhesiveFilling2SurfacesFront','extras.GeneralDental.benefits.AdhesiveFilling3SurfacesFront','extras.GeneralDental.benefits.AdhesiveRestoration1Surfaces','extras.GeneralDental.benefits.AdhesiveRestoration2Surfaces','extras.GeneralDental.benefits.AdhesiveRestoration3Surfaces']; }}
        {{ var hiddenResultsPathForced = ['extras.Endodontic.benefits.AcutePeriodonalInfection','extras.Endodontic.benefits.ClinicalPeriodontalAnalysis','extras.Endodontic.benefits.RootPlanningPerTooth','extras.Endodontic.benefits.GingivectomyPerTooth','extras.Endodontic.benefits.PeriodontalFlapSurgery','extras.Endodontic.benefits.GingivalGraftImplant','extras.Endodontic.benefits.NonSurgicalPeriodonticTreatment','extras.Endodontic.benefits.PreparationOfRootCanal','extras.Endodontic.benefits.CompleteChemoMechanicalPreparationRootCanal','extras.Endodontic.benefits.RootCanalObturation', 'extras.Orthodontic.benefits.PassiveRemovableAppliance','extras.Orthodontic.benefits.MaxillaryExpansionAppliance','extras.Orthodontic.benefits.BracesProvidedGeneralDentist', 'extras.DentalMajor.benefits.AcutePeriodonalInfection','extras.DentalMajor.benefits.ClinicalPeriodontalAnalysis','extras.DentalMajor.benefits.GingivectomyPerTooth','extras.DentalMajor.benefits.PeriodontalFlapSurgery','extras.DentalMajor.benefits.GingivalGraftImplant','extras.DentalMajor.benefits.ToothColouredFilling','extras.DentalMajor.benefits.FullCrownAcrylicResinIndirect','extras.DentalMajor.benefits.FullCrownNonMetallicIndirect','extras.DentalMajor.benefits.FullCrownMetallicIndirect','extras.DentalMajor.benefits.BridgeDirectPontic','extras.DentalMajor.benefits.BridgeIndirectPontic','extras.DentalMajor.benefits.RepairCrownBridge','extras.DentalMajor.benefits.RemovalOfImplantRetentionDevice','extras.DentalMajor.benefits.ProsthesisAttachedImplant','extras.DentalMajor.benefits.InsertionOfEndosseousImplant','extras.DentalMajor.benefits.InsertionOfImplant','extras.DentalMajor.benefits.DenturesFullLower','extras.DentalMajor.benefits.DenturesFullUpper','extras.DentalMajor.benefits.CompleteMaxillaryMandibularDenture','extras.DentalMajor.benefits.OcclusalSplint', 'extras.GeneralDental.benefits.ComprehensiveExamination','extras.GeneralDental.benefits.XRay','extras.GeneralDental.benefits.CleanPolish','extras.GeneralDental.benefits.BleachingExternalToothBenefit','extras.GeneralDental.benefits.BleachingHomeApplication','extras.GeneralDental.benefits.ProvisionOfMouthguard','extras.GeneralDental.benefits.NonSurgicalExtraction','extras.GeneralDental.benefits.AdhesiveFilling1SurfacesFront','extras.GeneralDental.benefits.AdhesiveFilling2SurfacesFront','extras.GeneralDental.benefits.AdhesiveFilling3SurfacesFront','extras.GeneralDental.benefits.AdhesiveRestoration1Surfaces','extras.GeneralDental.benefits.AdhesiveRestoration2Surfaces','extras.GeneralDental.benefits.AdhesiveRestoration3Surfaces'] }}
        {{ var hiddenResultPaths = hiddenResultPathsOld }}

        {{ var showContent = (hiddenResultPaths.indexOf(ft.resultPath) === -1) || (ft.pathValue && hiddenResultPaths.indexOf(ft.resultPath) > -1 && hiddenResultsPathForced.indexOf(ft.resultPath) === -1) }}

        {{ if(ft.type == 'feature' && showContent) { }}<div class="c content {{= ft.contentClassString }}" data-featureId="{{= ft.id }}">{{= ft.displayValue }}</div>{{ } }}
        {{ } if(ft.displayChildren) { }}
        <div class="children {{= ft.hideChildrenClass }}" data-fid="{{= ft.id }}">
            {{ if(ft.isNotCovered) { }}<div class="content noCoverContainer"><p class="noCoverLabel">NOT COVERED IN THIS PRODUCT</p></div>{{ } }}
            {{ obj.childFeatureDetails = ft.children; }}
            {{= Results.cachedProcessedTemplates[obj.featuresTemplate](obj) }}{{ delete obj.childFeatureDetails; }}<%-- needs deleting between iterations or when all hospital selected, it  --%>
        </div>
        {{ } else { }}{{ delete obj.childFeatureDetails; }}{{ } }}
    </div>
    {{ } }}
</core_v1:js_template>
