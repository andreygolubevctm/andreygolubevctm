package com.ctm.web.health.services;


import com.ctm.web.simples.model.ChangeOverRebate;
import com.ctm.web.simples.services.ChangeOverRebatesService;

import java.math.BigDecimal;

public class HealthRebate {

    ChangeOverRebatesService changeOverRebatesService;
    private String currentRebate;
    private String previousRebate;
    private String futureRebate;
    private String rebateTier0Current;
    private String rebateTier1Current;
    private String rebateTier2Current;
    private String rebateTier3Current;
    private String rebateTier0Previous;
    private String rebateTier1Previous;
    private String rebateTier2Previous;
    private String rebateTier3Previous;
    private String rebateTier0Future;
    private String rebateTier1Future;
    private String rebateTier2Future;
    private String rebateTier3Future;

    /**
     * used by health_rebate.jsp
     */
    @SuppressWarnings("unused")
    public HealthRebate() {
        this(new ChangeOverRebatesService());
    }

    public HealthRebate(ChangeOverRebatesService changeOverRebatesService){
        this.changeOverRebatesService = changeOverRebatesService;
    }

    public void calcRebate(String rebateChoice, String commencementDate, int age, int income) {
        ChangeOverRebate changeOverRebates = changeOverRebatesService.getChangeOverRebate(commencementDate);

        BigDecimal previousMultiplier =  changeOverRebates.getPreviousMultiplier();
        BigDecimal multiplier =  changeOverRebates.getCurrentMultiplier();
        BigDecimal futureMultiplier =  changeOverRebates.getFutureMultiplier();

        BigDecimal rebateTier0 = new BigDecimal(30);
        BigDecimal rebateTier1 = new BigDecimal(20);
        BigDecimal rebateTier2 = new BigDecimal(10);

        rebateTier0Previous = calculateRebate( age, rebateTier0, previousMultiplier);
        rebateTier1Previous = calculateRebate( age, rebateTier1, previousMultiplier);
        rebateTier2Previous = calculateRebate( age, rebateTier2, previousMultiplier);
        rebateTier3Previous = "0";

        rebateTier0Current = calculateRebate( age, rebateTier0, multiplier);
        rebateTier1Current = calculateRebate( age, rebateTier1, multiplier);
        rebateTier2Current = calculateRebate( age, rebateTier2, multiplier);
        rebateTier3Current = "0";

        rebateTier0Future = calculateRebate( age, rebateTier0, futureMultiplier);
        rebateTier1Future = calculateRebate( age, rebateTier1, futureMultiplier);
        rebateTier2Future = calculateRebate( age, rebateTier2, futureMultiplier);
        rebateTier3Future  = "0";

        if ("N".equals(rebateChoice) || income == 3) {
            currentRebate  = rebateTier3Current;
            previousRebate = rebateTier3Previous;
            futureRebate = rebateTier3Future;
        } else  if (income == 0) {
            currentRebate = rebateTier0Current;
            previousRebate = rebateTier0Previous;
            futureRebate = rebateTier0Future;
        } else if (income == 1) {
            currentRebate = rebateTier1Current;
            previousRebate = rebateTier1Previous;
            futureRebate = rebateTier1Future;
        } else if (income == 2) {
            currentRebate = rebateTier2Current;
            previousRebate = rebateTier2Previous;
            futureRebate = rebateTier2Future;
        }
    }

    protected String calculateRebate(int age, BigDecimal rebateTier, BigDecimal multiplier) {

        BigDecimal rebate = rebateTier;
        if (age >= 65 && age <= 69) {
            rebate = rebateTier.add(new BigDecimal(5));
        } else  if (age >= 70) {
            rebate = rebateTier.add(new BigDecimal(10));
        }
        String rebatePercentage= rebate.multiply(multiplier).setScale(3, BigDecimal.ROUND_FLOOR).toString();
        //hardcoding as there is no common formula to get exact decimal precision value

        // Pre April 2018
        if(rebatePercentage.equals("34.578"))
            rebatePercentage = "34.579";
        else if(rebatePercentage.equals("12.967"))
            rebatePercentage = "12.966";
        else if(rebatePercentage.equals("21.611"))
            rebatePercentage = "21.612";
        else if(rebatePercentage.equals("8.645"))
            rebatePercentage = "8.644";
            // Post April 2018
        else if(rebatePercentage.equals("8.472"))
            rebatePercentage = "8.471";
        else if(rebatePercentage.equals("21.179"))
            rebatePercentage = "21.180";
        else if(rebatePercentage.equals("8.353"))
            rebatePercentage = "8.352";

        return rebatePercentage;
    }

    public String getCurrentRebate() {
        return currentRebate;
    }

    public String getPreviousRebate() {
        return previousRebate;
    }

    public String getFutureRebate() {
        return futureRebate;
    }

    public String getRebateTier0Current() {
        return rebateTier0Current;
    }

    public String getRebateTier1Current() {
        return rebateTier1Current;
    }

    public String getRebateTier2Current() {
        return rebateTier2Current;
    }

    public String getRebateTier3Current() {
        return rebateTier3Current;
    }

    public String getRebateTier0Previous() {
        return rebateTier0Previous;
    }

    public String getRebateTier1Previous() {
        return rebateTier1Previous;
    }

    public String getRebateTier2Previous() {
        return rebateTier2Previous;
    }

    public String getRebateTier3Previous() {
        return rebateTier3Previous;
    }

    public String getRebateTier0Future() {
        return rebateTier0Future;
    }

    public String getRebateTier1Future() {
        return rebateTier1Future;
    }

    public String getRebateTier2Future() {
        return rebateTier2Future;
    }

    public String getRebateTier3Future() {
        return rebateTier3Future;
    }
}
