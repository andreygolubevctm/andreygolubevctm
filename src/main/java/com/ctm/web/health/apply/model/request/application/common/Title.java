package com.ctm.web.health.apply.model.request.application.common;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonValue;

public enum Title {
    MR("Mr", "Mr"),
    MRS("Mrs", "Mrs"),
    MISS("Miss", "Miss"),
    MS("Ms", "Ms"),
    DR("Dr", "Dr"),
    LT2("2LT", "SECOND LIEUTENANT"),
    AB("AB", "ABLE SEAMAN"),
    AC("AC", "AIRCRAFTMAN"),
    ACDT("ACDT", "AIR CADET"),
    ACM("ACM", "AIR CHIEF MARSHALL"),
    ACR("ACR", "AIRCRAFTMAN RECRUIT"),
    ACW("ACW", "AIRCRAFTWOMAN"),
    ADMIRAL("ADMIRAL", "ADMIRAL"),
    AIRCDRE("AIRCDRE", "AIR COMMODORE"),
    AM("AM", "AIR MARSHALL"),
    APP("APP", "APPRENTICE"),
    ASLT("ASLT", "ACTING SUB LIEUTENANT"),
    AVM("AVM", "AIR VICE MARSHALL"),
    BDR("BDR", "BOMBARDIER"),
    BRIG("BRIG", "BRIGADIER"),
    CAPT("CAPT", "CAPTAIN"),
    CDRE("CDRE", "COMMODORE"),
    CDT("CDT", "CADET"),
    CFN("CFN", "CRAFTSMAN"),
    CHAP("CHAP", "CHAPLAIN"),
    CINS("CINS", "CINS"),
    CMDR("CMDR", "COMMANDER"),
    COL("COL", "COLONEL"),
    CONS("CONS", "CONS"),
    CPL("CPL", "CORPORAL"),
    CPO("CPO", "CHIEF PETTY OFFICER"),
    FLGOFF("FLGOFF", "FLYING OFFICER"),
    FLT("FLT", "FLT"),
    FLTLT("FLTLT", "FLIGHT LIEUTENANT"),
    FO("FO", "FO"),
    FSGT("FSGT", "FLIGHT SERGEANT"),
    GEN("GEN", "GENERAL"),
    GNR("GNR", "GUNNER"),
    GPCAPT("GPCAPT", "GROUP CAPTAIN"),
    LAC("LAC", "LEADING AIRCRAFTMAN"),
    LACW("LACW", "LEADING AIRCRAFTWOMAN"),
    LBDR("LBDR", "LANCE BOMBARDIER"),
    LCDR("LCDR", "LIEUTENANT COMMANDER"),
    LCPL("LCPL", "LANCE CORPORAL"),
    LEUT("LEUT", "LIEUTENANT"),
    LS("LS", "LS"),
    LSE("LSE", "LEADING SEAMAN"),
    LT("LT", "LIEUTENANT"),
    LTCOL("LTCOL", "LIEUTENANT COLONEL"),
    LTGEN("LTGEN", "LIEUTENANT GENERAL"),
    MAJ("MAJ", "MAJOR"),
    MAJGEN("MAJGEN", "MAJOR GENERAL"),
    MIDN("MIDN", "MID SHIPMAN"),
    MUSN("MUSN", "MUSICIAN"),
    OCDT("OCDT", "OFFICER CADET"),
    ORD("ORD", "ORDINARY SEAMAN"),
    PCHA("PCHA", "PRINCIPAL CHAPLAIN"),
    PLTOFF("PLTOFF", "PILOT OFFICER"),
    PO("PO", "PETTY OFFICER"),
    PTE("", "PRIVATE"),
    RADM("", "REAR ADMIRAL"),
    RADMSIR("", "RADMSIR"),
    RCT("RCT", "RCT"),
    REC("REC", "RECRUIT"),
    SBLT("SBLT", "SUB LIEUTENANT"),
    SCHA("SCHA", "SENIOR CHAPLAIN"),
    SCON("SCON", "SCON"),
    SEN("SEN", "SEN"),
    SGT("SGT", "SERGEANT"),
    SIG("SIG", "SIGNALMAN"),
    SLDR("SLDR", "SLDR"),
    SMN("SMN", "SEAMAN"),
    SPR("SPR", "SAPPER"),
    SQNLDR("SQNLDR", "SQUADRON LEADER"),
    SSGT("SSGT", "STAFF SERGEANT"),
    TPR("TPR", "TROOPER"),
    VADM("VADM", "VICE ADMIRAL"),
    VADMSIR("VADMSIR", "VADMSIR"),
    WCDR("WCDR", "WCDR"),
    WGCDR("WGCDR", "WING COMMANDER"),
    WO("WO", "WARRANT OFFICER"),
    WO1("WO1", "WARRANT OFFICER CLASS 1"),
    WO2("WO2", "WARRANT OFFICER CLASS 2"),
    WOFF("WOFF", "WARRANT OFFICER"),
    OTHER("OTHER", "OTHER"),
    NONE("NONE", "NONE");

    @JsonIgnore
    private final String code;
    @JsonIgnore
    private final String description;

    Title(final String code, final String description ) {
        this.code = code;
        this.description = description;
    }

    @JsonValue
    public String getName() {
        return name();
    }

    @JsonCreator
    public static Title findByCode(final String code) {
        if(code == null) {
            return NONE;
        }
        for (final Title t : Title.values()) {
            if (code.equalsIgnoreCase(t.getCode())) {
                return t;
            }
        }
        return OTHER;
    }

    @JsonIgnore
    public String getDescription() {
        return description;
    }

    @JsonIgnore
    public String getCode() {
        return code;
    }

    public static Title fromValue(final String v) {
        return findByCode(v);
    }
}
