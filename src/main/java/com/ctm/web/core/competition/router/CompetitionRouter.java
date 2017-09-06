package com.ctm.web.core.competition.router;

import java.io.BufferedReader;
import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.*;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@WebServlet(urlPatterns = {
        "/competitions/australia-zoo-meerkats/names.json"
})
public class CompetitionRouter extends HttpServlet {
    private static final Logger LOGGER = LoggerFactory.getLogger(CompetitionRouter.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String uri = request.getRequestURI();
        if (uri.endsWith(".json")) {
            response.setContentType("application/json");
        }

        if (uri.endsWith("/competitions/australia-zoo-meerkats/names.json")) {
            try {
                StringBuilder sb = new StringBuilder();
                BufferedReader br = request.getReader();
                String str = null;
                while ((str = br.readLine()) != null) {
                    sb.append(str);
                }
                JSONObject obj = new JSONObject(sb.toString());
                request.setAttribute("competition_id", obj.getInt("competition_id"));
                request.setAttribute("age_18", obj.getBoolean("age_18"));
                request.setAttribute("marketing", obj.getString("marketing"));
                request.setAttribute("first_name", obj.getString("first_name"));
                request.setAttribute("last_name", obj.getString("last_name"));
                request.setAttribute("email", obj.getString("email"));
                request.setAttribute("post_code", obj.getInt("post_code"));
                request.setAttribute("phone_number", obj.getString("phone_number"));
                request.setAttribute("name_1", obj.getString("name_1"));
                request.setAttribute("name_2", obj.getString("name_2"));
                request.setAttribute("name_3", obj.getString("name_3"));
                request.setAttribute("name_4", obj.getString("name_4"));
                request.setAttribute("reason", obj.getString("reason"));
                RequestDispatcher rd = request.getRequestDispatcher("/ajax/write/competition.jsp");
                rd.forward(request, response);

            } catch (JSONException e) {
                LOGGER.error("Australia Zoo Competition post request failed {}", kv("uri", request.getRequestURI()), e);
            }
        }
    }

    private void addAllowOriginHeader(final HttpServletRequest request, final HttpServletResponse response) {
        final Optional<String> origin = Optional.ofNullable(request.getHeader("Origin"))
                .map(String::toLowerCase)
                .filter(s -> s.contains("comparethemarket.com.au"));
        if(origin.isPresent()) {
            LOGGER.debug("Adding Allow-Origin header for: {}", kv("remote address access", origin));
            response.setHeader("Access-Control-Allow-Origin", request.getHeader("Origin"));
        }
    }
}
