package com.ctm.web.core.statistics.model;

public class StatisticDetail {

	private String tranId;
	private String calcSequence;
	private String serviceId;
	private String productId;
	private String responseTime;
	private String responseMessage;
	private StatisticDescription statisticDescription;

	public StatisticDescription getStatisticDescription() {
		return statisticDescription;
	}
	public void setStatisticDescription(StatisticDescription statisticDescription) {
		this.statisticDescription = statisticDescription;
	}

	public String getTranId() {
		return tranId;
	}
	public void setTranId(String tranId) {
		this.tranId = tranId;
	}
	public String getCalcSequence() {
		return calcSequence;
	}

	public void setCalcSequence(String calcSequence) {
		this.calcSequence = calcSequence;
	}

	public String getServiceId() {
		return serviceId;
	}

	public void setServiceId(String serviceId) {
		if(serviceId == null || serviceId.isEmpty()) {
			this.serviceId = "unknown";
		} else {
			this.serviceId = serviceId;
		}
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		if(productId == null || productId.isEmpty()) {
			this.productId = "-1";
		} else {
			this.productId = productId;
		}
	}
	public String getResponseTime() {
		return responseTime;
	}
	public void setResponseTime(String responseTime) {
		if(responseTime == null || responseTime.isEmpty()) {
			this.responseTime = "-1";
		} else {
			this.responseTime = responseTime;
		}
	}
	public String getResponseMessage() {
		return responseMessage;
	}
	public void setResponseMessage(String responseMessage) {
		this.responseMessage = responseMessage;
	}
}
