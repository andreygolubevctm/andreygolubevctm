package com.ctm.router;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.json.JSONObject;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.Error;
import com.ctm.model.segment.Segment;
import com.ctm.model.segment.SegmentRequest;
import com.ctm.model.settings.PageSettings;
import com.ctm.services.ApplicationService;
import com.ctm.services.SettingsService;
import com.ctm.services.segment.SegmentService;
import com.ctm.utils.RequestUtils;
import com.disc_au.web.go.Data;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

import static com.ctm.web.core.logging.LoggingArguments.kv;

@WebServlet(urlPatterns = {
		"/segment/filter.json"
})

public class SegmentRouter extends HttpServlet{
	private static final long serialVersionUID = 5594038155613701793L;
	private static final Logger LOGGER = LoggerFactory.getLogger(SegmentRouter.class);
	private final ObjectMapper objectMapper = new ObjectMapper();
	private final SegmentService segmentService = new SegmentService();

	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String uri = request.getRequestURI();
		PrintWriter writer = response.getWriter();

		if (uri.endsWith(".json")) {
			response.setContentType("application/json");
		}

		SegmentRequest segmentRequest = new SegmentRequest();

		try {
			long transactionId = RequestUtils.getTransactionIdFromRequest(request);
			Data data = RequestUtils.getValidDataBucket(request, transactionId);

			PageSettings pageSettings = SettingsService.getPageSettingsByCode(ApplicationService.getBrandCodeFromTransactionSessionData(data), ApplicationService.getVerticalCodeFromTransactionSessionData(data));

			segmentRequest.transactionId = transactionId;
			segmentRequest.styleCodeId = pageSettings.getBrandId();
			segmentRequest.verticalId = pageSettings.getVertical().getId();
			segmentRequest.effectiveDate = ApplicationService.getApplicationDate(request);

			if (uri.endsWith("/segment/filter.json")) {
				filterSegmentForUser(segmentRequest, data, writer, response);
			}

		} catch (Exception e) {
			LOGGER.error("There was an issue producing the Segment JSON response {}", kv("segmentRequest", segmentRequest), e);
			writeErrors(e, writer, response);
		}
	}

	private void filterSegmentForUser(SegmentRequest segmentRequest, Data data, final PrintWriter writer, final HttpServletResponse response) throws IOException {
		try {
			final List<Segment> segments = segmentService.filterSegmentsForUser(segmentRequest, data);
			objectMapper.writeValue(writer, jsonObjectNode("segments", segments));
		} catch (DaoException e) {
			LOGGER.error("Could not filter segment for user {}", kv("transactionId", segmentRequest.transactionId), e);
			writeErrors(e, writer, response);
		}
	}

	private <T> ObjectNode jsonObjectNode(final String name, final T value) {
		final ObjectNode objectNode = objectMapper.createObjectNode();
		objectNode.putPOJO(name, value);
		return objectNode;
	}

	private void writeErrors(final Exception e, final PrintWriter writer, final HttpServletResponse response) {
		final Error error = new Error();
		error.addError(new Error(e.getMessage()));
		JSONObject json = error.toJsonObject(true);
		response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
		writer.print(json.toString());
	}
}
