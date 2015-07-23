class CompositeLabel
  pattr_initialize :labels

  def to_s
    labels.first.to_s
  end
end
