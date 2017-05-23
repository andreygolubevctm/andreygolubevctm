package com.ctm.apply.model.response;


public class ResponseError {
    public final String description;

    private ResponseError(String description) {
        this.description = description;
    }

    public static ResponseError responseError(String description) {
        return new ResponseError(description);
    }

    public boolean equals(Object o) {
        if(this == o) {
            return true;
        } else if(o != null && this.getClass() == o.getClass()) {
            ResponseError that = (ResponseError)o;
            if(this.description != null) {
                if(!this.description.equals(that.description)) {
                    return false;
                }
            } else if(that.description != null) {
                return false;
            }

            return true;
        } else {
            return false;
        }
    }

    public int hashCode() {
        return this.description != null?this.description.hashCode():0;
    }
}
