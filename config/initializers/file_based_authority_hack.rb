Qa::Authorities::Local::FileBasedAuthority.class_eval do
  def all
    terms.map do |res|
      res[:active] = true if res[:active].nil?
      { id: res[:id], label: res[:term], active: res[:active] }.with_indifferent_access
    end
  end
end
