# frozen_string_literal: true

# Generated via
#  `rails generate hyrax:work Article`
module Hyrax
  #form object for article
  class ArticleForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::ArticleWorkFormBehavior

    self.model_class = ::Article
  end
end
