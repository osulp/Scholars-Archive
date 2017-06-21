Hyrax::QaSelectService.class_eval do
  def active_elements
    authority.all.select { |e| e.fetch('active') }
  end
end
