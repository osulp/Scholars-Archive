module ScholarsArchive
  # Provide select options for the degree_grantors field
  class DegreeGrantorsService < Hyrax::QaSelectService
    def initialize
      super('degree_grantors')
    end

    ##
    # Show all options for admin users, and a filtered list for regular users. See config/authorities/degree_grantors.yml and `is_admin` hash key
    # for the hook here. DegreeGrantors is specified as an ExtendedFileBasedAuthority in Hyrax initializer to facilitate this additional
    # key functionality in a locally hosted authority.
    # For the edge case where a non-admin users is editing a form, always ensure that the the "current degree_grantors value" is in the
    # select option list.
    def select_sorted_all_options(value, admin_only = false)
      admin_select = [false]
      admin_select << true if admin_only
      options = @authority.all.select { |element| admin_select.include?(element[:admin_only]) || element[:id] == value }.map do |element|
        [element[:label], element[:id]]
      end
      options.sort
    end
  end
end
