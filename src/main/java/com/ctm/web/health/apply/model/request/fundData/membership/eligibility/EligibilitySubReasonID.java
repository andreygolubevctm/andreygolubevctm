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
    UNKOWN("UNK", "Unknown"),
    //Contractor 003
    EmployeeDoD("DoDE", "DPT of Defence Employee"),
    Turbomeca("T", "Turbomeca"),
    Sensis("S", "Sensis"),
    Morpho("M", "Morpho"),
    OtherCont("OTHCont", "Other"),
    APS("APS", "APS"),
    NavyHealth("NH", "Navy Health"),
    Pentarch("P", "Pentarch"),
    AGD("AGD", "AGD"),
    AustDefenceApparel("ADA", "Aust Defence Apparel"),
    HenkelAustralia("HenA", "Henkel Australia"),
    AWBell("AWB", "A W Bell"),
    IHS("IHS", "IHS"),
    Safran("SF", "Safran"),
    Agilent("A", "Agilent"),
    ASC("ASC", "ASC"),
    BAESystems("BAE", "BAE Systems"),
    BruckTextiles("BT", "Bruck Textiles"),
    Rapiscan("RAP", "Rapiscan"),
    IHSAus("IHSA", "IHS Australia"),
    Yetimo("YM", "Yetimo Marketing"),
    ClassicSportsware("CS", "Classic Sportsware"),
    WHFGroup("WHF", "WHF Group"),
    Bellinger("BELL", "Bellinger"),
    QinetiQ("QQ", "QinetiQ"),
    NTSS("NTSS", "NTSS"),
    KeysightTech("KEY", "Keysight Technology"),
    ESRI("ESRI", "ESRI Australia"),
    Raytheon("RAY", "Raytheon Australia"),
    CEA("CEA", "CEA Technologies"),
    DelawareNorth("DEL", "Delaware North Companies"),
    Simplot("SIM", "Simplot Australia"),
    Choosewell("CHO", "Choosewell"),
    GHD("GHD", "GHD"),
    SMEC("SMEC", "SMEC"),
    DefenceCare("DEFC", "Defence Care"),
    RSLNSW("RSL", "RSL NSW"),
    Fujitsu("FUJ", "Fujitsu"),
    Airbus("AIR", "Airbus Australia"),
    AME("AME", "AME"),
    DanaAus("DANA", "Dana Australia"),
    Noventus("NOV", "Noventus"),
    ExelisC4i("EXE", "Exelis C4i"),
    Extel("EXT", "Extel"),
    Relegen("REL", "Relegen"),

    //Reservist 004
    RANR("RANR", "RANR"),
    ARES("ARES", "ARES"),
    AFRES("AFRES", "AFRES"),

    //Former 005
    Reservist("RE", "Reservist"),
    EmployeeContractor("EmpCR", "Employee of Contractor"),
    FormerEmployeeDoD("EmpDOD", "Employee of Department of Defence"),
    EmployeeTurbomeca("EmpT", "Employee of Turbomeca"),
    EmployeeSensis("EmpS", "Employee of Sensis"),
    EmployeeMorpho("EmpM", "Employee of Morpho"),
    FormerCadet("CAF", "Cadet"),
    Dependent("DE", "Dependent"),
    NavyHealthMember("NavMEM", "Navy Health Member"),

    //Family 006
    FamCadet("CFC", "Current/Former Cadet"),
    FamReservist("CFR", "Current/Former Reservist"),
    FamEmployeeContractor("EmpCR", "Employee of Contractor"),
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
    ContractorFamilyAWBell("ABFam","A W Bell"),
    ContractorFamilyAGD("AGDFam", "AGD"),
    ContractorFamilyAgilent("AGFam", "Agilent"),
    ContractorFamilyAME("AMEFam", "AME"),
    ContractorFamilyAPS("APSFam", "APS"),
    ContractorFamilyASC("ASCFam", "ASC"),
    ContractorFamilyAusDefenceApparel("ADAFam", "Aust Defence Apparel"),
    ContractorFamilyBAE("BAESFam", "BAE Systems"),
    ContractorFamilyBruck("BTFam", "Bruck Textiles"),
    ContractorFamilyDptDefence("DODEFam", "Dpt of Defence Employee"),
    ContractorFamilyHenkelAus("HENKELAUFam", "Henkel Australia"),
    ContractorFamilyIHS("IHSFam", "IHS"),
    ContractorFamilyMorpho("MORFam", "Morpho"),
    ContractorFamilyNavyHealth("NHFam", "Navy Health"),
    ContractorFamilyOther("OTHFam", "Other"),
    ContractorFamilyPentarch("PENTFam", "Pentarch"),
    ContractorFamilySafran("SFFam", "Safran"),
    ContractorFamilySensis("SFam","Sensis"),
    ContractorFamilyTurbomeca("TFam", "Turbomeca"),
    ContractorFamilyDana("DANAFam", "Dana Australia"),
    ContractorFamilyKeysightTech("KTFam", "Keysight Technologies"),
    ContractorFamilyEsriAust("ESRIAFam", "ESRI Australia"),
    ContractorFamilyRaytheonAus("RAYAUSFam", "Raytheon Australia"),
    ContractorFamilyRapiscan("RAPIFam", "Rapiscan"),

    //Dept of Defense 009
    Employee("DODEmp", "Employee");

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
