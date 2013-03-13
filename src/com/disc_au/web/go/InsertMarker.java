package com.disc_au.web.go;

/**
 * The Class InsertMarker.
 * 
 * @author aransom
 * @version 1.0
 */

public class InsertMarker {
	/**
	 * The Enum Format.
	 */
	public enum Format {
		
		/** The SCRIPT. */
		SCRIPT, 
 /** The STYLE. */
 STYLE, 
 /** The HTML. */
 HTML,
 JSON,
 UNKNOWN
	}

	/** The name. */
	protected String name;
	
	/** The delim. */
	private String delim;

	/** The data. */
	private StringBuffer data;

	protected Format format;
	
	/**
	 * Instantiates a new insert marker.
	 *
	 * @param name the name
	 */
	public InsertMarker(String name, String format) {
		this(name,Format.valueOf(format));
	}
	/**
	 * Instantiates a new insert marker.
	 *
	 * @param name the name
	 */
	public InsertMarker(String name, Format format) {
		this.name = name;
		this.format = format;
	}
	/**
	 * Adds the data.
	 *
	 * @param data the data
	 */
	public void addData(String data) {
		if (this.data == null) {
			this.data = new StringBuffer(data);

			// Only add if we don't already have it
		} else if (this.data.indexOf(data) == -1) {
			if (this.delim != null) {
				this.data.append(this.delim);
			}
			this.data.append(data);
		}
	}

	/**
	 * Gets the data.
	 *
	 * @return the data
	 */
	public StringBuffer getData() {
		if (this.data != null) {
			return this.data;
		} else {
			return new StringBuffer();
		}
	}

	/**
	 * Gets the delim.
	 *
	 * @return the delim
	 */
	public String getDelim() {
		return delim;
	}

	/**
	 * Gets the name.
	 *
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the delim.
	 *
	 * @param delim the new delim
	 */
	public void setDelim(String delim) {
		this.delim = delim;
	}

	/**
	 * Sets the name.
	 *
	 * @param markerName the new name
	 */
	public void setName(String markerName) {
		this.name = markerName;
	}

	public void setFormat(String format){
		this.format=Format.valueOf(format);
	}
	public Format getFormat(){
		return this.format;
	}
	
}
