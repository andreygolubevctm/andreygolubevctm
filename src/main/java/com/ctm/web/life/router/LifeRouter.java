package com.ctm.web.life.router;

import com.ctm.web.life.model.Occupation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Context;
import java.util.*;


import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static com.ctm.web.life.dao.OccupationsDao.getOccupationList;

@Path("/life")
public class LifeRouter {
    private static final Logger LOGGER = LoggerFactory.getLogger(LifeRouter.class);

    private void addAllowOriginHeader(@Context HttpServletRequest request, @Context HttpServletResponse response) {
        final Optional<String> origin = Optional.ofNullable(request.getHeader("Origin"))
                .map(String::toLowerCase)
                .filter(s -> s.contains("comparethemarket.com.au"));
        if (origin.isPresent()) {
            LOGGER.debug("Adding Allow-Origin header for: {}", kv("remote address access", origin));
            response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
        }
    }

    @GET
    @Path("/occupation/search.json")
    @Produces("application/json")
    public ArrayList<Occupation> getOccupations(@QueryParam("search") String searchText,
                                                @Context HttpServletRequest request,
                                                @Context HttpServletResponse response) {

        addAllowOriginHeader(request, response);

        return getOccupationList(searchText);
    }
}