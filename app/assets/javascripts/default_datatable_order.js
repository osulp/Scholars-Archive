$(document).ready(function() {
    $('#under-review.tab-pane .datatable').DataTable( {
        "order": [[ 3, "desc" ]]
    } );
    $('#published.tab-pane .datatable').DataTable( {
        "order": [[ 3, "desc" ]]
    } );
} );
