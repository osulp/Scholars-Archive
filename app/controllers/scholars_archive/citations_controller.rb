# frozen_string_literal: true

module ScholarsArchive
  # downloads controller
  class CitationsController < Hyrax::CitationsController
    def mla
      show
    end

    def apa
      show
    end

    def chicago
      show
    end
  end
end

