package com.ctm.web.creditcards.model;

public class Views {
	public static class DefaultView { }
	public static class MapView extends DefaultView { }

	public static class SummaryView extends MapView { }
	public static class ComparisonView extends SummaryView { }
	public static class DetailedView extends ComparisonView { }
}
