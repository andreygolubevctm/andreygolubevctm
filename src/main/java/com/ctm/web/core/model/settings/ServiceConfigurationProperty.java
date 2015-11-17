package com.ctm.web.core.model.settings;

import java.util.Date;

public class ServiceConfigurationProperty {

	public static int ALL_PROVIDERS = 0;

	public enum Scope {
		GLOBAL {
			public String toString() { return "GLOBAL";	}
		},
		SERVICE{
			public String toString() {
				return "SERVICE";
			}
		},
		GATEWAY{
			public String toString() {
				return "GATEWAY";
			}
		};
	}

	private int id;
	private int serviceId;
	private int styleCodeId;
	private int providerId;
	private String key;
	private String value;
	private Date effectiveStart;
	private Date effectiveEnd;
	private Scope scope;
	private String environmentCode;

	public ServiceConfigurationProperty(){

	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getStyleCodeId() {
		return styleCodeId;
	}

	public void setStyleCodeId(int styleCodeId) {
		this.styleCodeId = styleCodeId;
	}

	public int getProviderId() {
		return providerId;
	}

	public void setProviderId(int providerId) {
		this.providerId = providerId;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public Date getEffectiveStart() {
		return effectiveStart;
	}

	public void setEffectiveStart(Date effectiveStart) {
		this.effectiveStart = effectiveStart;
	}

	public Date getEffectiveEnd() {
		return effectiveEnd;
	}

	public void setEffectiveEnd(Date effectiveEnd) {
		this.effectiveEnd = effectiveEnd;
	}

	public Scope getScope() {
		return scope;
	}

	public void setScope(Scope scope) {
		this.scope = scope;
	}

	public void setScope(String scope){
		if(scope.equalsIgnoreCase(Scope.GLOBAL.toString())){
			setScope(Scope.GLOBAL);
		}else if(scope.equalsIgnoreCase(Scope.GATEWAY.toString())){
			setScope(Scope.GATEWAY);
		}else if(scope.equalsIgnoreCase(Scope.SERVICE.toString())){
			setScope(Scope.SERVICE);
		}
	}

	public int getServiceId() {
		return serviceId;
	}

	public void setServiceId(int serviceId) {
		this.serviceId = serviceId;
	}

	public String getEnvironmentCode() {
		return environmentCode;
	}

	public void setEnvironmentCode(String environmentCode) {
		this.environmentCode = environmentCode;
	}

}
