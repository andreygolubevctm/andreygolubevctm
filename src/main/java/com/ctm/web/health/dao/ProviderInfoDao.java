package com.ctm.web.health.dao;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import com.google.common.annotations.VisibleForTesting;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.Optional;

import static java.util.Optional.empty;

@Repository
public class ProviderInfoDao {

    private static final String PROVIDER_CONTENT_QUERY =
            "SELECT cc.contentValue " +
                    "FROM ctm.content_control_provider ccp " +
                    "  JOIN ctm.content_control cc " +
                    "    ON ccp.contentControlId = cc.contentControlId " +
                    "WHERE cc.contentKey = :contentKey " +
                    "  AND :requestAt BETWEEN cc.effectiveStart AND cc.effectiveEnd " +
                    "  AND (cc.styleCodeId = 0 or cc.styleCodeId = :styleCodeId) " +
                    "  AND ccp.providerId = :providerId " +
                    "ORDER BY cc.styleCodeId DESC " +
                    "LIMIT 1";
    private final NamedParameterJdbcTemplate jdbcTemplate;

    @Autowired
    public ProviderInfoDao(final NamedParameterJdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    /**
     * Gets the provider information from content control
     */
    public ProviderInfo getProviderInfo(final Provider provider,
                                        final Brand brand,
                                        final java.util.Date searchDate) {
        return ProviderInfo.newProviderInfo()
                .email(getProviderEmail(provider, brand, searchDate))
                .phoneNumber(getProviderDirectPhoneNumber(provider, brand, searchDate))
                .website(getProviderWebsite(provider, brand, searchDate)).build();
    }


    public String getProviderEmail(final Provider providerId,
                                    final Brand brand,
                                    final java.util.Date searchDate) {
        return getProviderContent(providerId, brand, searchDate, "providerEmail")
                .orElse("");
    }

    private String getProviderWebsite(final Provider providerId, final Brand brand, final java.util.Date searchDate) {
        return getProviderContent(providerId, brand, searchDate, "providerWebsite")
                .orElse("");
    }

    private String getProviderDirectPhoneNumber(final Provider providerId, final Brand brand,
                                          final java.util.Date searchDate) {
        return getProviderContent(providerId, brand, searchDate, "providerDirectPhoneNumber")
                .orElse("");
    }

    @VisibleForTesting Optional<String> getProviderContent(final Provider providerId, final Brand brand,
                                                final java.util.Date searchDate,
                                                final String key) {
        return jdbcTemplate.query(PROVIDER_CONTENT_QUERY,
                new MapSqlParameterSource()
                        .addValue("requestAt", searchDate)
                        .addValue("styleCodeId", brand.getId())
                        .addValue("providerId", providerId.getId())
                        .addValue("contentKey", key),
                getContentValue());
    }

    private ResultSetExtractor<Optional<String>> getContentValue() {
        return (rs) -> {
            if (rs.next()) {
                return Optional.of(rs.getString("contentValue"));
            } else {
                return empty();
            }
        };
    }
}