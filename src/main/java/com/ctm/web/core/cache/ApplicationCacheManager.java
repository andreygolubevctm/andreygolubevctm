package com.ctm.web.core.cache;

import com.ctm.web.core.content.cache.ContentControlCache;
import net.sf.ehcache.CacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class ApplicationCacheManager implements InitializingBean {

    @Autowired
    private CacheManager cacheManager;

    private static ApplicationCacheManager INSTANCE;

    private static ContentControlCache contentControlCache;

    @Override
    public void afterPropertiesSet() throws Exception {
        INSTANCE = this;
    }

    public static ContentControlCache getContentControlCache(){
        if(contentControlCache == null) {
            contentControlCache = new ContentControlCache(INSTANCE.cacheManager);
        }
        return contentControlCache;
    }

    /**
     * Clear all caches
     */
    public static void clearAll(){
        INSTANCE.cacheManager.clearAll();
    }

}
