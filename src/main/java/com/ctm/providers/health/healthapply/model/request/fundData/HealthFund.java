package com.ctm.providers.health.healthapply.model.request.fundData;

public enum HealthFund {

    ACA ("ACA Health Benefits Fund"),
    AHM ("ahm - Aust Health Management Ins"),
    AMA ("AMA Health Fund Limited"),
    API ("API Health Linx"),
    AUSTUN ("Australian Unity Health Insurance"),
    BHP ("Broken Hill Pty Limited"),
    BUPA ("Bupa Australia"),
    CBHS ("CBHS Health Fund Limited"),
    CDH ("CDH - Cessnock District Health Benefits Fund"),
    CWH ("Central West Health Cover"),
    CI ("Commercial Insurer"),
    CPS ("CPS Health Benefits Society"),
    CUA ("CUA Health Limited"),
    DHBS ("Defence Health Limited"),
    DOC ("The Doctors Health Fund"),
    DFS ("Druids Friendly Society"),
    UAOD ("Druids Health Benefits Fund"),
    FI ("Federation Insurance"),
    FRANK ("Frank Health Insurance"),
    GMF ("GMF - Goldfields Medical Fund"),
    HHBFL ("GMF - Healthguard Health Ben Fund"),
    GMHBA ("GMHBA - Geelong Med &amp; Hos Ben Assoc"),
    GU ("Grand United Corporate Health"),
    HBA ("HBA - Hospital Benefits Association"),
    HBF ("HBF Health Funds inc"),
    HCF ("HCF - Hospitals Contribution Fund"),
    HCI ("Health Care Insurance Ltd"),
    HEA ("Health.com.au"),
    HBFSA ("Health Partners"),
    HIF ("Hif - Health Ins Fund of Aust Ltd"),
    IMAN ("Iman Health Care"),
    IOOF ("Ind Order of OddFellows"),
    IOR ("Independ Order of Rechabites"),
    IFHP ("International Fed Health Plans"),
    LVHHS ("Latrobe Health Services"),
    MU ("Manchester Unity Australia"),
    MBF ("MBF - Medical Benefit Fund"),
    MEDIBK ("Medibank Private Limited"),
    MDHF ("Mildura District Hospital Fund"),
    MC ("Mutual Community"),
    NHBA ("National Health Benefits Aust Ltd"),
    NATMUT ("National Mutual Health Ins"),
    NHBS ("Navy Health"),
    NIB ("NIB Health Funds Limited"),
    NONE("None"),
    NRMA ("NRMA - Nat Roads &amp; Motorists Ass"),
    OTHER ("Other"),
    LHMC ("Peoplecare (Lysaght)"),
    PWAL ("Phoenix Welfare Assoc Ltd"),
    SAPOL ("Police Health"),
    QCH ("Queensland Country Health Fund Ltd"),
    RTEHF ("Railway & Transport Health Fund"),
    RBHS ("Reserve Bank Health Soc Ltd"),
    SGIC ("SGIC Health"),
    SGIO ("SGIO Health"),
    SLHI ("St Lukes Health"),
    TFHS ("Teachers Health Fund"),
    TFS ("Transport Health"),
    QTUHS ("TUH - Teachers Union Health (QLD)"),
    WDHF ("Westfund Limited");

    private final String description;

    HealthFund(final String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    public static HealthFund findByCode(final String code) {
        if(code == null) {
            return NONE;
        }
        for (final HealthFund t : HealthFund.values()) {
            if (code.equalsIgnoreCase(t.name())) {
                return t;
            }
        }
        return OTHER;
    }

    public static HealthFund fromValue(final String v) {
        return findByCode(v);
    }


}
