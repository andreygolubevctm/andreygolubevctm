package com.ctm.web.simples.model;

import org.junit.Test;

import java.time.LocalDate;

import static org.junit.Assert.assertEquals;

public class RemainingSaleTest {

    @Test
    public void negativeRemainingSales() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 2, 8))
                .compareDate(LocalDate.of(2017, 2, 8))
                .capLimit(10)
                .sales(100)
                .build();
        assertEquals(-90, remainingSale.getRemainingSales());
    }

    @Test
    public void getRemainingSales() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 2, 8))
                .compareDate(LocalDate.of(2017, 2, 8))
                .capLimit(100)
                .sales(50)
                .build();
        assertEquals(50, remainingSale.getRemainingSales());
    }

    @Test
    public void zeroRemainingDays() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 2, 8))
                .compareDate(LocalDate.of(2017, 2, 8))
                .capLimit(0)
                .sales(0)
                .build();
        assertEquals(0, remainingSale.getRemainingDays());
    }

    @Test
    public void zeroRemainingDaysEffectiveDateBefore() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 1, 8))
                .compareDate(LocalDate.of(2017, 2, 8))
                .capLimit(0)
                .sales(0)
                .build();
        assertEquals(0, remainingSale.getRemainingDays());
    }

    @Test
    public void oneRemainingDay() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 2, 9))
                .compareDate(LocalDate.of(2017, 2, 8))
                .capLimit(0)
                .sales(0)
                .build();
        assertEquals(1, remainingSale.getRemainingDays());
    }

    @Test
    public void extendedMonthRemainingDay() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 3, 21))
                .compareDate(LocalDate.of(2017, 2, 8))
                .capLimit(0)
                .sales(0)
                .build();
        assertEquals(20, remainingSale.getRemainingDays());
    }

    @Test
    public void remainingDays10Days() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 2, 28))
                .compareDate(LocalDate.of(2017, 2, 16))
                .capLimit(20)
                .sales(10)
                .build();
        assertEquals(10, remainingSale.getRemainingDays());
    }

    @Test
    public void remainingDays12Days() {
        final RemainingSale remainingSale = RemainingSale.newBuilder()
                .effectiveEnd(LocalDate.of(2017, 2, 28))
                .compareDate(LocalDate.of(2017, 2, 16))
                .capLimit(20)
                .sales(2)
                .build();
        assertEquals(12, remainingSale.getRemainingDays());
    }

}