# frozen_string_literal: true

namespace :scholars_archive do
  desc 'Get current embargo state for a given list of handles'
  task :embargo_state do
    puts 'Checking embargo state values for a given list of handles from Dspace'
    get_embargo
    puts 'Done.'
  end

  def get_fileset_info(file_doc, file_id)
    solr_file_visibility = file_doc.first['visibility_ssi'].present? ? file_doc.first['visibility_ssi'] : ''
    solr_file_title = file_doc.first['title_tesim'].present? ? file_doc.first['title_tesim'].first : ''
    solr_file_embargo_release_date = file_doc.first['embargo_release_date_dtsi'].present? ? file_doc.first['embargo_release_date_dtsi'] : ''
    solr_file_visibility_during_embargo = file_doc.first['visibility_during_embargo_ssim'].present? ? file_doc.first['visibility_during_embargo_ssim'].join(' ') : ''
    solr_file_visibility_after_embargo = file_doc.first['visibility_after_embargo_ssim'].present? ? file_doc.first['visibility_after_embargo_ssim'].join(' ') : ''
    solr_file_embargo_history = file_doc.first['embargo_history_ssim'].present? ? file_doc.first['embargo_history_ssim'].join(' ') : ''
    file_url = "https://ir.library.oregonstate.edu/concern/#{file_doc.first['has_model_ssim'].first.underscore.pluralize}/#{file_id}"

    file_set = {}
    file_set['file_id'] = file_id
    file_set['solr_file_title'] = solr_file_title
    file_set['solr_file_visibility'] = solr_file_visibility
    file_set['solr_file_embargo_release_date'] = solr_file_embargo_release_date
    file_set['solr_file_visibility_during_embargo'] = solr_file_visibility_during_embargo
    file_set['solr_file_visibility_after_embargo'] = solr_file_visibility_after_embargo
    file_set['solr_file_embargo_history'] = solr_file_embargo_history
    file_set['file_url'] = file_url
    file_set
  end

  def get_child_file_sets_info(member_ids, item, logger)
    file_sets = []
    member_ids.each do |file_id|
      file_doc = ActiveFedora::SolrService.query("id:#{file_id}", rows: 1)

      if file_doc.present? && file_doc.first['has_model_ssim'].first == 'FileSet'
        file_set = get_fileset_info(file_doc, file_id)
        file_sets << file_set
      else
        logger.info "no child work or fileset found in solr that matches id #{file_id} for dspace_item #{item}"
      end
    end
    file_sets
  end

  def get_all_file_sets_info(member_ids, item, logger)
    all_file_sets = []
    member_ids.each do |file_id|
      file_doc = ActiveFedora::SolrService.query("id:#{file_id}", rows: 1)

      if file_doc.present?
        if file_doc.first['has_model_ssim'].first == 'FileSet'
          file_set = get_fileset_info(file_doc, file_id)
          all_file_sets << file_set
        else
          child_member_ids = file_doc.first['member_ids_ssim'] || []
          child_file_sets = get_child_file_sets_info(child_member_ids, item, logger)
          child_file_sets.each do |child_file_set|
            all_file_sets << child_file_set
          end
        end
      else
        logger.info "no work or fileset found in solr that matches id #{file_id} for dspace_item #{item}"
      end
    end
    all_file_sets
  end

  def find_doc_by_bitstream_name(solr_file_sets, bitstream_name)
    raw_match = solr_file_sets.find { |x| x['solr_file_title'] == bitstream_name }
    if raw_match.nil?
      clean_name = URI.encode(bitstream_name.gsub(/[\s\[\]\(\)\u2019\u2013+',&><]/, '_'))
      return solr_file_sets.find { |x| x['solr_file_title'] == clean_name }
    else
      return raw_match
    end
  end

  def get_embargo
    datetime_today = DateTime.now.strftime('%m-%d-%Y-%H-%M-%p') # "10-27-2017-12-59-PM"
    logger = ActiveSupport::Logger.new("#{Rails.root}/log/check-embargo-state-#{datetime_today}.log")
    items_embargo = YAML.load_file('tmp/dspace_bitstream_items_embargo.yml')['dspace_bitstream_items_embargo'] || {}
    counter = 0
    file_counter = 0
    require 'csv'

    output_path = "tmp/embargo-state-ouput-#{datetime_today}.csv"

    CSV.open(output_path, 'w') do |csv|
      csv << ['dspace_handle',
              'dspace_embargo_date',
              'dspace_visibility',

              'work_id',
              'url',

              # values in solr
              'solr_work_visibility',
              'solr_embargo_release_date',
              'solr_visibility_during_embargo',
              'solr_visibility_after_embargo',
              'solr_embargo_history']

      items_embargo.each do |item|
        dspace_handle = item['handle']
        dspace_handle_embargo_date = item['handle_embargo_date']
        dspace_handle_visibility = item['handle_visibility']

        handle = RSolr.solr_escape(dspace_handle)
        doc = ActiveFedora::SolrService.query("replaces_ssim:#{handle}", rows: 1_000_000)

        logger.info "checking embargo for #{item['handle']}"

        if doc.present?
          solr_work_visibility = doc.first['visibility_ssi'].present? ? doc.first['visibility_ssi'] : ''
          solr_embargo_release_date = doc.first['embargo_release_date_dtsi'].present? ? doc.first['embargo_release_date_dtsi'] : ''
          solr_visibility_during_embargo = doc.first['visibility_during_embargo_ssim'].present? ? doc.first['visibility_during_embargo_ssim'].join(' ') : ''
          solr_visibility_after_embargo = doc.first['visibility_after_embargo_ssim'].present? ? doc.first['visibility_after_embargo_ssim'].join(' ') : ''
          solr_embargo_history = doc.first['embargo_history_ssim'].present? ? doc.first['embargo_history_ssim'].join(' ') : ''

          work_url = "https://ir.library.oregonstate.edu/concern/#{doc.first['has_model_ssim'].first.underscore.pluralize}/#{doc.first['id']}"

          csv << [dspace_handle,
                  dspace_handle_embargo_date,
                  dspace_handle_visibility,

                  doc.first['id'],
                  work_url,

                  solr_work_visibility,
                  solr_embargo_release_date,
                  solr_visibility_during_embargo,
                  solr_visibility_after_embargo,
                  solr_embargo_history]
          counter += 1

          # TODO: [child member or file set] retrieve child/member works (work.ordered_members) to double check embargo visibility at the file level
          # TODO: [child member or file set] add line to csv row for each file/work member
          dspace_bitstream = item['bitstream']
          if doc.first['member_ids_ssim']
            member_ids = doc.first['member_ids_ssim']
          else
            logger.info "no files associated for work #{doc.first['id']} #{doc.first['has_model_ssim'].first.underscore.pluralize} expecting one or more bitstreams for dspace item #{item}"
            member_ids = []
          end

          # build hash of files to be used to map the bitstreams later...
          solr_file_sets = get_all_file_sets_info(member_ids, item, logger)

          dspace_bitstream.each do |bitstream|
            handle_bitstream = "http://dspace-ir.library.oregonstate.edu/xmlui/bitstream/handle#{URI(dspace_handle).path}/#{bitstream['bitstream_name']}"
            logger.info "checking embargo for bitstream #{handle_bitstream}"

            file_solr_doc = find_doc_by_bitstream_name(solr_file_sets, bitstream['bitstream_name'])

            solr_fileset_id = file_solr_doc.present? && file_solr_doc['file_id'].present? ? file_solr_doc['file_id'] : ''
            solr_fileset_url = file_solr_doc.present? && file_solr_doc['file_url'].present? ? file_solr_doc['file_url'] : ''
            solr_fileset_visibility = file_solr_doc.present? && file_solr_doc['solr_file_visibility'].present? ? file_solr_doc['solr_file_visibility'] : ''
            solr_fileset_embargo_release_date = file_solr_doc.present? && file_solr_doc['solr_file_embargo_release_date'].present? ? file_solr_doc['solr_file_embargo_release_date'] : ''
            solr_fileset_visibility_during_embargo = file_solr_doc.present? && file_solr_doc['solr_file_visibility_during_embargo'].present? ? file_solr_doc['solr_file_visibility_during_embargo'] : ''
            solr_fileset_visibility_after_embargo = file_solr_doc.present? && file_solr_doc['solr_file_visibility_after_embargo'].present? ? file_solr_doc['solr_file_visibility_after_embargo'] : ''
            solr_fileset_embargo_history = file_solr_doc.present? && file_solr_doc['solr_file_embargo_history'].present? ? file_solr_doc['solr_file_embargo_history'] : ''

            csv << [
              handle_bitstream,
              bitstream['bitstream_embargo_date'],
              bitstream['bitstream_embargo_visibility'],

              solr_fileset_id,
              solr_fileset_url,

              solr_fileset_visibility,
              solr_fileset_embargo_release_date,
              solr_fileset_visibility_during_embargo,
              solr_fileset_visibility_after_embargo,
              solr_fileset_embargo_history
            ]
            file_counter += 1
          end
        else
          logger.info "no work associated for dspace item #{item}"
        end
      end
    end

    logger.info "Done. Retrieved a total of #{counter} works and #{file_counter} bitstreams."
  end
end
