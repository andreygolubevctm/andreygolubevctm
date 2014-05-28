package com.ctm.security;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import org.apache.commons.codec.binary.Base64;

public class StringEncryption {

	// TODO: Should we be using a Keystore for this? Unsure why it was first implemented like this?
	// FYI There is duplicate use of the salt + key in another tag - maybe why it was implemented like this.
	// FYI: this code taken from HmaxSHA256Tag.java
	private String salt = "++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1ytN|E2qg";
	private String secretKey = "MzJmOGM@#^584kNGNViYTEzMmMTUwMw=";
	private String algorithm = "HmacSHA256";

	public StringEncryption() {

	}

	public String encrypt(String theString) throws NoSuchAlgorithmException, InvalidKeyException{
		Mac algorithm = Mac.getInstance(this.algorithm);
		SecretKeySpec secretKey = new SecretKeySpec(this.secretKey.getBytes(), this.algorithm);
		algorithm.init(secretKey);

		return Base64.encodeBase64String((algorithm.doFinal((this.salt + theString).getBytes())));
	}
}
