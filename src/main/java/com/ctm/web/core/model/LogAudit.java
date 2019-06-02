package com.ctm.web.core.model;



public class LogAudit {

	public enum Result {
		FAIL ("FAIL"),
		SUCCESS ("SUCCESS");

		private final String value;

		Result(String value) {
			this.value = value;
		}

		public String toString() {
			return value;
		}
	}

	public enum Action {
		LOG_IN ("LOG IN"),
		SUCCESS ("LOG OUT"),
		RESET ("RESET PASSWORD");

		private final String value;

		Action(String code) {
			this.value = code;
		}

		public String toString() {
			return value;
		}
	}

	private String sessionId;
	private Result result;
	private String ip;
	private Action action;
	private String requestUri;
	private String userAgent;

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}

	public void setResult(Result result) {
		this.result = result;
	}

	public Result getResult() {
		return result;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getIp() {
		return ip;
	}

	public void setAction(Action action) {
		this.action = action;
	}

	public Action getAction() {
		return action;
	}

	public void setRequestUri(String requestUri) {
		this.requestUri = requestUri;
	}

	public String getRequestUri() {
		return requestUri;
	}

	public void setUserAgent(String userAgent) {
		this.userAgent = userAgent;
	}

	public String getUserAgent() {
		return userAgent;
	}

	@Override
	public String toString() {
		return "LogAudit{" +
				"sessionId='" + sessionId + '\'' +
				", result=" + result +
				", ip='" + ip + '\'' +
				", action=" + action +
				", requestUri='" + requestUri + '\'' +
				", userAgent='" + userAgent + '\'' +
				'}';
	}
}
