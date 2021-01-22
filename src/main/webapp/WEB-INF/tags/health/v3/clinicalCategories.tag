<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<form_v2:fieldset legend="" postLegend="" id="clinicalCategoriesToggle" className="${fieldsetClass} clinicalCategoriesForceHide" >
    <h3>Clinical Categories</h3>
    <span class="health-icon icon-health-chevron"></span>
</form_v2:fieldset>
<form_v2:fieldset legend="" postLegend="" id="clinicalCategoriesContent" className="${fieldsetClass} clinicalCategoriesForceHide" >
    <div id="benefits-list-hospital" class="children healthBenefits hasIcons">
    
        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/ASSISTED/REPRODUCTIVE/SERVICES"
                code="ASSISTED_REPRODUCTIVE_SERVICES"
                groups="AssistedReproductive"
                title="Assisted reproductive services"
                caption="Hospital treatment for fertility treatments or procedures."
                description="<ul><li>For example: retrieval of eggs or sperm, In vitro Fertilisation (IVF), and Gamete Intra-fallopian Transfer (GIFT).</li><li>Treatment of the female reproductive system is listed separately under Gynaecology.</li><li>Pregnancy and birth-related services are listed separately under Pregnancy and birth.</li></ul>"
                id="32996" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/BACK/NECK/AND/SPINE"
                code="BACK_NECK_AND_SPINE"
                groups="BackSurgery,Cancer"
                title="Back, neck and spine"
                caption="Hospital treatment for the investigation and treatment of the back, neck and spinal column, including spinal fusion."
                description="<ul><li>For example: sciatica, prolapsed or herniated disc, spinal disc replacement, and spine curvature disorders such as scoliosis, kyphosis and lordosis.</li><li>Joint replacements are listed separately under Joint replacements.</li><li>Joint fusions are listed separately under Bone, joint and muscle.</li><li>Spinal cord conditions are listed separately under Brain and nervous system.</li><li>Management of back pain is listed separately under Pain management.</li><li>Pain management that requires a device is listed separately under Pain management with device.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32987" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/BLOOD"
                code="BLOOD"
                groups="Cancer"
                title="Blood"
                caption="Hospital treatment for the investigation and treatment of blood and blood-related conditions."
                description="<ul><li>For example: blood clotting disorders and bone marrow transplants.</li><li>Treatment for cancers of the blood is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32986" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/BONE/JOINT/AND/MUSCLE"
                code="BONE_JOINT_AND_MUSCLE"
                groups="BoneMuscleJointRecon,BackSurgery,Cancer,JointReplacement"
                title="Bone, joint and muscle"
                caption="Hospital treatment for the investigation and treatment of diseases, disorders and injuries of the musculoskeletal system."
                description="<ul><li>For example: carpal tunnel, fractures, hand surgery, joint fusion, bone spurs, osteomyelitis and bone cancer.</li><li>Chest surgery is listed separately under Lung and chest.</li><li>Spinal cord conditions are listed separately under Brain and nervous system.</li><li>Spinal column conditions are listed separately under Back, neck and spine.</li><li>Joint reconstructions are listed separately under Joint reconstructions.</li><li>Joint replacements are listed separately under Joint replacements.</li><li>Podiatric surgery performed by a registered podiatric surgeon is listed separately under Podiatric surgery (provided by a registered podiatric surgeon).</li><li>Management of back pain is listed separately under Pain management. Pain management that requires a device is listed separately under Pain management with device.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32970" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/BRAIN/AND/NERVOUS/SYSTEM"
                code="BRAIN_AND_NERVOUS_SYSTEM"
                groups="Cancer"
                title="Brain and nervous system"
                caption="Hospital treatment for the investigation and treatment of the brain, brain-related conditions, spinal cord and peripheral nervous system."
                description="<ul><li>For example: stroke, brain or spinal cord tumours, head injuries, epilepsy and Parkinson’s disease.</li><li>Treatment of spinal column (back bone) conditions is listed separately under Back, neck and spine.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32966" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/BREAST/SURGERY/MEDICALLY/NECESSARY"
                code="BREAST_SURGERY_MEDICALLY_NECESSARY"
                groups="Cancer,PlasticNonCosmetic"
                title="Breast surgery (medically necessary)"
                caption="Hospital treatment for the investigation and treatment of breast disorders and associated lymph nodes, and reconstruction and/or reduction following breast surgery or a preventative mastectomy."
                description="<ul><li>For example: breast lesions, breast tumours, asymmetry due to breast cancer surgery, and gynecomastia.</li><li>This clinical category does not require benefits to be paid for cosmetic breast surgery that is not medically necessary.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32982" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/CATARACTS"
                code="CATARACTS"
                groups="CataractEyeLens"
                title="Cataracts"
                caption="Hospital treatment for surgery to remove a cataract and replace with an artificial lens."
                description=""
                id="32992" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/CHEMOTHERAPY/RADIOTHERAPY/AND/IMMUNOTHERAPY/FOR/CANCER"
                code="CHEMOTHERAPY_RADIOTHERAPY_AND_IMMUNOTHERAPY_FOR_CANCER"
                groups="Cancer"
                title="Chemotherapy, radiotherapy and immunotherapy for cancer"
                caption="Hospital treatment for chemotherapy, radiotherapy and immunotherapy for the treatment of cancer or benign tumours."
                description="<ul><li>Surgical treatment of cancer is listed separately under each body system</li></ul>"
                id="32979" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/DENTAL/SURGERY"
                code="DENTAL_SURGERY"
                groups="DentalSurgery"
                title="Dental surgery"
                caption="Hospital treatment for surgery to the teeth and gums."
                description="<ul><li>For example: surgery to remove wisdom teeth, and dental implant surgery.</li></ul>"
                id="32989" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/DIABETES/MANAGEMENT/EXCLUDING/INSULIN/PUMPS"
                code="DIABETES_MANAGEMENT_EXCLUDING_INSULIN_PUMPS"
                groups=""
                title="Diabetes management (excluding insulin pumps)"
                caption="Hospital treatment for the investigation and management of diabetes."
                description="<ul><li>For example: stabilisation of hypo- or hyper- glycaemia, contour problems due to insulin injections.</li><li>Treatment for diabetes-related conditions is listed separately under each body system affected. For example, treatment for diabetes-related eye conditions is listed separately under Eye.</li><li>Treatment for ulcers is listed separately under Skin.</li><li>Provision and replacement of insulin pumps is listed separately under Insulin pumps.</li></ul>"
                id="32983" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/DIALYSIS/FOR/CHRONIC/KIDNEY/FAILURE"
                code="DIALYSIS_FOR_CHRONIC_KIDNEY_FAILURE"
                groups="RenalDialysis"
                title="Dialysis for chronic kidney failure"
                caption="Hospital treatment for dialysis treatment for chronic kidney failure."
                description="<ul><li>For example: peritoneal dialysis and haemodialysis.</li></ul>"
                id="32994" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/DIGESTIVE/SYSTEM"
                code="DIGESTIVE_SYSTEM"
                groups="Cancer"
                title="Digestive system"
                caption="Hospital treatment for the investigation and treatment of the digestive system, including the oesophagus, stomach, gall bladder, pancreas, spleen, liver and bowel."
                description="<ul><li>For example: oesophageal cancer, irritable bowel syndrome, gall stones and haemorrhoids.</li><li>Endoscopy is listed separately under Gastrointestinal endoscopy. Hernia and appendicectomy procedures are listed separately under Hernia and appendix.</li><li>Bariatric surgery is listed separately under Weight loss surgery.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32974" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/EAR/NOSE/AND/THROAT"
                code="EAR_NOSE_AND_THROAT"
                groups="Cancer,ENT"
                title="Ear, nose and throat"
                caption="Hospital treatment for the investigation and treatment of the ear, nose, throat, middle ear, thyroid, parathyroid, larynx, lymph nodes and related areas of the head and neck."
                description="<ul><li>For example: damaged ear drum, sinus surgery, removal of foreign bodies, stapedectomy and throat cancer.</li><li>Tonsils, adenoids and grommets are listed separately under Tonsils, adenoids and grommets.</li><li>The implantation of a hearing device is listed separately under Implantation of hearing devices.</li><li>Orthopaedic neck conditions are listed separately under Back, neck and spine.</li><li>Sleep studies are listed separately under Sleep studies.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32968" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/EYE/NOT/CATARACTS"
                code="EYE_NOT_CATARACTS"
                groups="CataractEyeLens,Cancer"
                title="Eye (not cataracts)"
                caption="Hospital treatment for the investigation and treatment of the eye and the contents of the eye socket."
                description="<ul><li>For example: retinal detachment, tear duct conditions, eye infections and medically managed trauma to the eye.</li><li>Cataract procedures are listed separately under Cataracts.</li><li>Eyelid procedures are listed separately under Plastic and reconstructive surgery.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32967" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/GASTROINTESTINAL/ENDOSCOPY"
                code="GASTROINTESTINAL_ENDOSCOPY"
                groups="Cancer"
                title="Gastrointestinal endoscopy"
                caption="Hospital treatment for the diagnosis, investigation and treatment of the internal parts of the gastrointestinal system using an endoscope."
                description="<ul><li>For example: colonoscopy, gastroscopy, endoscopic retrograde cholangiopancreatography (ERCP).</li><li>Non-endoscopic procedures for the digestive system are listed separately under Digestive system.</li></ul>"
                id="32976" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/GYNAECOLOGY"
                code="GYNAECOLOGY"
                groups="AssistedReproductive,Cancer,Obstetric"
                title="Gynaecology"
                caption="Hospital treatment for the investigation and treatment of the female reproductive system."
                description="<ul><li>For example: endometriosis, polycystic ovaries, female sterilisation and cervical cancer.</li><li>Fertility treatments are listed separately under Assisted reproductive services.</li><li>Pregnancy and birth-related conditions are listed separately under Pregnancy and birth.</li><li>Miscarriage or termination of pregnancy is listed separately under Miscarriage and termination of pregnancy.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32977" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/HEART/AND/VASCULAR/SYSTEM"
                code="HEART_AND_VASCULAR_SYSTEM"
                groups="Cardiac,Cancer"
                title="Heart and vascular system"
                caption="Hospital treatment for the investigation and treatment of the heart, heart-related conditions and vascular system."
                description="<ul><li>For example: heart failure and heart attack, monitoring of heart conditions, varicose veins and removal of plaque from arterial walls.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32984" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/HERNIA/AND/APPENDIX"
                code="HERNIA_AND_APPENDIX"
                groups="HerniaAppendix"
                title="Hernia and appendix"
                caption="Hospital treatment for the investigation and treatment of a hernia or appendicitis."
                description="<ul><li>Digestive conditions are listed separately under Digestive system.</li></ul>"
                id="32975" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/HOSPITAL/PSYCHIATRIC/SERVICES"
                code="HOSPITAL_PSYCHIATRIC_SERVICES"
                groups="Psychiatric"
                title="Hospital psychiatric services"
                caption="Hospital treatment for the treatment and care of patients with psychiatric, mental, addiction or behavioural disorders."
                description="<ul><li>For example: psychoses such as schizophrenia, mood disorders such as depression, eating disorders and addiction therapy.</li></ul>"
                id="32964" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/IMPLANTATION/OF/HEARING/DEVICES"
                code="IMPLANTATION_OF_HEARING_DEVICES"
                groups=""
                title="Implantation of hearing devices"
                caption="Hospital treatment to correct hearing loss, including implantation of a prosthetic hearing device."
                description="<ul><li>Stapedectomy is listed separately under Ear, nose and throat.</li></ul>"
                id="32991" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/INSULIN/PUMPS"
                code="INSULIN_PUMPS"
                groups=""
                title="Insulin pumps"
                caption="Hospital treatment for the provision and replacement of insulin pumps for treatment of diabetes."
                description=""
                id="32998" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/JOINT/RECONSTRUCTIONS"
                code="JOINT_RECONSTRUCTIONS"
                groups="BoneMuscleJointRecon"
                title="Joint reconstructions"
                caption="Hospital treatment for surgery for joint reconstructions."
                description="<ul><li>For example: torn tendons, rotator cuff tears and damaged ligaments.</li><li>Joint replacements are listed separately under Joint replacements.</li><li>Bone fractures are listed separately under Bone, joint and muscle.</li><li>Procedures to the spinal column are listed separately under Back, neck and spine.</li><li>Podiatric surgery performed by a registered podiatric surgeon is listed separately under Podiatric surgery (provided by a registered podiatric surgeon).</li></ul>"
                id="32971" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/JOINT/REPLACEMENTS"
                code="JOINT_REPLACEMENTS"
                groups="JointReplacement"
                title="Joint replacements"
                caption="Hospital treatment for surgery for joint replacements, including revisions, resurfacing, partial replacements and removal of prostheses."
                description="<ul><li>For example: replacement of shoulder, wrist, finger, hip, knee, ankle, or toe joint.</li><li>Joint fusions are listed separately under Bone, joint and muscle.</li><li>Spinal fusions are listed separately under Back, neck and spine.</li><li>Joint reconstructions are listed separately under Joint reconstructions.</li><li>Podiatric surgery performed by a registered podiatric surgeon is listed separately under Podiatric surgery (provided by a registered podiatric surgeon).</li></ul>"
                id="32993" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/KIDNEY/AND/BLADDER"
                code="KIDNEY_AND_BLADDER"
                groups="Cancer"
                title="Kidney and bladder"
                caption="Hospital treatment for the investigation and treatment of the kidney, adrenal gland and bladder."
                description="<ul><li>For example: kidney stones, adrenal gland tumour and incontinence.</li><li>Dialysis is listed separately under Dialysis for chronic kidney failure.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32972" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/LUNG/AND/CHEST"
                code="LUNG_AND_CHEST"
                groups="Cancer"
                title="Lung and chest"
                caption="Hospital treatment for the investigation and treatment of the lungs, lung-related conditions, mediastinum and chest."
                description="<ul><li>For example: lung cancer, respiratory disorders such as asthma, pneumonia, and treatment of trauma to the chest.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32985" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/MALE/REPRODUCTIVE/SYSTEM"
                code="MALE_REPRODUCTIVE_SYSTEM"
                groups="Cancer"
                title="Male reproductive system"
                caption="Hospital treatment for the investigation and treatment of the male reproductive system including the prostate."
                description="<ul><li>For example: male sterilisation, circumcision and prostate cancer.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32973" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/MISCARRIAGE/AND/TERMINATION/OF/PREGNANCY"
                code="MISCARRIAGE_AND_TERMINATION_OF_PREGNANCY"
                groups="Obstetric"
                title="Miscarriage and termination of pregnancy"
                caption="Hospital treatment for the investigation and treatment of a miscarriage or for termination of pregnancy."
                description=""
                id="32978" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/PAIN/MANAGEMENT"
                code="PAIN_MANAGEMENT"
                groups="PainManagementNoDevice"
                title="Pain management"
                caption="Hospital treatment for pain management that does not require the insertion or surgical management of a device."
                description="<ul><li>For example: treatment of nerve pain and chest pain due to cancer by injection of a nerve block.</li><li>Pain management using a device (for example an infusion pump or neurostimulator) is listed separately under Pain management with device.</li></ul>"
                id="32980" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/PAIN/MANAGEMENT/WITH/DEVICE"
                code="PAIN_MANAGEMENT_WITH_DEVICE"
                groups=""
                title="Pain management with device"
                caption="Hospital treatment for the implantation, replacement or other surgical management of a device required for the treatment of pain."
                description="<ul><li>For example: treatment of nerve pain, back pain, and pain caused by coronary heart disease with a device (for example an infusion pump or neurostimulator).</li><li>Treatment of pain that does not require a device is listed separately under Pain management.</li></ul>"
                id="32999" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/PALLIATIVE/CARE"
                code="PALLIATIVE_CARE"
                groups="Palliative"
                title="Palliative care"
                caption="Hospital treatment for care where the intent is primarily providing quality of life for a patient with a terminal illness, including treatment to alleviate and manage pain."
                description=""
                id="32965" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/PLASTIC/AND/RECONSTRUCTIVE/SURGERY/MEDICALLY/NECESSARY"
                code="PLASTIC_AND_RECONSTRUCTIVE_SURGERY_MEDICALLY_NECESSARY"
                groups="GastricBanding,PlasticNonCosmetic"
                title="Plastic and reconstructive surgery (medically necessary)"
                caption="Hospital treatment which is medically necessary for the investigation and treatment of any physical deformity, whether acquired as a result of illness or accident, or congenital."
                description="<ul><li>For example: burns requiring a graft, cleft palate, club foot and angioma.</li><li>Plastic surgery that is medically necessary relating to the treatment of a skin-related condition is listed separately under Skin.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32988" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/PODIATRIC/SURGERY/PROVIDED/BY/AN/ACCREDITED/PODIATRIC/SURGEON"
                code="PODIATRIC_SURGERY_PROVIDED_BY_AN_ACCREDITED_PODIATRIC_SURGEON"
                groups=""
                title="Podiatric surgery (provided by a registered podiatric surgeon)"
                caption="Hospital treatment for the investigation and treatment of conditions affecting the foot and/or ankle, provided by a registered podiatric surgeon, but limited to cover for:· accommodation and· the cost of a prosthesis as listed in the prostheses list set out in the Private Health Insurance (Prostheses) Rules, as in force from time to time."
                description="<ul><li>Note: Insurers are not required to pay for any other benefits for hospital treatment for this clinical category but may choose to do so.</li></ul>"
                id="32990" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/PREGNANCY/AND/BIRTH"
                code="PREGNANCY_AND_BIRTH"
                groups="Obstetric"
                title="Pregnancy and birth"
                caption="Hospital treatment for investigation and treatment of conditions associated with pregnancy and child birth. Treatment for the baby is covered under the clinical category relevant to their condition. For example, respiratory conditions are covered under Lung and chest."
                description="<ul><li>Female reproductive conditions are listed separately under Gynaecology.</li><li>Fertility treatments are listed separately under Assisted reproductive services.</li><li>Miscarriage and termination of pregnancy is listed separately under Miscarriage and termination of pregnancy.</li></ul>"
                id="32995" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/REHABILITATION"
                code="REHABILITATION"
                groups="Rehabilitation"
                title="Rehabilitation"
                caption="Hospital treatment for physical rehabilitation for a patient related to surgery or illness."
                description="<ul><li>For example: inpatient and admitted day patient rehabilitation, stroke recovery, cardiac rehabilitation.</li></ul>"
                id="32963" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/SKIN"
                code="SKIN"
                groups="Cancer,PlasticNonCosmetic"
                title="Skin"
                caption="Hospital treatment for the investigation and treatment of skin, skin-related conditions and nails. The removal of foreign bodies is also included. Plastic surgery that is medically necessary and relating to the treatment of a skin-related condition is also included."
                description="<ul><li>For example: melanoma, minor wound repair and abscesses.</li><li>emoval of excess skin due to weight loss is listed separately under Weight loss surgery.</li><li>Chemotherapy and radiotherapy for cancer is listed separately under Chemotherapy, radiotherapy and immunotherapy for cancer.</li></ul>"
                id="32981" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/SLEEP/STUDIES"
                code="SLEEP_STUDIES"
                groups=""
                title="Sleep studies"
                caption="Hospital treatment for the investigation of sleep patterns and anomalies."
                description="<ul><li>For example: sleep apnoea and snoring.</li></ul>"
                id="33000" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/TONSILS_ADENOIDS_AND_GROMMETS"
                code="TONSILS_ADENOIDS_AND_GROMMETS"
                groups="Cancer,ENT"
                title="Tonsils, adenoids and grommets"
                caption="Treatment of the tonsils, adenoids, and insertion or removal of grommets."
                description=""
                id="32969" />

        <health_v3:clinicalCategoryRow
                xpath="health/benefits/benefitsExtras/WEIGHT/LOSS/SURGERY"
                code="WEIGHT_LOSS_SURGERY"
                groups="GastricBanding"
                title="Weight loss surgery"
                caption="Hospital treatment for surgery that is designed to reduce a person’s weight, remove excess skin due to weight loss and reversal of a bariatric procedure."
                description="<ul><li>For example: gastric banding, gastric bypass, sleeve gastrectomy.</li></ul>"
                id="32997" />
    </div>
</form_v2:fieldset>