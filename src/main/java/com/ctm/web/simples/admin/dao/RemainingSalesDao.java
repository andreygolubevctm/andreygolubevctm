package com.ctm.web.simples.admin.dao;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.simples.model.RemainingSale;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Component;

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
            "    LEFT JOIN ctm.joins j ON j.providerId = pm.providerId " +
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
                (rs, rowNum) -> RemainingSale.newBuilder()
                                .fundName(rs.getString("fund"))
                                .compareDate(LocalDate.now())
                                .effectiveStart(rs.getDate("effectiveStart").toLocalDate())
                                .effectiveEnd(rs.getDate("effectiveEnd").toLocalDate())
                                .capLimit(rs.getInt("cap_limit"))
                                .sales(rs.getInt("sales"))
                                .build());
    }

}
