package com.ctm.web.health.dao;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.provider.model.Provider;
import com.ctm.web.health.model.providerInfo.ProviderEmail;
import com.ctm.web.health.model.providerInfo.ProviderInfo;
import com.ctm.web.health.model.providerInfo.ProviderPhoneNumber;
import com.ctm.web.health.model.providerInfo.ProviderWebsite;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.stereotype.Repository;
import javax.cache.annotation.CacheResult;

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
    @CacheResult(cacheName = "getProviderInfo")
    public ProviderInfo getProviderInfo(final Provider provider,
                                        final Brand brand,
                                        final java.util.Date searchDate) {
            return    new ProviderInfo(
                        getProviderEmail(provider, brand, searchDate),
                        getProviderWebsite(provider, brand, searchDate),
                        getProviderPhoneNumber(provider, brand, searchDate));
    }


    private ProviderEmail getProviderEmail(final Provider providerId,
                                           final Brand brand,
                                           final java.util.Date searchDate) {
        return getProviderContent(providerId, brand, searchDate, "providerEmail")
                .map(ProviderEmail::instanceOf)
                .orElse(ProviderEmail.empty());
    }

    private ProviderWebsite getProviderWebsite(final Provider providerId, final Brand brand, final java.util.Date searchDate) {
        return getProviderContent(providerId, brand, searchDate, "providerWebsite")
                .map(ProviderWebsite::instanceOf)
                .orElse(ProviderWebsite.empty());
    }

    private ProviderPhoneNumber getProviderPhoneNumber(final Provider providerId, final Brand brand,
                                                       final java.util.Date searchDate) {
        return getProviderContent(providerId, brand, searchDate, "providerPhoneNumber")
                .map(ProviderPhoneNumber::instanceOf)
                .orElse(ProviderPhoneNumber.empty());
    }

    private Optional<String> getProviderContent(final Provider providerId, final Brand brand, final java.util.Date searchDate,
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
