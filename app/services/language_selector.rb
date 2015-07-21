class LanguageSelector
  pattr_initialize :literals
  
  def labels
    if found_labels.empty?
      literals
    else
      found_labels
    end
  end

  private

  def found_labels
    @found_labels ||= literals.select do |literal|
      binding.pry
      preferred_labels.include?(literal.language.to_s)
    end
  end

  def preferred_labels
    ["en-us", "en"]
  end

  # Decorator for LabelFinders - returns the selected label as the first
  # element. Necessary because the initializer takes a resource rather than
  # literals.
  class LabelFinder < SimpleDelegator
   def labels
      LanguageSelector.new(super).labels
    end
  end

  # Factory for LanguageSelector - decorates other factories so that it wraps
  # things that are made with a LanguageSelector::Finder.
  class LabelFinderFactory < SimpleDelegator
    # @param [ActiveTriples::Resource] resource Resource to get RDF labels from.
    def new(*args)
      LabelFinder.new(super)
    end
  end
end
