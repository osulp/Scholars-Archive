# YAML LOAD: Add in a variable to load the YAML file from 'other_affiliation' to use the
#            naming convention for the display on the show page
OTHER_AFFILIATION = YAML.load_file("#{Rails.root}/config/authorities/other_affiliation.yml")
