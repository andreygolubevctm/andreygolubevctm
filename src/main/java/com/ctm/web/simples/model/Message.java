package com.ctm.web.simples.model;

import com.ctm.model.AbstractJsonModel;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * "Message" relates to the Call Centre message centre. This model represents the simples.message database table.
 *
 */
public class Message extends AbstractJsonModel {
	private int messageId;
	private long transactionId;
	private int userId;
	private int statusId;
	private String status;
	private int sourceId;
	private String contactName;
	private String phoneNumber1;
	private String phoneNumber2;
	private String state;
	@JsonSerialize(using = CustomDateSerializer.class)
	private Date whenToAction;
	private Date created;
	private boolean canPostpone;
	private List<Long> dupeTransactionIds = new ArrayList<Long>();


	public int getMessageId() {
		return messageId;
	}
	public void setMessageId(int messageId) {
		this.messageId = messageId;
	}

	/**
	 * For a Message, transaction ID is the root ID.
	 */
	public long getTransactionId() { return transactionId; }
	public void setTransactionId(long transactionId) {
		this.transactionId = transactionId;
	}

	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}

	public int getStatusId() {
		return statusId;
	}
	public void setStatusId(int statusId) {
		this.statusId = statusId;
	}

	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	public int getSourceId() {
		return sourceId;
	}
	public void setSourceId(int sourceId) {
		this.sourceId = sourceId;
	}
	public String getContactName() {
		return contactName;
	}
	public void setContactName(String contactName) {
		this.contactName = contactName;
	}

	public String getPhoneNumber1() {
		return phoneNumber1;
	}
	public void setPhoneNumber1(String phoneNumber) {
		this.phoneNumber1 = phoneNumber;
	}

	public String getPhoneNumber2() {
		return phoneNumber2;
	}
	public void setPhoneNumber2(String phoneNumber) {
		this.phoneNumber2 = phoneNumber;
	}

	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}

	public boolean getCanPostpone() {
		return canPostpone;
	}
	public void setCanPostpone(boolean canPostpone) {
		this.canPostpone = canPostpone;
	}

	public Date getWhenToAction() {
		return whenToAction;
	}
	public void setWhenToAction(final Date whenToAction) {
		this.whenToAction = whenToAction;
	}

	public Date getCreated() {
		return created;
	}
	public void setCreated(Date created) {
		this.created = created;
	}
	public List<Long> getDupeTransactionIds() {
		return dupeTransactionIds;
	}
	public void setDupeTransactionIds(List<Long> dupeTransactionIds) {
		this.dupeTransactionIds = dupeTransactionIds;
	}
	public void addDupeTransactionId(Long transactionId) {
		if(transactionId > 0 && transactionId != null){
			this.dupeTransactionIds.add(transactionId);
		}
	}

	@Override
	protected JSONObject getJsonObject() throws JSONException {
		JSONObject json = new JSONObject();

		json.put("messageId", getMessageId());
		json.put("transactionId", getTransactionId());
		json.put("userId", getUserId());
		json.put("statusId", getStatusId());
		json.put("status", getStatus());
		json.put("contactName", getContactName());
		json.put("phoneNumber1", getPhoneNumber1());
		json.put("phoneNumber2", getPhoneNumber2());
		json.put("state", getState());
		json.put("canPostpone", getCanPostpone());
		return json;
	}

	@Override
	@SuppressWarnings("SimplifiableIfStatement")
	public boolean equals(final Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;

		final Message message = (Message) o;

		if (canPostpone != message.canPostpone) return false;
		if (messageId != message.messageId) return false;
		if (statusId != message.statusId) return false;
		if (transactionId != message.transactionId) return false;
		if (userId != message.userId) return false;
		if (contactName != null ? !contactName.equals(message.contactName) : message.contactName != null) return false;
		if (phoneNumber1 != null ? !phoneNumber1.equals(message.phoneNumber1) : message.phoneNumber1 != null)
			return false;
		if (phoneNumber2 != null ? !phoneNumber2.equals(message.phoneNumber2) : message.phoneNumber2 != null)
			return false;
		if (state != null ? !state.equals(message.state) : message.state != null) return false;
		if (status != null ? !status.equals(message.status) : message.status != null) return false;
		return !(whenToAction != null ? !whenToAction.equals(message.whenToAction) : message.whenToAction != null);

	}

	@Override
	public int hashCode() {
		int result = messageId;
		result = 31 * result + (int) (transactionId ^ (transactionId >>> 32));
		result = 31 * result + userId;
		result = 31 * result + statusId;
		result = 31 * result + (status != null ? status.hashCode() : 0);
		result = 31 * result + (contactName != null ? contactName.hashCode() : 0);
		result = 31 * result + (phoneNumber1 != null ? phoneNumber1.hashCode() : 0);
		result = 31 * result + (phoneNumber2 != null ? phoneNumber2.hashCode() : 0);
		result = 31 * result + (state != null ? state.hashCode() : 0);
		result = 31 * result + (whenToAction != null ? whenToAction.hashCode() : 0);
		result = 31 * result + (canPostpone ? 1 : 0);
		return result;
	}

}
