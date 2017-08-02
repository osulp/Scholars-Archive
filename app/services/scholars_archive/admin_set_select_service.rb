module ScholarsArchive
  class AdminSetSelectService
    #This method selects an admin set based on a model type. By passing in the
    #model and the select options, the method can look at the configuration and
    #make a decision about what admin set to use. 
    #Inputs: Model, Select Options
    #Output: Array with stingified admin set name ["Article"]
    def self.select(model, select_options)
      admin_set_name = YAML.load(File.read("config/admin_set_map.yml"))[model]
      mapped_admin_set = select_options.find { |o| o.first.casecmp(admin_set_name).zero? }
      [ mapped_admin_set || select_options.find { |o| o.first.casecmp(ENV["SCHOLARSARCHIVE_DEFAULT_ADMIN_SET"]).zero? } ].flatten
    end
  end
end
