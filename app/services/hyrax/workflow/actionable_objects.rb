# frozen_string_literal: true
# OVERRIDE FROM HYRAX:
# Backport of https://github.com/samvera/hyrax/pull/6000. Remove this overriden file when upgrading to Hyrax 5.x.
module Hyrax
  module Workflow
    ##
    # Produces a list of workflow-ready objects for a given user. Results are
    # given as a presenter objects with SolrDocument-like behavior, with added
    # support for workflow states.
    #
    # @example
    #   Hyrax::Workflow::ActionableObjects.new(user: current_user).each do |object|
    #     puts object.title
    #     puts object.workflow_state
    #   end
    #
    # @see Hyrax::Workflow::ObjectInWorkflowDecorator
    class ActionableObjects
      include Enumerable

      ##
      # @!attribute [rw] user
      #   @return [::User]
      attr_accessor :user
      ##
      # @!attribute [rw] workflow_state_filter
      #   @return [String]
      attr_accessor :workflow_state_filter
      ##
      # @!attribute [rw] page of results to return, 1 based
      #   @return [Integer]
      attr_accessor :page
      ##
      # @!attribute [rw] per_page number of results in the page
      #   @return [Integer]
      attr_accessor :per_page

      ##
      # @param [::User] user the user whose
      # @param [String] optional filter by workstate name
      def initialize(user:, workflow_state_filter: nil)
        @user = user
        @workflow_state_filter = workflow_state_filter
        @page = 1
        @per_page = 10
      end

      ##
      # @return [Hyrax::Workflow::ObjectInWorkflowDecorator]
      def each
        return enum_for(:each) unless block_given?
        ids_and_states = id_state_pairs
        return if ids_and_states.none?

        # OVERRIDE FROM HYRAX: index states by id; Replace upstream's Array#find in below docs.each loop below
        state_by_id = ids_and_states.to_h

        docs = Hyrax::SolrQueryService.new.with_ids(ids: ids_and_states.map(&:first))
                                      .solr_documents(page: @page, rows: @per_page, sort: 'system_create_dtsi ASC')

        docs.each do |solr_doc|
          object = ObjectInWorkflowDecorator.new(solr_doc)

          object.workflow_state = state_by_id[object.id]

          yield object
        end
      end

      ##
      # @return [Integer] total number of entities selected
      def total_count
        PermissionQuery.scope_entities_for_the_user(user: user, workflow_state_filter: workflow_state_filter)
                       .count
      end

      private

      ##
      # @api private
      # @return [Array[String, Sipity::WorkflowState]]
      def id_state_pairs
        gids_and_states = PermissionQuery
                          .scope_entities_for_the_user(user: user, page: page, per_page: per_page, workflow_state_filter: workflow_state_filter)
                          .order(created_at: :asc)
                          .pluck(:proxy_for_global_id, :workflow_state_id)

        return [] if gids_and_states.none?

        all_states = Sipity::WorkflowState.find(gids_and_states.map(&:last).uniq)

        # OVERRIDE FROM HYRAX: index states by id; Replace upstream's Array#find in gids_and_states.map loop below
        state_by_id = all_states.index_by(&:id)

        gids_and_states.map do |str, state_id|
          [GlobalID.new(str).model_id,
           state_by_id[state_id]]
        end
      end
    end
  end
end
