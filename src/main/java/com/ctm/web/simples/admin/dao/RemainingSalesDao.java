package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.model.RemainingSale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Component
public class RemainingSalesDao {

    private final static String REMAINING_SALES_QUERY =
            "SELECT " +
            "    SQL_CACHE " +
            "    pm.Name as fund, " +
            "    pp.EffectiveStart, " +
            "    pp.EffectiveEnd, " +
            "    pp.text as cap_limit, " +
            "    count(*) as sales " +
            "FROM " +
            "    ctm.provider_properties pp " +
            "    JOIN ctm.provider_master pm ON pm.providerId = pp.providerId " +
            "    LEFT JOIN ctm.product_master p ON p.providerId = pm.ProviderId " +
            "    LEFT JOIN ctm.joins j ON j.productId = p.productId " +
            "WHERE " +
            "    now() BETWEEN pp.EffectiveStart AND pp.EffectiveEnd " +
            "    AND pp.propertyId = 'MonthlyLimit' " +
            "    AND month(j.joinDate) = month(curdate()) " +
            "    AND year(j.joinDate) = year(curdate()) " +
            "    AND not exists (select  " +
            "                * " +
            "            from " +
            "                ctm.product_capping_exclusions pce " +
            "            where " +
            "                j.joinDate between pce.effectiveStart AND pce.effectiveEnd AND " +
            "                pce.productId = j.productId) " +
            "GROUP BY " +
            "    pm.NAME,  " +
            "    pp.EffectiveStart, " +
            "    pp.EffectiveEnd, " +
            "    pp.text";

    private final NamedParameterJdbcTemplate jdbcTemplate;

    @Autowired
    @SuppressWarnings("SpringJavaAutowiringInspection")
    public RemainingSalesDao(final NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<RemainingSale> getRemainingSales() throws DaoException {
        return jdbcTemplate.query(REMAINING_SALES_QUERY,
                (rs, rowNum) -> {

                    final int sales = rs.getInt("sales");
                    final int remainingSales = getRemainingSales(rs.getInt("cap_limit"), sales);
                    return RemainingSale.newBuilder()
                                    .fundName(rs.getString("fund"))
                                    .remainingSales(remainingSales)
                                    .remainingDays(getRemainingDays(rs.getDate("effectiveEnd").toLocalDate(), LocalDate.now(), sales, remainingSales))
                                    .build();
                });
    }

    protected int getRemainingSales(final int cappingLimit, final int sold) {
        return cappingLimit - sold;
    }

    protected int getRemainingDays(final LocalDate effectiveEnd, final LocalDate compareDate, final int sales, final int remainingSales) {

        if (effectiveEnd.isAfter(compareDate)) {

            final int comparedMonth = compareDate.getMonth().compareTo(effectiveEnd.getMonth());

            // Same month
            final int daysRemaining;
            if (comparedMonth == 0) {
                // how many more days until the effectiveEnd
                daysRemaining = effectiveEnd.getDayOfMonth() - compareDate.getDayOfMonth();
            } else {
                // how many more days remaining of the comparedDate
                daysRemaining = compareDate.lengthOfMonth() - compareDate.getDayOfMonth();
            }

            final BigDecimal averageSalesPerDay = new BigDecimal(sales)
                    .divide(new BigDecimal(compareDate.getDayOfMonth()))
                    .setScale(0, BigDecimal.ROUND_CEILING);

            if (averageSalesPerDay.compareTo(BigDecimal.ZERO) != 0) {
                final int calculatedRemainingDay = new BigDecimal(remainingSales)
                        .divide(averageSalesPerDay)
                        .setScale(0, BigDecimal.ROUND_CEILING)
                        .intValue();
                if (calculatedRemainingDay > daysRemaining) {
                    return daysRemaining;
                } else {
                    return calculatedRemainingDay;
                }
            } else {
                return daysRemaining;
            }

        }
        else {
            return 0;
        }
    }

}
