package com.ctm.web.core.content.cache;

import com.ctm.web.core.cache.EhcacheWrapper;
import com.ctm.web.core.content.model.Content;
import net.sf.ehcache.CacheManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Cache container for Content Control values.
 */
@Component
public class ContentControlCache extends EhcacheWrapper<String, Content> {

    @Autowired
    public ContentControlCache(CacheManager cacheManager) {
        super("contentControlCache", cacheManager);
    }
}
