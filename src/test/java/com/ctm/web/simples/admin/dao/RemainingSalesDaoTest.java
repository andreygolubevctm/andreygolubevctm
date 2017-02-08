package com.ctm.web.simples.admin.dao;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;

import java.time.LocalDate;

import static org.junit.Assert.assertEquals;
import static org.mockito.MockitoAnnotations.initMocks;

public class RemainingSalesDaoTest {

    @Mock
    private NamedParameterJdbcTemplate jdbcTemplate;

    private RemainingSalesDao remainingSalesDao;

    @Before
    public void setup() {
        initMocks(this);
        remainingSalesDao = new RemainingSalesDao(jdbcTemplate);
    }

    @Test
    public void negativeRemainingSales() {
        assertEquals(-90, remainingSalesDao.getRemainingSales(10, 100));
    }

    @Test
    public void getRemainingSales() {
        assertEquals(50, remainingSalesDao.getRemainingSales(100, 50));
    }

    @Test
    public void zeroRemainingDays() {
        assertEquals(0, remainingSalesDao.getRemainingDays(LocalDate.of(2017, 2, 8), LocalDate.of(2017, 2, 8)));
    }

    @Test
    public void zeroRemainingDaysEffectiveDateBefore() {
        assertEquals(0, remainingSalesDao.getRemainingDays(LocalDate.of(2017, 1, 8), LocalDate.of(2017, 2, 8)));
    }

    @Test
    public void oneRemainingDay() {
        assertEquals(1, remainingSalesDao.getRemainingDays(LocalDate.of(2017, 2, 9), LocalDate.of(2017, 2, 8)));
    }

    @Test
    public void extendedMonthRemainingDay() {
        assertEquals(20, remainingSalesDao.getRemainingDays(LocalDate.of(2017, 3, 21), LocalDate.of(2017, 2, 8)));
    }

}