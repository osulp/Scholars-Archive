class AllLabelFinder
  pattr_initialize :resource

  def labels
    label_predicates.map do |predicate|
      resource.get_values(predicate, :cast => false, :literal => true)
    end.flatten.compact
  end

  private

  def label_predicates
   Array.wrap(resource.class.rdf_label) + resource.__send__(:default_labels)
  end
end
