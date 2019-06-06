# frozen_string_literal: true

# Google Scholar view helper
module GoogleScholarHelper
  def citation_publication_date(value)
    ScholarsArchive::GoogleScholarCitationService.call(value)
  end
end
