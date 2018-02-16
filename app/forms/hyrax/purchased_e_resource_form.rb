# Generated via
#  `rails generate hyrax:work PurchasedEResource`
module Hyrax
  class PurchasedEResourceForm < DefaultForm
    include ::ScholarsArchive::TriplePoweredProperties::TriplePoweredForm
    include ScholarsArchive::EtdWorkFormBehavior
    include ScholarsArchive::ArticleWorkFormBehavior

    self.model_class = ::PurchasedEResource
  end
end
