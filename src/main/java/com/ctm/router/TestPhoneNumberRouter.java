package com.ctm.router;

import java.io.IOException;
import org.json.JSONException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;
import com.ctm.utils.NGram;

import static com.ctm.web.core.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
		"/ngram/test.json"

})

public class TestPhoneNumberRouter extends HttpServlet {
	private static final Logger LOGGER = LoggerFactory.getLogger(TestPhoneNumberRouter.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException {
		response.setContentType("application/json");

		Integer score = 0;
		String list = "";

		try {
			String text = request.getParameter("text");
			Integer sequences = Integer.parseInt(request.getParameter("sequences"));
			Integer triples = Integer.parseInt(request.getParameter("triples"));
			Integer patterns = Integer.parseInt(request.getParameter("patterns"));
			Integer reversePatterns = Integer.parseInt(request.getParameter("reversepatterns"));

			NGram ngram = new NGram(text,3);
			NGram ngram_list = new NGram(text,3);
			ngram.setSequencesScore(sequences);
			ngram.setTriplesScore(triples);
			ngram.setPatternsScore(patterns);
			ngram.setReversePatternsScore(reversePatterns);

			ngram_list.setSequencesScore(sequences);
			ngram_list.setTriplesScore(triples);
			ngram_list.setPatternsScore(patterns);
			ngram_list.setReversePatternsScore(reversePatterns);

			score = ngram.score();
			list = ngram_list.list().toString();

			JSONObject json = new JSONObject();
			json.put("score", score);
			json.put("list", list);

			response.getWriter().print(json.toString());

		} catch (JSONException | IOException e) {
			LOGGER.error("Failed to create test phone number json response {}, {}", kv("score", score), kv("list", list), e);
		}
	}
}
