package com.ctm.web.health.lhc;


import com.ctm.web.health.lhc.calculation.LHCCalculationStrategy;
import com.ctm.web.health.lhc.calculation.LHCCalculationStrategyFactory;
import com.ctm.web.health.lhc.calculation.NeverHeldCoverCalculator;
import com.ctm.web.health.lhc.model.query.LHCCalculationQuery;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mockito;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import java.time.LocalDate;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.powermock.api.mockito.PowerMockito.mockStatic;

/**
 * Test to check if we use the right day when apply at
 * the first day of a new Financial Year: CTM-4311
 *
 * The test is in its own class because it uses @PrepareForTest
 * which will set coverage in Sonar to 0
 */
@RunWith(PowerMockRunner.class)
@PrepareForTest({ LocalDate.class, LHCCalculationController.class, LHCCalculationStrategyFactory.class })
public class LHCCalculationControllerDateTest {

    @Test
    public void givenInstant_testDay() {

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(LHCCalculationControllerITest.getValidCalculationDetails());
        assertNull(lhcCalculationQuery.getApplicationDate());

        LocalDate now = LocalDate.of(2020, 1, 8);
        LocalDate nowFinYearStart = LocalDate.of(2020, 7, 1);

        LocalDate nowInFuture = LocalDate.of(2040, 1, 8);
        LocalDate nowInFutureFinYearStart = LocalDate.of(2050, 7, 1);
        mockStatic(LocalDate.class);
        PowerMockito.when(LocalDate.now()).thenReturn(now);

        LHCCalculationStrategy strategy = new NeverHeldCoverCalculator(lhcCalculationQuery.getPrimary().getDateOfBirth(), now);
        ArgumentCaptor<LocalDate> dateArgumentCaptor = ArgumentCaptor.forClass(LocalDate.class);
        mockStatic(LHCCalculationStrategyFactory.class);
        PowerMockito.when(LHCCalculationStrategyFactory.getInstance(Mockito.any(), dateArgumentCaptor.capture())).thenReturn(strategy);

        LHCCalculationController controller = new LHCCalculationController();

        // now is not a fin year start
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(now.minusDays(1), dateArgumentCaptor.getValue());

        PowerMockito.when(LocalDate.now()).thenReturn(nowInFuture);
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(nowInFuture.minusDays(1), dateArgumentCaptor.getValue());

        // test fin year start
        PowerMockito.when(LocalDate.now()).thenReturn(nowFinYearStart);
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(nowFinYearStart, dateArgumentCaptor.getValue());

        PowerMockito.when(LocalDate.now()).thenReturn(nowInFutureFinYearStart);
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(nowInFutureFinYearStart, dateArgumentCaptor.getValue());
    }

    @Test
    public void givenNowAndApplication_testNowOverriding() {
        LocalDate applicationDate = LocalDate.of(2022, 6, 5);
        LocalDate applicationDateFinYearStart = LocalDate.of(2022, 7, 1);

        LocalDate now = LocalDate.of(2020, 1, 8);
        LocalDate nowFinYearStart = LocalDate.of(2020, 7, 1);
        LocalDate nowInFuture = LocalDate.of(2040, 1, 8);

        LHCCalculationQuery lhcCalculationQuery = new LHCCalculationQuery()
                .primary(LHCCalculationControllerITest.getValidCalculationDetails());
        lhcCalculationQuery.setApplicationDate(applicationDate);

        mockStatic(LocalDate.class);
        PowerMockito.when(LocalDate.now()).thenReturn(now);

        LHCCalculationStrategy strategy = new NeverHeldCoverCalculator(lhcCalculationQuery.getPrimary().getDateOfBirth(), now);
        ArgumentCaptor<LocalDate> dateArgumentCaptor = ArgumentCaptor.forClass(LocalDate.class);
        mockStatic(LHCCalculationStrategyFactory.class);
        PowerMockito.when(LHCCalculationStrategyFactory.getInstance(Mockito.any(), dateArgumentCaptor.capture())).thenReturn(strategy);


        LHCCalculationController controller = new LHCCalculationController();

        // applicationDate is not a fin year start
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(applicationDate.minusDays(1), dateArgumentCaptor.getValue());

        // applicationDate is a fin year start
        lhcCalculationQuery.setApplicationDate(applicationDateFinYearStart);
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(applicationDateFinYearStart, dateArgumentCaptor.getValue());

        // now & applicationDate is a fin year start
        PowerMockito.when(LocalDate.now()).thenReturn(nowFinYearStart);
        lhcCalculationQuery.setApplicationDate(applicationDateFinYearStart);
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(applicationDateFinYearStart, dateArgumentCaptor.getValue());

        // now is in the future, applicationDate is a fin year start
        PowerMockito.when(LocalDate.now()).thenReturn(nowInFuture);
        lhcCalculationQuery.setApplicationDate(applicationDateFinYearStart);
        controller.calculateLHC(lhcCalculationQuery);
        assertEquals(applicationDateFinYearStart, dateArgumentCaptor.getValue());
    }
}
