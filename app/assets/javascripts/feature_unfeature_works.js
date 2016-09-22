Blacklight.onLoad(function() {
  $(document).on('click','.show-actions a[data-behavior="feature"]', function(evt) {
    evt.preventDefault();
    anchor = $(this);
    $.ajax({
      url: anchor.attr('href'),
      type: "post",
      success: function(data) {
        anchor.before('<a data-behavior="unfeature" id="unfeatureLink" name="unfeatureLink" class="btn btn-default" href="'+anchor.attr('href')+'">Unfeature</a>');
        anchor.remove();
      }
    });
  });

  $(document).on('click','.show-actions a[data-behavior="unfeature"]', function(evt) {
    evt.preventDefault();
    anchor = $(this);
    $.ajax({
      url: anchor.attr('href'),
      type: "POST",
      data: {"_method":"delete"}, 
      success: function(data) {
        anchor.before('<a data-behavior="feature" id="featureLink" name="featureLink" class="btn btn-default" href="'+anchor.attr('href')+'">Feature</a>');
        anchor.remove();
      }
    });
  });

});
