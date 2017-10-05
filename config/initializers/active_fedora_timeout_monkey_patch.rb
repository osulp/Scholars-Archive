# TODO: we can remove this file once this PR https://github.com/samvera/active_fedora/pull/1271 is released in active-fedora

module ActiveFedoraOverride
  def authorized_connection
    super.tap do |conn|
      if @config[:request][:timeout] && @config[:request][:timeout].to_i > 0
        conn.options[:timeout] = @config[:request][:timeout].to_i
      end
      if @config[:request][:open_timeout] && @config[:request][:open_timeout].to_i > 0
        conn.options[:open_timeout] = @config[:request][:open_timeout].to_i
      end
    end
  end
end

ActiveFedora::Fedora.class_eval do
  prepend ActiveFedoraOverride unless self.class.include?(ActiveFedoraOverride)
end
