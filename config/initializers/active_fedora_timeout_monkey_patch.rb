# TODO: we can remove this file once this PR https://github.com/samvera/active_fedora/pull/1271 is released in active-fedora

module ActiveFedoraOverride
  def request_options
    @config[:request]
  end

  def authorized_connection
    super.tap do |conn|
      if request_options
        request_options.each do |option, value|
          conn.options[option.to_sym] = value
        end
      end
    end
  end
end

ActiveFedora::Fedora.class_eval do
  prepend ActiveFedoraOverride unless self.class.include?(ActiveFedoraOverride)
end
