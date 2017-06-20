package com.ctm.web.health.services;


import com.ctm.web.simples.model.ChangeOverRebate;
import com.ctm.web.simples.services.ChangeOverRebatesService;

import java.math.BigDecimal;

public class HealthRebate {

    ChangeOverRebatesService changeOverRebatesService;
    private BigDecimal currentRebate;
    private BigDecimal previousRebate;
    private BigDecimal futureRebate;
    private BigDecimal rebateTier0Current;
    private BigDecimal rebateTier1Current;
    private BigDecimal rebateTier2Current;
    private BigDecimal rebateTier3Current;
    private BigDecimal rebateTier0Previous;
    private BigDecimal rebateTier1Previous;
    private BigDecimal rebateTier2Previous;
    private BigDecimal rebateTier3Previous;
    private BigDecimal rebateTier0Future;
    private BigDecimal rebateTier1Future;
    private BigDecimal rebateTier2Future;
    private BigDecimal rebateTier3Future;

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
        rebateTier3Previous = BigDecimal.ZERO;

        rebateTier0Current = calculateRebate( age, new BigDecimal(30), multiplier);
        rebateTier1Current = calculateRebate( age, new BigDecimal(20), multiplier);
        rebateTier2Current = calculateRebate( age, new BigDecimal(10), multiplier);
        rebateTier3Current = BigDecimal.ZERO;

        rebateTier0Future = calculateRebate( age, new BigDecimal(30), futureMultiplier);
        rebateTier1Future = calculateRebate( age, new BigDecimal(20), futureMultiplier);
        rebateTier2Future = calculateRebate( age, new BigDecimal(10), futureMultiplier);
        rebateTier3Future = BigDecimal.ZERO;

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

        previousRebate =  rebate.multiply(changeOverRebates.getPreviousMultiplier());
        futureRebate =  rebate.multiply(new BigDecimal(changeOverRebates.getFutureMultiplier()));
    }

    protected BigDecimal calculateRebate(int age, BigDecimal rebateTier, BigDecimal multiplier) {

        BigDecimal rebate = rebateTier;
        if (age >= 65 && age <= 69) {
            rebate = rebateTier.add(new BigDecimal(5));
        } else  if (age >= 70) {
            rebate = rebateTier.add(new BigDecimal(10));
        }
        return rebate.multiply(multiplier);
    }

    public BigDecimal getCurrentRebate() {
        return currentRebate;
    }

    public BigDecimal getPreviousRebate() {
        return previousRebate;
    }

    public BigDecimal getFutureRebate() {
        return futureRebate;
    }

    public BigDecimal getRebateTier0Current() {
        return rebateTier0Current;
    }

    public BigDecimal getRebateTier1Current() {
        return rebateTier1Current;
    }

    public BigDecimal getRebateTier2Current() {
        return rebateTier2Current;
    }

    public BigDecimal getRebateTier3Current() {
        return rebateTier3Current;
    }

    public BigDecimal getRebateTier0Previous() {
        return rebateTier0Previous;
    }

    public BigDecimal getRebateTier1Previous() {
        return rebateTier1Previous;
    }

    public BigDecimal getRebateTier2Previous() {
        return rebateTier2Previous;
    }

    public BigDecimal getRebateTier3Previous() {
        return rebateTier3Previous;
    }

    public BigDecimal getRebateTier0Future() {
        return rebateTier0Future;
    }

    public BigDecimal getRebateTier1Future() {
        return rebateTier1Future;
    }

    public BigDecimal getRebateTier2Future() {
        return rebateTier2Future;
    }

    public BigDecimal getRebateTier3Future() {
        return rebateTier3Future;
    }
}
