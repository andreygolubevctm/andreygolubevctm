package com.ctm.web.core.model;

public class TouchCommentProperty extends AbstractTouchProperty {

    private String comment;

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    @Override
    public String toString() {
        return "TouchCommentProperty{" +
                "comment='" + comment + '\'' +
                '}';
    }
}
