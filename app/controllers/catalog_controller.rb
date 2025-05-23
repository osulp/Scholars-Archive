# frozen_string_literal: true

# catalog controller
class CatalogController < ApplicationController
  include BlacklightAdvancedSearch::Controller
  include BlacklightRangeLimit::ControllerOverride
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior

  include BlacklightOaiProvider::Controller

  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  # Redirect for Bot Detection
  before_action { |controller| BotDetectionController.bot_detection_enforce_filter(controller) }

  def self.uploaded_field
    solr_name('date_uploaded', :stored_sortable, type: :date)
  end

  def self.title_field
    solr_name('title', :stored_sortable)
  end

  def self.modified_field
    solr_name('date_sort_combined', :stored_sortable, type: :date)
  end

  configure_blacklight do |config|
    # default advanced config values
    config.advanced_search = {
      qt: 'search',
      url_key: 'advanced',
      query_parser: 'dismax',
      form_solr_parameters: {
        'facet.limit' => 1_000
      },
      form_facet_partial: 'advanced_search_facets_as_select'
    }

    config.view.gallery.partials = %i[index_header index]
    config.view.masonry.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.search_builder_class = ScholarsArchive::CatalogSearchBuilder

    # Show gallery view
    config.view.gallery.partials = %i[index_header index]

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      qf: 'nested_ordered_title_label_tesim description_tesim creator_tesim keyword_tesim'
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name('nested_ordered_title_label', :stored_searchable)
    config.index.display_type_field = solr_name('has_model', :symbol)
    config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field 'academic_affiliation_label_ssim', label: 'Academic Affiliation', limit: 5, helper_method: :parsed_label_uri
    config.add_facet_field 'contributor_advisor_sfacet', label: 'Advisor', limit: 5, helper_method: :diacritic_facet_denorm_affixes

    config.add_facet_field(solr_name('graduation_year', :facetable)) do |field|
      field.label = 'Commencement Year'
      field.range = true
      field.include_in_advanced_search = false
    end

    config.add_facet_field solr_name('contributor_committeemember', :facetable), limit: 5, label: 'Committee Member'
    config.add_facet_field solr_name('conference_name', :facetable), limit: 5, label: 'Conference Name'
    config.add_facet_field solr_name('conference_section', :facetable), limit: 5, label: 'Conference Section/Track'
    config.add_facet_field 'creator_sfacet', label: 'Creator', limit: 5, helper_method: :diacritic_facet_denorm_affixes
    config.add_facet_field 'contributor_sfacet', label: 'Contributor', limit: 5, helper_method: :diacritic_facet_denorm_affixes

    #    config.add_facet_field 'date_facet_yearly_ssim', :label => 'Date', :range => true
    config.add_facet_field('date_facet_yearly_ssim') do |field|
      field.label = 'Date'
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
    config.add_facet_field 'degree_field_label_ssim', label: 'Degree Field', limit: 5, helper_method: :parsed_label_uri
    config.add_facet_field solr_name('degree_level', :facetable), limit: 5, label: 'Degree Level'
    config.add_facet_field solr_name('degree_name', :facetable), limit: 5, label: 'Degree Name'
    config.add_facet_field solr_name('file_format', :facetable), label: 'File Format', limit: 5
    config.add_facet_field solr_name('funding_body_label', :facetable), label: 'Funding Body', limit: 5
    config.add_facet_field 'has_journal_sfacet', limit: 5, label: 'Journal Title'
    config.add_facet_field 'language_label_ssim', label: 'Language', limit: 5
    config.add_facet_field 'license_label_ssim', label: 'License', limit: 5
    config.add_facet_field solr_name('based_near_label', :facetable), label: 'Location', limit: 5
    config.add_facet_field 'other_affiliation_label_ssim', label: 'Non-Academic Affiliation', limit: 5, helper_method: :parsed_label_uri
    config.add_facet_field 'peerreviewed_label_ssim', label: 'Peer Reviewed', limit: 2
    config.add_facet_field solr_name('resource_type', :facetable), label: 'Resource Type', limit: 5
    config.add_facet_field 'rights_statement_label_ssim', label: 'Rights Statement', limit: 5
    config.add_facet_field solr_name('subject', :facetable), label: 'Subject', limit: 5

    # config.add_facet_field solr_name("human_readable_type", :facetable), label: "Type", limit: 5
    # config.add_facet_field solr_name('member_of_collections', :symbol), limit: 5, label: 'Collections'

    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field solr_name('generic_type', :facetable), label: 'Type', if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display

    config.add_index_field solr_name('title', :stored_searchable), label: 'Title', itemprop: 'name', if: false
    config.add_index_field solr_name('creator', :stored_searchable), label: 'Creator', itemprop: 'creator', link_to_search: solr_name('creator', :facetable)
    config.add_index_field solr_name('abstract', :stored_searchable), label: 'Abstract', itemprop: 'abstract', helper_method: :truncated_summary
    config.add_index_field solr_name('resource_type', :stored_searchable), label: 'Resource Type', link_to_search: solr_name('resource_type', :facetable)
    config.add_index_field solr_name('date_created', :stored_searchable), label: 'Date Created', itemprop: 'dateCreated', helper_method: :human_readable_date_edtf, field_name: 'date_created'
    config.add_index_field 'all_text_tsimv', label: 'Full Text', highlight: true, if: lambda { |_context, _field_config, document|
      # Only try to display full text if a highlight is hit
      document.response['highlighting'][document.id].keys.include?('all_text_tsimv')
    }

    config.add_field_configuration_to_solr_request!('all_text_tsimv')

    # Disabling these from the search results view as required in issue #669 on GitHub,
    #   uncomment to enable them again as needed:
    # config.add_index_field solr_name("keyword", :stored_searchable), label: "Keyword", itemprop: 'keywords', link_to_search: solr_name("keyword", :facetable)
    # config.add_index_field solr_name("subject", :stored_searchable), label: "Subject", itemprop: 'about', link_to_search: solr_name("subject", :facetable)
    # config.add_index_field solr_name("description", :stored_searchable), label: "Description", itemprop: 'description', helper_method: :iconify_auto_link
    # config.add_index_field solr_name("contributor", :stored_searchable), label: "Contributor", itemprop: 'contributor', link_to_search: solr_name("contributor", :facetable)
    # config.add_index_field solr_name("proxy_depositor", :symbol), label: "Depositor", helper_method: :link_to_profile
    # config.add_index_field solr_name("depositor"), label: "Owner", helper_method: :link_to_profile
    # config.add_index_field solr_name("publisher", :stored_searchable), label: "Publisher", itemprop: 'publisher', link_to_search: solr_name("publisher", :facetable)
    # config.add_index_field solr_name("based_near_label", :stored_searchable), label: "Location", itemprop: 'contentLocation', link_to_search: solr_name("based_near", :facetable)
    # config.add_index_field "language_label_ssim", label: "Language", itemprop: 'inLanguage', link_to_search: solr_name("language", :facetable)
    # config.add_index_field solr_name("date_modified", :stored_sortable, type: :date), label: "Date Modified", itemprop: 'dateModified', helper_method: :human_readable_date
    # config.add_index_field solr_name("date_uploaded", :stored_sortable, type: :date), label: "Date Uploaded", itemprop: 'datePublished', helper_method: :human_readable_date
    # config.add_index_field solr_name("rights", :stored_searchable), label: "Rights", helper_method: :license_links
    # config.add_index_field solr_name("file_format", :stored_searchable), label: "File Format", link_to_search: solr_name("file_format", :facetable)
    # config.add_index_field solr_name("identifier", :stored_searchable), label: "Identifier", helper_method: :index_field_link, field_name: 'identifier'
    # config.add_index_field solr_name("embargo_release_date", :stored_sortable, type: :date), label: "Embargo release date", helper_method: :human_readable_date
    # config.add_index_field solr_name("lease_expiration_date", :stored_sortable, type: :date), label: "Lease expiration date", helper_method: :human_readable_date

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    # config.add_show_field solr_name("title", :stored_searchable), label: "Title"
    config.add_show_field solr_name('nested_ordered_title_label', :stored_searchable), label: 'Title'
    config.add_show_field solr_name('description', :stored_searchable), label: 'Description'
    config.add_show_field solr_name('keyword', :stored_searchable), label: 'Keyword'
    config.add_show_field solr_name('subject', :stored_searchable), label: 'Subject'
    # config.add_show_field solr_name("contributor", :stored_searchable), label: "Contributor"
    config.add_show_field solr_name('publisher', :stored_searchable), label: 'Publisher'
    config.add_show_field solr_name('based_near', :stored_searchable), label: 'Location'
    config.add_show_field solr_name('language', :stored_searchable), label: 'Language'
    config.add_show_field solr_name('date_accepted', :stored_searchable), label: 'Date Accepted'
    config.add_show_field solr_name('date_available', :stored_searchable), label: 'Date Available'
    config.add_show_field solr_name('date_collected', :stored_searchable), label: 'Date Collected'
    config.add_show_field solr_name('date_copyright', :stored_searchable), label: 'Date Copyright'
    config.add_show_field solr_name('date_created', :stored_searchable), label: 'Date Created'
    config.add_show_field solr_name('date_issued', :stored_searchable), label: 'Date Issued'
    config.add_show_field solr_name('date_modified', :stored_searchable), label: 'Date Modified'
    config.add_show_field solr_name('date_reviewed', :stored_searchable), label: 'Date Reviewed'
    config.add_show_field solr_name('date_uploaded', :stored_searchable), label: 'Date Uploaded'
    config.add_show_field solr_name('date_valid', :stored_searchable), label: 'Date Valid'
    config.add_show_field solr_name('nested_geo_label', :stored_searchable), label: 'Geographic Coordinates'
    config.add_show_field solr_name('nested_related_items_label', :stored_searchable), label: 'Related Items'
    config.add_show_field solr_name('nested_ordered_creator_label', :stored_searchable), label: 'Creator'
    config.add_show_field solr_name('nested_ordered_additional_information_label', :stored_searchable), label: 'Additional Information'
    config.add_show_field solr_name('nested_ordered_contributor_label', :stored_searchable), label: 'Contributor'
    config.add_show_field solr_name('nested_ordered_abstract_label', :stored_searchable), label: 'Abstract'
    config.add_show_field solr_name('rights', :stored_searchable), label: 'Rights'
    config.add_show_field solr_name('resource_type', :stored_searchable), label: 'Resource Type'
    config.add_show_field solr_name('format', :stored_searchable), label: 'File Format'
    config.add_show_field solr_name('identifier', :stored_searchable), label: 'Identifier'

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
      all_names = config.show_fields.values.map(&:field).join(' ')
      title_name = solr_name('nested_ordered_title_label', :stored_searchable)
      field.solr_parameters = {
        qf: "#{all_names} title_tesim alternative_title_tesim contributor_advisor_tesim contributor_committeemember_tesim abstract_tesim dspace_community_tesim dspace_collection_tesim degree_grantors_label_tesim nested_related_items_label_tesim nested_ordered_creator_label_tesim nested_ordered_additional_information_label_tesim nested_ordered_contributor_label_tesim nested_ordered_abstract_label_tesim degree_field_label_tesim file_format_tesim all_text_tsimv language_label_tesim rights_statement_label_tesim license_label_tesim academic_affiliation_label_tesim other_affiliation_label_tesim based_near_label_tesim web_of_science_uid_tesim",
        pf: title_name.to_s
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    # creator, title, description, publisher, date_created,
    # subject, language, resource_type, format, identifier, based_near,
    config.add_search_field('contributor') do |field|
      # solr_parameters hash are sent to Solr as ordinary url query params.

      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      solr_name = solr_name('contributor', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('academic_affiliation_label') do |field|
      solr_name = solr_name('academic_affiliation_label', :stored_searchable)
      field.include_in_simple_select = false
      field.label = 'Academic Affiliation'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('nested_related_items_label') do |field|
      solr_name = solr_name('nested_related_items_label', :stored_searchable)
      field.label = 'Related Items'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('nested_ordered_creator_label') do |field|
      solr_name = solr_name('nested_ordered_creator_label', :stored_searchable)
      field.label = 'Creator'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end
    config.add_search_field('nested_ordered_additional_information_label') do |field|
      solr_name = solr_name('nested_ordered_additional_information_label', :stored_searchable)
      field.label = 'Description'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end
    config.add_search_field('nested_ordered_title_label') do |field|
      solr_name = solr_name('nested_ordered_title_label', :stored_searchable)
      field.label = 'Title'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end
    config.add_search_field('nested_ordered_contributor_label') do |field|
      solr_name = solr_name('nested_ordered_contributor_label', :stored_searchable)
      field.label = 'Contributor'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end
    config.add_search_field('nested_ordered_abstract_label') do |field|
      solr_name = solr_name('nested_ordered_abstract_label', :stored_searchable)
      field.label = 'Abstract'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('other_affiliation_label') do |field|
      solr_name = solr_name('other_affiliation_label', :stored_searchable)
      field.include_in_simple_select = false
      field.label = 'Non-Academic Affiliation'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('dspace_collection') do |field|
      solr_name = solr_name('dspace_collection', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('dspace_community') do |field|
      solr_name = solr_name('dspace_community', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('creator') do |field|
      solr_name = solr_name('creator', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('contributor_advisor') do |field|
      solr_name = solr_name('contributor_advisor', :stored_searchable)
      field.label = 'Advisor'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('contributor_committeemember') do |field|
      solr_name = solr_name('contributor_committeemember', :stored_searchable)
      field.label = 'Committee Member'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('degree_field_label') do |field|
      #      solr_name = solr_name("degree_field_label", :stored_searchable)
      solr_name = 'degree_field_label_tesim'
      field.label = 'Degree Field'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('degree_grantors_label') do |field|
      solr_name = solr_name('degree_grantors_label', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      solr_name = solr_name('title', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('abstract') do |field|
      field.label = 'Abstract or Summary'
      solr_name = solr_name('abstract', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      solr_name = solr_name('publisher', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_accepted') do |field|
      solr_name = solr_name('date_accepted', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_available') do |field|
      solr_name = solr_name('date_available', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_collected') do |field|
      solr_name = solr_name('date_collected', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_copyright') do |field|
      solr_name = solr_name('date_copyright', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      solr_name = solr_name('created', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_issued') do |field|
      solr_name = solr_name('date_issued', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_reviewed') do |field|
      solr_name = solr_name('date_reviewed', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_valid') do |field|
      solr_name = solr_name('date_valid', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('in_series') do |field|
      solr_name = solr_name('in_series', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('conference_name') do |field|
      solr_name = solr_name('conference_name', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('has_journal') do |field|
      solr_name = solr_name('has_journal', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      solr_name = solr_name('subject', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      solr_name = solr_name('language', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language_label') do |field|
      solr_name = solr_name('language_label', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights_statement_label') do |field|
      solr_name = solr_name('rights_statement_label', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('license_label') do |field|
      solr_name = solr_name('license_label', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('peerreviewed_label') do |field|
      solr_name = solr_name('peerreviewed_label', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('resource_type') do |field|
      solr_name = solr_name('resource_type', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('hydrologic_unit_code') do |field|
      solr_name = solr_name('hydrologic_unit_code', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('nested_geo_label') do |field|
      field.label = 'Geographic Coordinates'
      field.solr_parameters = { "spellcheck.dictionary": 'nested_geo_label' }
      field.include_in_advanced_search = false
      solr_name = solr_name('nested_geo_label', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('file_format') do |field|
      solr_name = solr_name('format', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      solr_name = solr_name('id', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near') do |field|
      field.label = 'Location'
      solr_name = solr_name('based_near', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('keyword') do |field|
      solr_name = solr_name('keyword', :stored_searchable)
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      solr_name = solr_name('depositor', :symbol)
      field.include_in_advanced_search = false
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights') do |field|
      solr_name = solr_name('rights', :stored_searchable)
      field.include_in_advanced_search = false
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near_label') do |field|
      solr_name = solr_name('based_near_label', :stored_searchable)
      field.label = 'Location'
      field.solr_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: 'Relevance'
    config.add_sort_field 'title_ssort asc', label: 'Title [A-Z]'
    config.add_sort_field 'title_ssort desc', label: 'Title [Z-A]'
    config.add_sort_field "#{modified_field} desc", label: "Date Created \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "Date Created \u25B2"
    config.add_sort_field "#{uploaded_field} desc", label: "Date Uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "Date Uploaded \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    config.oai = {
      provider: {
        repository_name: 'ScholarsArchive@OSU',
        repository_url: 'https://ir.library.oregonstate.edu/catalog/oai',
        record_prefix: 'ir.library.oregonstate.edu',
        admin_email: 'scholarsarchive@oregonstate.edu'
      },
      document: {
        limit: 50,
        timestamp_field: 'system_create_dtsi',
        timestamp_method: 'system_created',
        set_fields: [
          { 'label': 'title_tesim',
            'solr_field': 'isPartOf_ssim' }
        ],
        set_model: ::OaiSet
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
