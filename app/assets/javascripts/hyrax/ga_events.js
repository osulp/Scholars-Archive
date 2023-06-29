// overwrite to disable the file download event tracking which is handled by the ScholarsArchive::DownloadsController
// Callbacks for tracking events using Google Analytics

// Note: there is absence of testing here.  I'm not sure how or to what extent we can test what's getting
// sent to Google Analytics.

$(document).on('click', '#file_download', function (e) {
  // _gaq.push(['_trackEvent', 'Files', 'Downloaded', $(this).data('label')]);

  gtag('event', 'page_view', {
    'page_location': self.href,
    'language': navigator.language,
    'page_encoding': document.characterSet,
    'page_title': $(this).data('label'),
    'user_agent': navigator.userAgent,
  });
  gtag('event', 'Download', {
    'event_category': 'Files',
    'event_label': $(this).data('label')
  })
});
