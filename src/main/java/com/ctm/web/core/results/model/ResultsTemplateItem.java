package com.ctm.web.core.results.model;

import java.util.ArrayList;

public class ResultsTemplateItem implements Comparable<ResultsTemplateItem> {

	public static final String TYPE_SECTION = "section";
	public static final String TYPE_CATEGORY = "category";
	public static final String TYPE_FEATURE = "feature";

	private int id;
	private String name;
	private String type;
	private boolean status;
	private int sequence;
	private Number parentId;
	private String resultPath;
	private String vertical;
	private boolean expanded;
	private boolean multiRow;
	private String className;
	private String extraText;
	private int helpId;
	private String shortlistKey;
	private int flag;
	private String groups;
	private String caption;
	private String description;

	ArrayList<ResultsTemplateItem> children;

	public ResultsTemplateItem(){
		children = new ArrayList<ResultsTemplateItem>();
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

	public String getSafeName() {
		String name = getName();
		return name.matches("\\d+") ? "" : name;
	}

	public void setName(String name) {
		this.name = name.replaceAll("/", " / ");
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public boolean isStatus() {
		return status;
	}

	public void setStatus(boolean status) {
		this.status = status;
	}

	public int getSequence() {
		return sequence;
	}

	public void setSequence(int sequence) {
		this.sequence = sequence;
	}

	public Number getParentId() {
		return parentId;
	}

	public void setParentId(Number parentId) {
		this.parentId = parentId;
	}

	public String getResultPath() {
		String path = this.resultPath;
		if(path != null) path = path.replace("\"", "'"); // Double quotes will break template engine.
		return path;
	}

	public void setResultPath(String resultPath) {
		this.resultPath = resultPath;
	}

	public String getVertical() {
		return vertical;
	}

	public void setVertical(String vertical) {
		this.vertical = vertical;
	}

	public boolean isExpanded() {
		return expanded;
	}

	public void setExpanded(boolean expanded) {
		this.expanded = expanded;
	}

	public boolean isMultiRow() {
		return multiRow;
	}

	public void setMultiRow(boolean multiRow) {
		this.multiRow = multiRow;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public String getExtraText() {
		return extraText;
	}

	public void setExtraText(String extraText) {
		this.extraText = extraText;
	}

	public int getHelpId() {
		return helpId;
	}

	public void setHelpId(int helpId) {
		this.helpId = helpId;
	}

	public boolean isShortlistable() {
		if(this.shortlistKey == null || this.shortlistKey.equals("")) return false;
		return true;
	}

	public String getShortlistKey() {
		if(shortlistKey == null) return "";
		return shortlistKey;
	}

	public void setShortlistKey(String shortlistKey) {
		this.shortlistKey = shortlistKey;
	}

	public int getFlag() {
		return flag;
	}
	public void setFlag(int flag) {
		this.flag = flag;
	}

	public void setGroups(String groups) {
		this.groups = groups;
	}

	public String getGroups() {
		return groups;
	}

	public void setCaption(String caption) {
		this.caption = caption;
	}

	public String getCaption() {
		return caption;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getDescription() {
		return description;
	}

	public boolean hasShortlistableChildren(){
		for (ResultsTemplateItem item : this.children) {
			if(item.isShortlistable()){
				return true;
			}
		}
		return false;
	}

	public ArrayList<ResultsTemplateItem> getChildren() {
		return children;
	}

	public void setChildren(ArrayList<ResultsTemplateItem> children) {
		this.children = children;
	}

	public boolean couldHaveChildren(){
		if(this.children.size() > 0) return true;
		if(this.className != null && this.className.contains("selectionHolder")) return true;
		return false;
	}

	public String getClassString(){
		String classString = getBaseClassString();
		if(hasShortlistableChildren()) classString += "hasShortlistableChildren ";
		return classString;
	}

	public String getClassStringForInlineLabel(){
		return getBaseClassString();
	}

	private String getBaseClassString(){
		String classString = "";
		if(this.type != null) classString += type + " ";

		if(this.expanded == true) {
			classString += "expanded ";
		} else {
			// Only give the expandable class to elements which are collapsed, therefore any item open by default can not be closed.
			if(couldHaveChildren()) classString += "expandable ";
			classString += "collapsed ";
		}
		if(this.className != null) classString += className + " ";
		return classString;
	}

	public String getContentClassString(){
		String classString = "";
		if(this.multiRow){
			if(this.multiRow == true) classString += "isMultiRow ";
		}
		return classString;
	}

	@Override
	public int compareTo(ResultsTemplateItem other){
		final int BEFORE = -1;
		final int EQUAL = 0;
		final int AFTER = 1;

		if (this.sequence < other.getSequence()) return BEFORE;
		if (this.sequence > other.getSequence()) return AFTER;
		return EQUAL;
	}

}
