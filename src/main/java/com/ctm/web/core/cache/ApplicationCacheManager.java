package com.ctm.web.core.cache;

import com.ctm.web.core.content.cache.ContentControlCache;
import net.sf.ehcache.CacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ApplicationCacheManager {

    private static final CacheManager cacheManager = CacheManager.newInstance();
    private static ContentControlCache contentControlCache;

    @Bean
    public static ContentControlCache getContentControlCache(){
        if(contentControlCache == null) {
            contentControlCache = new ContentControlCache(cacheManager);
        }
        return contentControlCache;
    }

    /**
     * Clear all caches
     */
    public static void clearAll(){
        cacheManager.clearAll();
    }

}
