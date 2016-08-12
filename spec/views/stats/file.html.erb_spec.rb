# This test is named zzz_* because it contains hidden side-effects that affect subsequent
# test execution.  Specifically, the stub_model and render calls together.
# See: https://github.com/projecthydra/sufia/pull/1932
require 'spec_helper'
require 'rails_helper'
#
describe 'stats/file.html.erb', type: :view do
  describe 'usage statistics' do
    before :each do
      allow_message_expectations_on_nil
      assign(:stats, stats)
      allow(controller).to receive(:current_ability).and_return(ability)
      allow(view).to receive(:present_about_stats_block).and_return(about_stats_text)
      allow(view).to receive(:present_about_stats_graph_block).and_return(about_stats_text)
      allow(view).to receive(:present_about_stats_overview_block).and_return(about_stats_text)
      allow(view).to receive(:present_about_stats_table_block).and_return(about_stats_text)
      allow(view).to receive(:present).and_yield(about_stats_text)
      allow(ability).to receive(:can?).with(:update, ContentBlock).and_return(can_update_content_block)
      stub_template "_page_view_download_table.html.erb" => "This content"
    end

    # let(:can_update_content_block) { true }
    let(:groups) { [] }
    let(:ability) { instance_double("Ability") }
    let(:about_stats_value) { "I have info about the stats page!" }
    let(:about_stats_text) { ContentBlock.new(name: "about_stats_text", value: about_stats_value) }

    let(:no_stats) {
      double('FileUsage',
             created: Date.parse('2014-01-01'),
             total_pageviews: 0,
             total_downloads: 0,
             to_flot: [])
    }

    let(:stats) {
      double('FileUsage',
             created: Date.parse('2014-01-01'),
             total_pageviews: 9,
             total_downloads: 4,
             to_flot: [[1_396_422_000_000, 2], [1_396_508_400_000, 3], [1_396_594_800_000, 4]])
    }


    context "when there is content for the about stats page" do
      before do
        render
      end

      let(:about_stats_value) { "I have info about the stats page!" }

      context "when the user can update content" do
        let(:can_update_content_block) { true }

        it "finds content about value" do 
          page = Capybara::Node::Simple.new(rendered)
          expect(page).to have_content about_stats_value
        end
        it "finds edit" do
          page = Capybara::Node::Simple.new(rendered)
          expect(page).to have_button('Edit')
        end

      end

      context "when the user can't update content" do
        let(:can_update_content_block) { false }

        it "finds content about value" do 
          page = Capybara::Node::Simple.new(rendered)
          expect(page).to have_content about_stats_value
        end
        it "finds edit" do
          page = Capybara::Node::Simple.new(rendered)
          expect(page).not_to have_button('Edit')
        end
      end
    end

    context "when there is no content for the about stats page" do
      before do
        render
      end

      let(:about_stats_value) { "" }

      context "when the user can update content" do
        let(:can_update_content_block) { true }
        it "finds about_stats_text" do 
          page = Capybara::Node::Simple.new(rendered)
          expect(page).to have_selector('#about_stats_text')
        end
        it "finds edit" do
          page = Capybara::Node::Simple.new(rendered)
          expect(page).to have_button('Edit')
        end
      end

      context "when the user can't update content" do
        let(:can_update_content_block) { false }
        it "doesn't find about_stats_text" do 
          page = Capybara::Node::Simple.new(rendered)
          expect(page).not_to have_selector('#about_stats_text')
        end
      end
    end

  end
end
