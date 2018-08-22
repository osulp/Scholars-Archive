module ActiveArchive
  class OrderedNestable < ActiveTriples::Resource
    # Usage notes and expectations can be found in the Metadata Application Profile:
    #   https://docs.google.com/spreadsheets/d/1koKjV7bjn7v4r5a3gsowEimljHiAwbwuOgjHe7FEtuw/edit?usp=sharing

    attr_accessor :destroy_item # true/false
    attr_accessor :validation_msg # string

    def initialize(uri=RDF::Node.new, parent=nil, uri_label)
      if uri.try(:node?)
        uri = RDF::URI("##{uri_label}#{uri.to_s.gsub('_:', '')}")
      elsif uri.start_with?("#")
        uri = RDF::URI(uri)
      end
      super
    end

    def final_parent
      parent
    end

    def new_record?
      id.start_with?("#")
    end

    def _destroy
      false
    end
  end
end