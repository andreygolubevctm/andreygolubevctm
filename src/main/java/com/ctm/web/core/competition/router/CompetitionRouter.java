package com.ctm.web.core.competition.router;

import java.io.BufferedReader;
import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@WebServlet(urlPatterns = {
        "/competitions/australiazoo/names.json"
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

        if (uri.endsWith("/competitions/australiazoo/names.json")) {
            try {
                StringBuilder sb = new StringBuilder();
                BufferedReader br = request.getReader();
                String str = null;
                while ((str = br.readLine()) != null) {
                    sb.append(str);
                }
                JSONObject obj = new JSONObject(sb.toString());
                String email = obj.getString("email");
                String name = obj.getString("name");
                Integer postCode = obj.getInt("post_code");
                Integer phoneNumber = obj.getInt("phone_number");
                response.getWriter().write("Record set for : " + name);

            } catch (JSONException e) {
                LOGGER.error("Australia Zoo Competition post request failed {}", kv("uri", request.getRequestURI()), e);
            }
        }
    }
}
