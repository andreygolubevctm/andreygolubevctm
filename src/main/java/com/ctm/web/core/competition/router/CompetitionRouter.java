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
    private static final long serialVersionUID = 75L;

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
                request.setAttribute("first_name", obj.getString("first_name"));
                request.setAttribute("last_name", obj.getString("last_name"));
                request.setAttribute("email", obj.getString("email"));
                request.setAttribute("post_code", obj.getInt("post_code"));
                request.setAttribute("phone_number", obj.getInt("phone_number"));
                RequestDispatcher rd = request.getRequestDispatcher("/ajax/write/competition.jsp");
                rd.forward(request, response);

            } catch (JSONException e) {
                LOGGER.error("Australia Zoo Competition post request failed {}", kv("uri", request.getRequestURI()), e);
            }
        }
    }
}
