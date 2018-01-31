$(document).on('ready turbolinks:load', function() {
    review_table_selector = '#under-review.tab-pane .datatable'
    if ( $.fn.dataTable.isDataTable(review_table_selector) ) {
        review_table = $(review_table_selector).DataTable();
        review_table.order([ 3, "desc" ]).pageLength(50).draw();
    }
    else {
        review_table = $(review_table_selector).DataTable( {
            "order": [[ 3, "desc" ]],
            "pageLength": 50
        } );
    }

    published_table_selector = '#published.tab-pane .datatable'
    if ( $.fn.dataTable.isDataTable(published_table_selector) ) {
        published_table = $(published_table_selector).DataTable();
        published_table.order([ 3, "desc" ]).pageLength(50).draw();
    }
    else {
        published_table = $(published_table_selector).DataTable( {
            "order": [[ 3, "desc" ]],
            "pageLength": 50
        } );
    }
} );
