<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ tag description="Car Snapshot"%>
<%@ include file="/WEB-INF/tags/taglib.tagf"%>

<%-- ATTRIBUTES --%>
<%@ attribute name="key" required="true" rtexprvalue="true" description="The clinical category key to map to label" %>

<c:choose>
    <c:when test="${key eq 'ASSISTED_REPRODUCTIVE_SERVICES'}">Assisted reproductive services</c:when>
    <c:when test="${key eq 'BACK_NECK_AND_SPINE'}">Back, neck and spine</c:when>
    <c:when test="${key eq 'BLOOD'}">Blood</c:when>
    <c:when test="${key eq 'BONE_JOINT_AND_MUSCLE'}">Bone, joint and muscle</c:when>
    <c:when test="${key eq 'BRAIN_AND_NERVOUS_SYSTEM'}">Brain and nervous system</c:when>
    <c:when test="${key eq 'BREAST_SURGERY_MEDICALLY_NECESSARY'}">Breast surgery (medically necessary)</c:when>
    <c:when test="${key eq 'CATARACTS'}">Cataracts</c:when>
    <c:when test="${key eq 'CHEMOTHERAPY_RADIOTHERAPY_AND_IMMUNOTHERAPY_FOR_CANCER'}">Chemotherapy, radiotherapy and immunotherapy for cancer</c:when>
    <c:when test="${key eq 'DENTAL_SURGERY'}">Dental surgery</c:when>
    <c:when test="${key eq 'DIABETES_MANAGEMENT_EXCLUDING_INSULIN_PUMPS'}">Diabetes management (excluding insulin pumps)</c:when>
    <c:when test="${key eq 'DIALYSIS_FOR_CHRONIC_KIDNEY_FAILURE'}">Dialysis for chronic kidney failure</c:when>
    <c:when test="${key eq 'DIGESTIVE_SYSTEM'}">Digestive system</c:when>
    <c:when test="${key eq 'EAR_NOSE_AND_THROAT'}">Ear, nose and throat</c:when>
    <c:when test="${key eq 'EYE_NOT_CATARACTS'}">Eye (not cataracts)</c:when>
    <c:when test="${key eq 'GASTROINTESTINAL_ENDOSCOPY'}">Gastrointestinal endoscopy</c:when>
    <c:when test="${key eq 'GYNAECOLOGY'}">Gynaecology</c:when>
    <c:when test="${key eq 'HEART_AND_VASCULAR_SYSTEM'}">Heart and vascular system</c:when>
    <c:when test="${key eq 'HERNIA_AND_APPENDIX'}">Hernia and appendix</c:when>
    <c:when test="${key eq 'HOSPITAL_PSYCHIATRIC_SERVICES'}">Hospital psychiatric services</c:when>
    <c:when test="${key eq 'IMPLANTATION_OF_HEARING_DEVICES'}">Implantation of hearing devices</c:when>
    <c:when test="${key eq 'INSULIN_PUMPS'}">Insulin pumps</c:when>
    <c:when test="${key eq 'JOINT_RECONSTRUCTIONS'}">Joint reconstructions</c:when>
    <c:when test="${key eq 'JOINT_REPLACEMENTS'}">Joint replacements</c:when>
    <c:when test="${key eq 'KIDNEY_AND_BLADDER'}">Kidney and bladder</c:when>
    <c:when test="${key eq 'LUNG_AND_CHEST'}">Lung and chest</c:when>
    <c:when test="${key eq 'MALE_REPRODUCTIVE_SYSTEM'}">Male reproductive system</c:when>
    <c:when test="${key eq 'MISCARRIAGE_AND_TERMINATION_OF_PREGNANCY'}">Miscarriage and termination of pregnancy</c:when>
    <c:when test="${key eq 'PAIN_MANAGEMENT'}">Pain management</c:when>
    <c:when test="${key eq 'PAIN_MANAGEMENT_WITH_DEVICE'}">Pain management with device</c:when>
    <c:when test="${key eq 'PALLIATIVE_CARE'}">Palliative care</c:when>
    <c:when test="${key eq 'PLASTIC_AND_RECONSTRUCTIVE_SURGERY_MEDICALLY_NECESSARY'}">Plastic and reconstructive surgery (medically necessary)</c:when>
    <c:when test="${key eq 'PODIATRIC_SURGERY_PROVIDED_BY_AN_ACCREDITED_PODIATRIC_SURGEON'}">Podiatric surgery (provided by a registered podiatric surgeon)</c:when>
    <c:when test="${key eq 'PREGNANCY_AND_BIRTH'}">Pregnancy and birth</c:when>
    <c:when test="${key eq 'REHABILITATION'}">Rehabilitation</c:when>
    <c:when test="${key eq 'SKIN'}">Skin</c:when>
    <c:when test="${key eq 'SLEEP_STUDIES'}">Sleep studies</c:when>
    <c:when test="${key eq 'TONSILS_ADENOIDS_AND_GROMMETS'}">Tonsils, adenoids and grommets</c:when>
    <c:when test="${key eq 'WEIGHT_LOSS_SURGERY'}">Weight loss surgery</c:when>
    <c:otherwise>Unmapped benefit</c:otherwise>
</c:choose>