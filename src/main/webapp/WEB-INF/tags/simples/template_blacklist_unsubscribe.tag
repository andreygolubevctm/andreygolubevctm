<%@ tag description="Simples template" %>
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tags/taglib.tagf" %>

<script id="simples-template-blacklist-unsubscribe" type="text/html">

    <div class="simples-blacklist-modal">
        <div class="simples-blacklist-modal-header">
            <h2>Unsubscribe email from all verticals</h2>
        </div>
        <div class="simples-blacklist-modal-body">
            {{ if (typeof successMessage !== 'undefined' && successMessage.length > 0) { }}
            <div class="alert alert-success">{{= successMessage }}</div>
            {{ } }}
            {{ if (typeof errorMessage !== 'undefined' && errorMessage.length > 0) { }}
            <div class="alert alert-danger">{{= errorMessage }}</div>
            {{ } }}
            <form id="simples-unsubscribe-email" class="form-horizontal">
                <div class="form-group row">
                    <label for="email" class="col-xs-3 control-label">Email address</label>
                    <div class="row-content col-xs-6">
                        <input type="text" name="email" class="form-control email" />
                    </div>
                </div>
                <div class="form-group row">
                    <label for="comment" class="col-xs-3 control-label">Comment</label>
                    <div class="row-content col-xs-6">
                        <textarea name="comment" class="form-control" rows="7" placeholder="Enter the reason for the action..."></textarea>
                    </div>
                </div>
                <div class="row text-right">
                    <div class="col-xs-9  text-right">
                        <span class="form-error text-danger"></span>
                        <button type="submit" data-provide="simples-unsubscribe-submit" class="btn btn-warning">Unsubscribe</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

</script>