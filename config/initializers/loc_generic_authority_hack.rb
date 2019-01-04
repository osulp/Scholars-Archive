# frozen_string_literal: true

Qa::Authorities::Loc::GenericAuthority.class_eval do
  def build_query_url(q)
    escaped_query = "#{URI.escape(q)}*"
    authority_fragment = Qa::Authorities::Loc.get_url_for_authority(subauthority) + URI.escape(subauthority)
    "http://id.loc.gov/search/?q=#{escaped_query}&q=#{authority_fragment}&format=json"
  end
end
