# frozen_string_literal: true

module Hyrax
  module Workflow
    ##
    # Decorates objects with attributes with their workflow state.
    class ObjectInWorkflowDecorator < Hyrax::ModelDecorator
      delegate_all

      ##
      # @!attribute [w] workflow
      #   @return [Sipity::Workflow]
      # @!attribute [w] workflow_state
      #   @return [Sipity::WorkflowState]
      attr_writer :workflow, :workflow_state

      ##
      # OVERRIDE FROM HYRAX: Downcase the state names to make sure they match
      # @return [Boolean]
      def published?
        Hyrax::Admin::WorkflowsController.deposited_workflow_state_name.downcase ==
          workflow_state.downcase
      end
      # END OVERRIDE

      ##
      # @return [String]
      def workflow_state
        @workflow_state&.name || 'unknown'
      end
    end
  end
end
