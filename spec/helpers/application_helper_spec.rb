require "spec_helper"
require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#present_about_stats_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_stats_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_stats_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_stats_table_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_stats_table_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_stats_table_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_stats_graph_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_stats_graph_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_stats_graph_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_stats_overview_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_stats_overview_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_stats_overview_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_work_stats_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_work_stats_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_work_stats_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_work_stats_table_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_work_stats_table_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_work_stats_table_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_work_stats_graph_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_work_stats_graph_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_work_stats_graph_block). to eq(about_stats_block)
    end
  end
  describe "#present_about_work_stats_overview_block" do
    let(:about_stats_block) { ContentBlock.find_or_create_by(name: "about_work_stats_overview_text") }
    it "returns ContentBlock for about stats text" do
      expect(helper.present_about_work_stats_overview_block). to eq(about_stats_block)
    end
  end


end
