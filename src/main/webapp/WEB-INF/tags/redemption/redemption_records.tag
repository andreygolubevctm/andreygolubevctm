<script class="crud-row-template" type="text/html">
    <div class="sortable-results-row row" data-id="{{= data.cappingLimitsKey }}">
        <div class="col-lg-2">
            {{= data.rootId }}
        </div>
        <div class="col-lg-2">
            {{= data.orderName }}
        </div>
        <div class="col-lg-1">
            {{= data.address }}
        </div>
        <div class="col-lg-1">
            {{= data.email }}
        </div>
        <div class="col-lg-1">
            {{= data.phone }}
        </div>
        <div class="col-lg-1">
            {{= data.status }}
        </div>
        <div class="col-lg-1">
            {{= data.daysTillDispatch }}
        </div>
        <div class="col-lg-1">
            {{= data.dispatchDate }}
        </div>
        <div class="col-lg-2">
            <button type="button" class="crud-clone-entry btn btn-secondary btn-sm">Clone</button>
            {{ if(data.type === "current"){ }}
            <button type="button" class="crud-edit-entry btn btn-secondary btn-sm">Edit</button>
            <button type="button" class="crud-delete-entry btn btn-primary btn-sm">Delete</button>
            {{ } }}
        </div>
    </div>
</script>