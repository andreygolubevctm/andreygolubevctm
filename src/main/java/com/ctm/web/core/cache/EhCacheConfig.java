package com.ctm.web.core.cache;

import net.sf.ehcache.config.CacheConfiguration;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.CachingConfigurer;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.ehcache.EhCacheCacheManager;
import org.springframework.cache.interceptor.CacheErrorHandler;
import org.springframework.cache.interceptor.CacheResolver;
import org.springframework.cache.interceptor.KeyGenerator;
import org.springframework.cache.interceptor.SimpleKeyGenerator;
import org.springframework.cache.support.CompositeCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

import static java.util.Arrays.asList;
import static java.util.concurrent.TimeUnit.MINUTES;
import static net.sf.ehcache.store.MemoryStoreEvictionPolicy.LFU;

@Configuration
@EnableCaching
public class EhCacheConfig implements CachingConfigurer {

    private static final Logger LOGGER = LoggerFactory.getLogger(EhCacheConfig.class);

    @Bean(destroyMethod="shutdown")
    public net.sf.ehcache.CacheManager ehCacheManager() {
        final net.sf.ehcache.config.Configuration config = new net.sf.ehcache.config.Configuration();
        config.setUpdateCheck(false);

        dbCacheCacheConfigs().stream().forEach(config::addCache);

        return net.sf.ehcache.CacheManager.create(config);
    }

    private List<CacheConfiguration> dbCacheCacheConfigs() {

        final CacheConfiguration contentControlCache = new CacheConfiguration("contentControlCache", 10000);
        contentControlCache.setLogging(true);
        contentControlCache.setDiskSpoolBufferSizeMB(20);
        contentControlCache.setTimeToLiveSeconds(MINUTES.toSeconds(30));
        contentControlCache.setMemoryStoreEvictionPolicyFromObject(LFU);
        contentControlCache.setTransactionalMode("off");

        final CacheConfiguration couponGetActiveCouponsCache = new CacheConfiguration("couponGetActiveCouponsCache", 5);
        couponGetActiveCouponsCache.setTimeToLiveSeconds(MINUTES.toSeconds(2));
        couponGetActiveCouponsCache.setMemoryStoreEvictionPolicyFromObject(LFU);
        couponGetActiveCouponsCache.setTransactionalMode("off");

        final CacheConfiguration bsbCache = new CacheConfiguration("getBsbDetailsByBsbNumber", 1000);
        bsbCache.setEternal(true);
        bsbCache.setMemoryStoreEvictionPolicyFromObject(LFU);
        bsbCache.setTransactionalMode("off");

        return asList(contentControlCache, couponGetActiveCouponsCache, bsbCache);
    }

    @Bean
    @Override
    public CacheManager cacheManager() {
        final CompositeCacheManager cacheManager = new CompositeCacheManager(new EhCacheCacheManager(ehCacheManager()));
        cacheManager.setFallbackToNoOpCache(true); // fall back to noop cacheManager if dbCache is not enabled
        return cacheManager;
    }

    @Bean
    @Override
    public CacheResolver cacheResolver() {
        return new CachingResolver();
    }

    @Bean
    @Override
    public KeyGenerator keyGenerator() {
        return new SimpleKeyGenerator();
    }

    @Bean
    @Override
    public CacheErrorHandler errorHandler() {
        return new CacheErrorHandler() {
            @Override
            public void handleCacheGetError(final RuntimeException e, final Cache cache, final Object key) {
                LOGGER.warn("cache get error", e);
            }

            @Override
            public void handleCachePutError(final RuntimeException e, final Cache cache, final Object key, final Object value) {
                LOGGER.warn("cache put error", e);
            }

            @Override
            public void handleCacheEvictError(final RuntimeException e, final Cache cache, final Object key) {
                LOGGER.warn("cache evict error", e);
            }

            @Override
            public void handleCacheClearError(final RuntimeException e, final Cache cache) {
                LOGGER.warn("cache clear error", e);
            }
        };
    }
}
