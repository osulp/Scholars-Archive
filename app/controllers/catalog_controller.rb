class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller
  include BlacklightRangeLimit::ControllerOverride
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior

  include BlacklightOaiProvider::CatalogControllerBehavior

  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  def self.uploaded_field
    solr_name('date_uploaded', :stored_sortable, type: :date)
  end

  def self.title_field
    solr_name('title', :stored_sortable)
  end

  def self.modified_field
    solr_name('date_created', :stored_sortable, type: :date)
  end

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search = {
      qt:'search',
      url_key: 'advanced',
      query_parser: 'dismax',
      form_solr_parameters: {
        "facet.limit" => 20,
        "facet.sort" => "index" # sort by byte order of values
      }
    }

    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]


    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.search_builder_class = ScholarsArchive::CatalogSearchBuilder

    # Show gallery view
    config.view.gallery.partials = [:index_header, :index]
    config.view.slideshow.partials = [:index]

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: "search",
      rows: 10,
      qf: "title_tesim description_tesim creator_tesim keyword_tesim"
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name("title", :stored_searchable)
    config.index.display_type_field = solr_name("has_model", :symbol)
    config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field "academic_affiliation_label_ssim", label: "Academic Affiliation", limit: 5, helper_method: :parsed_label_uri
    config.add_facet_field solr_name('contributor_advisor', :facetable), limit: 5, label: 'Advisor'

    config.add_facet_field(solr_name('graduation_year', :facetable)) do |field|
      field.label = "Commencement Year"
      field.range = true
      field.include_in_advanced_search = false
    end

    config.add_facet_field solr_name('contributor_committeemember', :facetable), limit: 5, label: 'Committee Member'
    config.add_facet_field solr_name('conference_name', :facetable), limit: 5, label: 'Conference Name'
    config.add_facet_field solr_name('conference_section', :facetable), limit: 5, label: 'Conference Section/Track'
    config.add_facet_field solr_name("creator", :facetable), label: "Creator", limit: 5

#    config.add_facet_field 'date_facet_yearly_ssim', :label => 'Date', :range => true
    config.add_facet_field('date_facet_yearly_ssim') do |field|
      field.label = "Date"
      field.range = true
      field.include_in_advanced_search = false
    end

    config.add_facet_field 'date_decades_ssim' do |field|
      field.label = 'Decade'
      field.limit = 10
      field.sort = 'index'
      field.partial = 'date_decades_facet'
      field.include_in_advanced_search = false
    end
    config.add_facet_field "degree_field_label_ssim", label: "Degree Field", limit: 5, helper_method: :parsed_label_uri
    config.add_facet_field solr_name('degree_level', :facetable), limit: 5, label: 'Degree Level'
    config.add_facet_field solr_name('degree_name', :facetable), limit: 5, label: 'Degree Name'
    config.add_facet_field solr_name("file_format", :facetable), label: "File Format", limit: 5
    config.add_facet_field solr_name("funding_body", :facetable), label: "Funding Body", limit: 5
    config.add_facet_field solr_name('has_journal', :facetable), limit: 5, label: 'Journal Title'
    config.add_facet_field "language_label_ssim", label: "Language", limit: 5
    config.add_facet_field "license_label_ssim", label: "License", limit: 5
    config.add_facet_field solr_name("based_near_label", :facetable), label: "Location", limit: 5
    config.add_facet_field "other_affiliation_label_ssim", label: "Non-Academic Affiliation", limit: 5, helper_method: :parsed_label_uri
    config.add_facet_field "peerreviewed_label_ssim", label: "Peer Reviewed", limit: 2
    config.add_facet_field solr_name("resource_type", :facetable), label: "Resource Type", limit: 5
    config.add_facet_field "rights_statement_label_ssim", label: "Rights Statement", limit: 5
    config.add_facet_field solr_name("subject", :facetable), label: "Subject", limit: 5

    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field solr_name("generic_type", :facetable), label: "Type", if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display

    config.add_index_field solr_name("title", :stored_searchable), label: "Title", itemprop: 'name', if: false
    config.add_index_field solr_name("creator", :stored_searchable), label: "Creator", itemprop: 'creator', link_to_search: solr_name("creator", :facetable)
    config.add_index_field solr_name("abstract", :stored_searchable), label: "Abstract", itemprop: 'abstract', helper_method: :truncated_summary
    config.add_index_field solr_name("resource_type", :stored_searchable), label: "Resource Type", link_to_search: solr_name("resource_type", :facetable)
    config.add_index_field solr_name("date_created", :stored_searchable), label: "Date Created", itemprop: 'dateCreated', helper_method: :human_readable_date_edtf, field_name: 'date_created'

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field solr_name("title", :stored_searchable), label: "Title"
    config.add_show_field solr_name("description", :stored_searchable), label: "Description"
    config.add_show_field solr_name("keyword", :stored_searchable), label: "Keyword"
    config.add_show_field solr_name("subject", :stored_searchable), label: "Subject"
    config.add_show_field solr_name("contributor", :stored_searchable), label: "Contributor"
    config.add_show_field solr_name("publisher", :stored_searchable), label: "Publisher"
    config.add_show_field solr_name("based_near", :stored_searchable), label: "Location"
    config.add_show_field solr_name("language", :stored_searchable), label: "Language"
    config.add_show_field solr_name("date_accepted", :stored_searchable), label: "Date Accepted"
    config.add_show_field solr_name("date_available", :stored_searchable), label: "Date Available"
    config.add_show_field solr_name("date_collected", :stored_searchable), label: "Date Collected"
    config.add_show_field solr_name("date_copyright", :stored_searchable), label: "Date Copyright"
    config.add_show_field solr_name("date_created", :stored_searchable), label: "Date Created"
    config.add_show_field solr_name("date_issued", :stored_searchable), label: "Date Issued"
    config.add_show_field solr_name("date_modified", :stored_searchable), label: "Date Modified"
    config.add_show_field solr_name("date_reviewed", :stored_searchable), label: "Date Reviewed"
    config.add_show_field solr_name("date_uploaded", :stored_searchable), label: "Date Uploaded"
    config.add_show_field solr_name("date_valid", :stored_searchable), label: "Date Valid"
    config.add_show_field solr_name("nested_geo_label", :stored_searchable), label: "Geographic Coordinates"
    config.add_show_field solr_name("nested_related_items_label", :stored_searchable), label: "Related Items"
    config.add_show_field solr_name("nested_ordered_creator_label", :stored_searchable), label: "Creator"
    config.add_show_field solr_name("nested_ordered_title_label", :stored_searchable), label: "Creator"
    config.add_show_field solr_name("rights", :stored_searchable), label: "Rights"
    config.add_show_field solr_name("resource_type", :stored_searchable), label: "Resource Type"
    config.add_show_field solr_name("format", :stored_searchable), label: "File Format"
    config.add_show_field solr_name("identifier", :stored_searchable), label: "Identifier"

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: 'All Fields') do |field|
      all_names = config.show_fields.values.map(&:field).join(" ")
      title_name = solr_name("title", :stored_searchable)
      field.solr_parameters = {
        qf: "#{all_names} contributor_advisor_tesim contributor_committeemember_tesim abstract_tesim dspace_community_tesim dspace_collection_tesim degree_grantors_label_tesim nested_related_items_label_tesim nested_ordered_creator_label_tesim nested_ordered_title_label_tesim degree_field_label_tesim file_format_tesim all_text_timv language_label_tesim rights_statement_label_tesim license_label_tesim academic_affiliation_label_tesim other_affiliation_label_tesim based_near_label_tesim web_of_science_uid_tesim",
        pf: title_name.to_s
      }
    end

    stored_searchable_fields = [
      {field_name: "academic_affiliation_label" , field_label: "Academic Affiliation", simple_select: false},
      {field_name: "other_affiliation_label" , field_label: "Non-Academic Affiliation", simple_search: false},
      {field_name: "nested_related_items_label" , field_label: "Related Items"},
      {field_name: "nested_ordered_creator_label" , field_label: "Creator"},
      {field_name: "nested_ordered_title_label" , field_label: "Title"},
      {field_name: "dspace_collection" , field_label: "Dspace Collection"},
      {field_name: "dspace_community" , field_label: "Dspace Community"},
      {field_name: "contributor_advisor" , field_label: "Advisor"},
      {field_name: "contributor_committeemember" , field_label: "Committee Member"},
      {field_name: "degree_grantors_label" , field_label: "Degree Grantors", advanced_search: false},
      {field_name: "abstract" , field_label: "Abstract or Summary"},
      {field_name: "publisher" , field_label: "Publisher"},
      {field_name: "date_accepted" , field_label: "Date Accepted"},
      {field_name: "date_available" , field_label: "Date Available"},
      {field_name: "date_collected" , field_label: "Date Collected"},
      {field_name: "date_copyright" , field_label: "Date Copyrighted"},
      {field_name: "date_issued" , field_label: "Date Issued"},
      {field_name: "date_reviewed" , field_label: "Date Reviewed"},
      {field_name: "date_valid" , field_label: "Date Valid"},
      {field_name: "subject" , field_label: "Subject"},
      {field_name: "language" , field_label: "Language", advanced_search: false},
      {field_name: "language_label" , field_label: "Language Label", advanced_search: false},
      {field_name: "rights_statement_label" , field_label: "Rights Statement", advanced_search: false},
      {field_name: "license_label" , field_label: "License", advanced_search: false},
      {field_name: "peerreviewed_label" , field_label: "Peer Reviewed", advanced_search: false},
      {field_name: "resource_type" , field_label: "Resource Type", advanced_search: false},
      {field_name: "hydrologic_unit_code" , field_label: "Hydrological Unit Code"},
      {field_name: "based_near" , field_label: "Location", advanced_search: false},
      {field_name: "keyword" , field_label: "Keyword"},
      {field_name: "rights" , field_label: "Rights", advanced_search: false},
      {field_name: "based_near_label" , field_label: "Location"}
    ]

    stored_searchable_fields.each do |field|
      config.add_search_field(field[:field_name]) do |field|
        solr_name = solr_name(field[:field_name], :stored_searchable)
        field.include_in_simple_select = field[:simple_select] unless field[:simple_select].nil?
        field.include_in_advanced_search = field[:advanced_search] unless field[:advanced_search].nil?

        field.label = field[:field_label]
        field.solr_local_parameters = {
          qf: solr_name,
          pf: solr_name
        }
      end
    end

    # config.add_search_field('creator') do |field|
    #   solr_name = solr_name("creator", :stored_searchable)
    #   field.solr_local_parameters = {
    #     qf: solr_name,
    #     pf: solr_name
    #   }
    # end


    config.add_search_field('degree_field_label') do |field|
#      solr_name = solr_name("degree_field_label", :stored_searchable)
      solr_name = "degree_field_label_tesim"
      field.label = "Degree Field"
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # config.add_search_field('title') do |field|
    #   solr_name = solr_name("title", :stored_searchable)
    #   field.solr_local_parameters = {
    #     qf: solr_name,
    #     pf: solr_name
    #   }
    # end

    config.add_search_field('nested_geo_label') do |field|
      field.label = "Geographic Coordinates"
      field.solr_parameters = { :"spellcheck.dictionary" => "nested_geo_label" }
      field.include_in_advanced_search = false
      solr_name = solr_name("nested_geo_label", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('file_format') do |field|
      solr_name = solr_name("format", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      solr_name = solr_name("id", :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: "relevance"
    config.add_sort_field "#{title_field} asc", label: "Title [A-Z]"
    config.add_sort_field "#{title_field} desc", label: "Title [Z-A]"
    config.add_sort_field "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "date modified \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    config.oai = {
      provider: {
        repository_name: 'ScholarsArchive@OSU',
        repository_url: 'http://ir.library.oregonstate.edu',
        record_prefix: 'ir.library.oregonstate.edu',
        admin_email: 'scholarsarchive@oregonstate.edu'
      },
      document: {
        limit: 50,
        timestamp_field: 'system_create_dtsi',
        timestamp_method: 'system_created',
        set_fields: 'isPartOf_ssim',
        set_class: '::OaiSet'
      }
    }
  end

  # disable the bookmark control from displaying in gallery view
  # Hyrax doesn't show any of the default controls on the list view, so
  # this method is not called in that context.
  def render_bookmarks_control?
    false
  end
end
