package com.ctm.web.core.model.settings;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.stream.Collectors;


public class Brand {

	private int id;
	private String name;
	private String code;
	private ArrayList<Vertical> verticals;

	public Brand(){
		verticals = new ArrayList<Vertical>();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public ArrayList<Vertical> getVerticals() {
		return verticals;
	}

	public ArrayList<Vertical> sortVerticalsBySeq(int maxVerticals) {
		ArrayList<Vertical> sortedVerticalList = verticals
				.stream()
				.filter(v -> v.getSequence() > 0)
				.sorted(Comparator.comparingInt(Vertical::getSequence))
				.limit(maxVerticals)
				.collect(Collectors.toCollection(ArrayList::new));

		return sortedVerticalList;
	}

	public void setVerticals(ArrayList<Vertical> verticals) {
		this.verticals = verticals;
	}

	/**
	 * get vertical by code this is not case sensitive
	**/
	public Vertical getVerticalByCode(String code){
		for(Vertical vertical : getVerticals()){
			if(vertical.getType().getCode().equalsIgnoreCase(code)){
				return vertical;
			}
		}

		return null;
	}

	public Vertical getVerticalById(int id){
		for(Vertical vertical : getVerticals()){
			if(vertical.getId() == id){
				return vertical;
			}
		}

		return null;
	}


}
