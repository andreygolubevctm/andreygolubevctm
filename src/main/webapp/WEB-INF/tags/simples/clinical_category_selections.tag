<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<c:if test="${callCentre}">

    <c:set var="categorySelectHospital"><c:out value="${data['health/benefits/categorySelectHospital']}" escapeXml="true"/></c:set>
    <c:set var="categorySelectHospitalLabel">
        <c:choose>
            <c:when test="${categorySelectHospital eq 'NEW_TO_HEALTH_INSURANCE'}">New to health insurance</c:when>
            <c:when test="${categorySelectHospital eq 'GROWING_FAMILY'}">Growing family</c:when>
            <c:when test="${categorySelectHospital eq 'ESTABLISHED_FAMILY'}">Established family</c:when>
            <c:when test="${categorySelectHospital eq 'PEACE_OF_MIND'}">Peace of mind</c:when>
            <c:when test="${categorySelectHospital eq 'COMPREHENSIVE_COVER'}">Comprehensive cover</c:when>
            <c:when test="${categorySelectHospital eq 'REDUCE_TAX'}">Reduce tax</c:when>
            <c:otherwise>Specific cover</c:otherwise>
        </c:choose>
    </c:set>

    <c:set var="quickSelectHospital"><c:out value="${data['health/benefits/quickSelectHospital']}" escapeXml="true"/></c:set>
    <c:set var="quickSelectHospitalLabel">
        <c:if test="${not empty quickSelectHospital}">
            <c:forEach items="${quickSelectHospital}" var="qsItem" varStatus="loop">
                <c:choose>
                    <c:when test="${qsItem eq 'BONE_MUSCLE_AND_JOINT_RECONSTRUCTION'}">Bone, muscle and joint reconstruction</c:when>
                    <c:when test="${qsItem eq 'CANCER_COVER'}">Cancer cover</c:when>
                    <c:when test="${qsItem eq 'CHRONIC_BACK_ISSUES'}">Chronic back issues</c:when>
                    <c:when test="${qsItem eq 'EAR_NOSE_THROAT'}">Ear, nose and throat</c:when>
                    <c:when test="${qsItem eq 'JOINT_REPLACEMENT'}">Joint replacement</c:when>
                    <c:when test="${qsItem eq 'MEDICALLY_NECESSARY_PLASTIC_AND_RECONSTRUCTIVE_SURGERY'}">Plastic and reconstructive surgery (medically necessary)</c:when>
                    <c:when test="${qsItem eq 'PREGNANCY_COVER'}">Pregnancy cover</c:when>
                    <c:otherwise>Specific cover</c:otherwise>
                </c:choose>
                <c:if test="${!loop.last}">,&nbsp;</c:if>
            </c:forEach>
        </c:if>
    </c:set>

    <c:set var="selectedClinicalCategoriesLabel" value="" />
    <c:if test="${not empty data['health/benefits/benefitsExtras/ASSISTED/REPRODUCTIVE/SERVICES']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="ASSISTED_REPRODUCTIVE_SERVICES" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/BACK/NECK/AND/SPINE']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="BACK_NECK_AND_SPINE" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/BLOOD']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="BLOOD" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/BONE/JOINT/AND/MUSCLE']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="BONE_JOINT_AND_MUSCLE" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/BRAIN/AND/NERVOUS/SYSTEM']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="BRAIN_AND_NERVOUS_SYSTEM" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/BREAST/SURGERY/MEDICALLY/NECESSARY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="BREAST_SURGERY_MEDICALLY_NECESSARY" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/CATARACTS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="CATARACTS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/CHEMOTHERAPY/RADIOTHERAPY/AND/IMMUNOTHERAPY/FOR/CANCER']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="CHEMOTHERAPY_RADIOTHERAPY_AND_IMMUNOTHERAPY_FOR_CANCER" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/DENTAL/SURGERY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="DENTAL_SURGERY" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/DIABETES/MANAGEMENT/EXCLUDING/INSULIN/PUMPS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="DIABETES_MANAGEMENT_EXCLUDING_INSULIN_PUMPS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/DIALYSIS/FOR/CHRONIC/KIDNEY/FAILURE']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="DIALYSIS_FOR_CHRONIC_KIDNEY_FAILURE" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/DIGESTIVE/SYSTEM']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="DIGESTIVE_SYSTEM" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/EAR/NOSE/AND/THROAT']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="EAR_NOSE_AND_THROAT" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/EYE/NOT/CATARACTS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="EYE_NOT_CATARACTS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/GASTROINTESTINAL/ENDOSCOPY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="GASTROINTESTINAL_ENDOSCOPY" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/GYNAECOLOGY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="GYNAECOLOGY" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/HEART/AND/VASCULAR/SYSTEM']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="HEART_AND_VASCULAR_SYSTEM" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/HERNIA/AND/APPENDIX']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="HERNIA_AND_APPENDIX" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/HOSPITAL/PSYCHIATRIC/SERVICES']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="HOSPITAL_PSYCHIATRIC_SERVICES" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/IMPLANTATION/OF/HEARING/DEVICES']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="IMPLANTATION_OF_HEARING_DEVICES" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/INSULIN/PUMPS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="INSULIN_PUMPS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/JOINT/RECONSTRUCTIONS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="JOINT_RECONSTRUCTIONS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/JOINT/REPLACEMENTS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="JOINT_REPLACEMENTS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/KIDNEY/AND/BLADDER']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="KIDNEY_AND_BLADDER" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/LUNG/AND/CHEST']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="LUNG_AND_CHEST" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/MALE/REPRODUCTIVE/SYSTEM']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="MALE_REPRODUCTIVE_SYSTEM" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/MISCARRIAGE/AND/TERMINATION/OF/PREGNANCY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="MISCARRIAGE_AND_TERMINATION_OF_PREGNANCY" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/PAIN/MANAGEMENT']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="PAIN_MANAGEMENT" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/PAIN/MANAGEMENT/WITH/DEVICE']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="PAIN_MANAGEMENT_WITH_DEVICE" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/PALLIATIVE/CARE']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="PALLIATIVE_CARE" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/PLASTIC/AND/RECONSTRUCTIVE/SURGERY/MEDICALLY/NECESSARY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="PLASTIC_AND_RECONSTRUCTIVE_SURGERY_MEDICALLY_NECESSARY" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/PODIATRIC/SURGERY/PROVIDED/BY/AN/ACCREDITED/PODIATRIC/SURGEON']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="PODIATRIC_SURGERY_PROVIDED_BY_AN_ACCREDITED_PODIATRIC_SURGEON" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/PREGNANCY/AND/BIRTH']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="PREGNANCY_AND_BIRTH" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/REHABILITATION']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="REHABILITATION" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/SKIN']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="SKIN" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/SLEEP/STUDIES']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="SLEEP_STUDIES" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/TONSILS_ADENOIDS_AND_GROMMETS']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="TONSILS_ADENOIDS_AND_GROMMETS" /></c:set>
    </c:if>
    <c:if test="${not empty data['health/benefits/benefitsExtras/WEIGHT/LOSS/SURGERY']}">
        <c:set var="selectedClinicalCategoriesLabel">${selectedClinicalCategoriesLabel}<c:if test="${not empty selectedClinicalCategoriesLabel}">,&nbsp;</c:if><simples:clinical_category_mappings key="WEIGHT_LOSS_SURGERY" /></c:set>
    </c:if>

    <c:set var="modalContent">
        <div id='usersClinicalCategorySelectionsModal'>
            <div class='row'>
                <div class='col-xs-12 col-sm-2 title'>Tier 2</div>
                <div class='col-xs-12 col-sm-10'>${categorySelectHospitalLabel}</div>
            </div>
            <div class='row'><hr></div>
            <div class='row'>
                <div class='col-xs-12 col-sm-2 title'>Tier 3</div>
                <div class='col-xs-12 col-sm-10'>${quickSelectHospitalLabel}</div>
            </div>
            <div class='row'><hr></div>
            <div class='row'>
                <div class='col-xs-12 col-sm-2 title'>Tier 4</div>
                <div class='col-xs-12 col-sm-10'>${selectedClinicalCategoriesLabel}</div>
            </div>
        </div>
    </c:set>

    <div class="sidebar-box hidden-sm usersClinicalCategorySelectionsModal hidden">
        <div>
            <a class="dialogPop" data-content="${modalContent}" title="Customer's online Hospital selections">View customer's online Hospital selections</a>
        </div>
    </div>
</c:if>