# frozen_string_literal: true

module ScholarsArchive
  class ExtendedFileBasedAuthority < Qa::Authorities::Local::FileBasedAuthority
    def all
      terms.map do |res|
        id = res.delete(:id)
        label = res.delete(:term)
        active = res.delete(:active) || true

        h = { id: id, label: label, active: active }.with_indifferent_access
        res.each_pair { |k,v| h[k.to_sym] = v }
        h
      end
    end
  end
end
