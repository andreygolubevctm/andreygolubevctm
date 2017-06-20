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

    public HealthRebate(){
        changeOverRebatesService = new ChangeOverRebatesService();
    }

    public HealthRebate(ChangeOverRebatesService changeOverRebatesService){
        changeOverRebatesService = new ChangeOverRebatesService();
    }
    
    public void calcRebate(String rebateChoice, String commencementDate, int age, int income) {
        ChangeOverRebate changeOverRebates = changeOverRebatesService.getChangeOverRebate(commencementDate);
        BigDecimal rebate = new BigDecimal(0);

        BigDecimal previousMultiplier =  changeOverRebates.getPreviousMultiplier();
        BigDecimal multiplier =  new BigDecimal(changeOverRebates.getCurrentMultiplier());
        BigDecimal futureMultiplier =  new BigDecimal(changeOverRebates.getFutureMultiplier());

        rebateTier0Previous = calculateRebate( age, new BigDecimal(30), previousMultiplier);
        rebateTier1Previous = calculateRebate( age, new BigDecimal(20), previousMultiplier);
        rebateTier2Previous = calculateRebate( age, new BigDecimal(10), previousMultiplier);
        rebateTier3Previous = "0";

        rebateTier0Current = calculateRebate( age, new BigDecimal(30), multiplier);
        rebateTier1Current = calculateRebate( age, new BigDecimal(20), multiplier);
        rebateTier2Current = calculateRebate( age, new BigDecimal(10), multiplier);
        rebateTier3Current = "0";

        rebateTier0Future = calculateRebate( age, new BigDecimal(30), futureMultiplier);
        rebateTier1Future = calculateRebate( age, new BigDecimal(20), futureMultiplier);
        rebateTier2Future = calculateRebate( age, new BigDecimal(10), futureMultiplier);
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
        return rebate.multiply(multiplier).setScale(3, BigDecimal.ROUND_HALF_UP).toString();
    }

    public String getCurrentRebate() {
        return currentRebate.toString();
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
