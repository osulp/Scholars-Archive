$(document).on('ready :load', function() {
    $('#under-review.tab-pane .datatable').DataTable( {
        "order": [[ 3, "desc" ]]
    } );
    $('#published.tab-pane .datatable').DataTable( {
        "order": [[ 3, "desc" ]]
    } );
} );
