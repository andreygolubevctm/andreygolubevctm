package com.ctm.web.health.apply.model.request.fundData.membership.eligibility;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonValue;

public enum EligibilitySubReasonID {

    //Serving and Ex 001 and 002
    RAN("RAN", "RAN"),
    ARA("ARA", "ARA"),
    RAAF("RAAF", "RAAF"),
    CADETS("CA", "Cadets"),
    UNKOWN("005", "Unknown"),
    //Contractor 003
    EmployeeDoD("001", "DPT of Defence Employee"),
    Turbomeca("002", "Turbomeca"),
    Sensis("003", "Sensis"),
    Morpho("004", "Morpho"),
    OtherCont("005", "Other"),
    APS("006", "APS"),
    NavyHealth("007", "Navy Health"),
    Pentarch("008", "Pentarch"),
    AGD("009", "AGD"),
    AustDefenceApparel("010", "Aust Defence Apparel"),
    HenkelAustralia("011", "Henkel Australia"),
    AWBell("013", "A W Bell"),
    IHS("014", "A W Bell"),
    Safran("015", "Safran"),
    Agilent("016", "Agilent"),
    ASC("017", "ASC"),
    BAESystems("018", "BAE Systems"),
    BruckTextiles("019", "Bruck Textiles"),
    Rapiscan("020", "Rapiscan"),
    IHSAus("022", "IHS Australia"),
    Yetimo("023", "Yetimo Marketing"),
    ClassicSportsware("024", "Classic Sportsware"),
    WHFGroup("025", "WHF Group"),
    Bellinger("026", "Bellinger"),
    QinetiQ("027", "QinetiQ"),
    NTSS("028", "NTSS"),
    KeysightTech("029", "Keysight Technology"),
    ESRI("030", "ESRI Australia"),
    Raytheon("031", "Raytheon Australia"),
    CEA("032", "CEA Technologies"),
    DelawareNorth("033", "Delaware North Companies"),
    Simplot("034", "Simplot Australia"),
    Choosewell("035", "Choosewell"),
    GHD("036", "GHD"),
    SMEC("037", "SMEC"),
    DefenceCare("038", "Defence Care"),
    RSLNSW("039", "RSL NSW"),
    Fujitsu("040", "Fujitsu"),
    Airbus("041", "Airbus Australia"),
    AME("12", "AME"),
    DanaAus("21", "Dana Australia"),
    Noventus("29", "Noventus"),
    ExelisC4i("30", "Exelis C4i"),
    Extel("31", "Extel"),
    Relegen("35", "Relegen"),

    //Reservist 004
    RANR("RANR", "RANR"),
    ARES("ARES", "ARES"),
    AFRES("AFRES", "AFRES"),

    //Former 005
    Reservist("RE", "Reservist"),
    EmployeeContractor("EmpCR", "employee of Contractor"),
    FormerEmployeeDoD("EmpDOD", "Employee of Department of Defence"),
    EmployeeTurbomeca("EmpT", "Employee of Turbomeca"),
    EmployeeSensis("EmpS", "Employee of Sensis"),
    EmployeeMorpho("EmpM", "Employee of Morpho"),
    FormerCadet("CA", "Cadet"),
    Dependent("DE", "Dependent"),
    NavyHealthMember("NavMEM", "Navy Health Member"),

    //Family 006
    FamCadet("CFC", "Current/Former Cadet"),
    FamReservist("002", "Current/Former Reservist"),
    FamEmployeeContractor("EmpCR", "employee of Contractor"),
    FamEmployeeDoD("EmpDOD", "Employee of Department of Defence"),
    FamEmployeeMorpho("EmpM", "Employee of Morpho"),
    FamEmployeeSensis("EmpS", "Employee of Sensis"),
    FamEmployeeTurbomeca("EmpT", "Employee of Turbomeca"),
    FamARA("SESARA", "Serving/Ex-Serving ARA"),
    FamRAAF("SESRAAF", "Serving/Ex-Serving RAAF"),
    FamRAN("SESRAN", "Serving/Ex-Serving RAN"),
    FamADF("SESADF", "Serving/Ex-Serving ADF"),
    FamMember("CFM", "Current/Former Member"),
    FamEligible("EP", "Eligible Person"),

    //Other 007
    Other("OTH", "Other"),

    //Contractor Family 008
    ContractorFamilyAWBell("AB","A W Bell"),
    ContractorFamilyAGD("AGD", "AGD"),
    ContractorFamilyAgilent("AG", "Agilent"),
    ContractorFamilyAME("AME", "AME"),
    ContractorFamilyAPS("APS", "APS"),
    ContractorFamilyASC("ASC", "ASC"),
    ContractorFamilyAusDefenceApparel("ADA", "Aust Defence Apparel"),
    ContractorFamilyBAE("BAES", "BAE Systems"),
    ContractorFamilyBruck("BT", "Bruck Textiles"),
    ContractorFamilyDptDefence("DODE", "Dpt of Defence Employee"),
    ContractorFamilyHenkelAus("HENKELAU", "Henkel Australia"),
    ContractorFamilyIHS("HIS", "IHS"),
    ContractorFamilyMorpho("013", "Morpho"),
    ContractorFamilyNavyHealth("014", "Navy Health"),
    ContractorFamilyOther("015", "Other"),
    ContractorFamilyPentarch("016", "Pentarch"),
    ContractorFamilySafran("SF", "Safran"),
    ContractorFamilySensis("S","Sensis"),
    ContractorFamilyTurbomeca("T", "Turbomeca"),
    ContractorFamilyDana("021", "Dana Australia"),
    ContractorFamilyKeysightTech("KT", "Keysight Technologies"),
    ContractorFamilyEsriAust("023", "ESRI Australia"),
    ContractorFamilyRaytheonAus("RAYAUS", "Raytheon Australia"),
    ContractorFamilyRapiscan("RAPI", "Rapiscan"),

    //Dept of Defense 009
    Employee("001", "Employee");

    @JsonIgnore
    private final String code;
    @JsonIgnore
    private final String description;

    EligibilitySubReasonID(final String code, final String description) {
        this.code = code;
        this.description = description;
    }

    @JsonValue
    public String getName() {
        return name();
    }

    @JsonCreator
    public static EligibilitySubReasonID findByCode(final String code) {
        if(code == null) {
            return UNKOWN;
        }
        for (final EligibilitySubReasonID t : EligibilitySubReasonID.values()) {
            if (code.equalsIgnoreCase(t.getCode())) {
                return t;
            }
        }
        return UNKOWN;
    }

    @JsonIgnore
    public String getCode() {
        return code;
    }

    @JsonIgnore
    public String getDescription() {
        return description;
    }

    public static EligibilitySubReasonID fromValue(final String v) {
        return findByCode(v);
    }

}
