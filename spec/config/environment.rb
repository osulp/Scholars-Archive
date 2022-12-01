# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'

RSpec.describe ActiveSupport::Logger do
  # CREATE TEST: Testing the log custom formatting
  describe '#log_formatting' do
    # Setup logger testing variables
    let(:log) { StringIO.new }
    let(:logger) { Logger.new(log) }
    let(:severity) { Logger::INFO }
    let(:progname) { 'bar' }

    # Setup couple test messages to see if it parse correctly in logs
    let(:msg1) { 'baz' }
    let(:msg2) { '[123-456-789] [/images/24-ve3/test] baz' }
    let(:msg3) { '[123-456-789] [/images/24-ve3/test] baz http://test/ Service: 1234567890' }
    let(:msg4) { '[123-456-789] baz http://test/' }
    let(:msg5) { '[[123-456-789]] [/images/]attach baz' }
    let(:msg6) { '[123-456-789] [/images/]attach] baz' }

    # Setup the formatter before doing any test
    before do
      logger.formatter = Rails.application.config.log_formatter
    end

    # FORMAT TEST: Testing if the file return via the JSON format
    it 'return log data into JSON format' do
      logger.add(severity, msg1, progname)
      log.rewind

      expect(JSON.parse(log.read)).to be_a(Hash)
    end

    # VALUE TEST: Testing if the file return the format with the correct data
    it 'return log data and matches with the data it pass in' do
      logger.add(severity, msg1, progname)
      log.rewind

      expect(JSON.parse(log.read)).to match('date' => Time.now.to_s,
                                            'log_level' => 'INFO',
                                            'req_id' => '',
                                            'req_uri' => '',
                                            'uri' => '',
                                            'message' => 'baz',
                                            'service_id' => '')
    end

    # SPECIFIC TEST #1: Testing to see if the data for req_id & req_uri are pull out correctly
    it 'add in the req_id & req_uri to the proper location in the format' do
      logger.add(severity, msg2, progname)
      log.rewind

      expect(JSON.parse(log.read)).to match('date' => Time.now.to_s,
                                            'log_level' => 'INFO',
                                            'req_id' => '123-456-789',
                                            'req_uri' => '/images/24-ve3/test',
                                            'uri' => '',
                                            'message' => 'baz',
                                            'service_id' => '')
    end

    # SPECIFIC TEST #2: Testing to see if the data parse everything correctly
    it 'add in all the data correctly to the spot in JSON format' do
      logger.add(severity, msg3, progname)
      log.rewind

      expect(JSON.parse(log.read)).to match('date' => Time.now.to_s,
                                            'log_level' => 'INFO',
                                            'req_id' => '123-456-789',
                                            'req_uri' => '/images/24-ve3/test',
                                            'uri' => 'http://test/',
                                            'message' => 'baz http://test/ Service: 1234567890',
                                            'service_id' => '1234567890')
    end

    # SPECIFIC TEST #3: Testing if some data does not present in the log
    it 'format correctly even if some data are not present' do
      logger.add(severity, msg4, progname)
      log.rewind

      expect(JSON.parse(log.read)).to match({ 'date' => Time.now.to_s,
                                              'log_level' => 'INFO',
                                              'req_id' => '123-456-789',
                                              'req_uri' => '',
                                              'uri' => 'http://test/',
                                              'message' => 'baz http://test/',
                                              'service_id' => '' })
    end

    # FAIL TEST #1: Testing to see the parsing fail
    it 'will not parse correctly w/ some edge cases' do
      logger.add(severity, msg5, progname)
      log.rewind

      expect(JSON.parse(log.read)).not_to match({ 'date' => Time.now.to_s,
                                                  'log_level' => 'INFO',
                                                  'req_id' => '123-456-789',
                                                  'req_uri' => '/images/',
                                                  'uri' => '',
                                                  'message' => 'attach baz',
                                                  'service_id' => '' })
    end

    # FAIL TEST #2: Testing to see the parsing fail
    it 'will not parse correctly w/ having bracket inside the uri' do
      logger.add(severity, msg6, progname)
      log.rewind

      expect(JSON.parse(log.read)).not_to match({ 'date' => Time.now.to_s,
                                                  'log_level' => 'INFO',
                                                  'req_id' => '123-456-789',
                                                  'req_uri' => '/images/]attach',
                                                  'uri' => '',
                                                  'message' => 'baz',
                                                  'service_id' => '' })
    end
  end
end
