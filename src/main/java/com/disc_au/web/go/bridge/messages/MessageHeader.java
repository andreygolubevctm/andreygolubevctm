package com.disc_au.web.go.bridge.messages;

public interface MessageHeader {
	public byte[] getBytes();
	public void setBytes(byte[] b);
	public int getLength();
	public String getName();
}
