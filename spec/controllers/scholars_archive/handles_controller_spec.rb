require 'rails_helper'

RSpec.describe ScholarsArchive::HandlesController, type: :controller do
  let(:work) { Default.new(:title => ["blah"], :id => 'asdfasdf')}
  let(:fileset) { FileSet.new(:title => ["cat.jpg"], :id => 'qwerqwer') }

  context "#get handle_show" do
    context "when a work exists with the proper handle" do
      before do
        allow(controller).to receive(:find_work).and_return(work)
      end 
      it "Should reroute the user to the show page" do
        get :handle_show, params: {:handle_id => "1957", :id => "12345"}
        expect(response).to redirect_to '/concern/' + work.class.to_s.downcase.pluralize + '/' + work.id
      end
    end
    context "when a work doesnt exist with the proper handle" do
      before do
        allow(controller).to receive(:find_work).and_return(nil)
      end
      it "Should reroute the user to work not found error page" do
        get :handle_show, params: {:handle_id => "1957", :id => "12345"}
        expect(response).to redirect_to '/404/work_not_found'
      end
    end
  end
  context "#get handle_download" do
    context "when a work and its file set exists" do
      before do
        allow(controller).to receive(:find_work).and_return(work)
        allow(controller).to receive(:filesets_for_work).and_return([fileset])
      end 
      it "Should reroute the user to the download link" do
        get :handle_download, params: {:handle_id => "1957", :id => "12345", :file => "cat.jpg"}
        expect(response).to redirect_to '/downloads/' + fileset.id
      end
    end
    context "when a work does not exist with the proper handle" do
      before do
        allow(controller).to receive(:find_work).and_return(nil)
      end 
      it "Should reroute the user to the work not found page" do
        get :handle_download, params: {:handle_id => "1957", :id => "12345", :file => "cat.jpg"}
        expect(response).to redirect_to '/404/work_not_found'
      end
    end
    context "when a work exists but it doesnt have the right file" do
      before do
        allow(controller).to receive(:find_work).and_return(work)
        allow(controller).to receive(:filesets_for_work).and_return([])
      end 
      it "Should reroute the user to 404 file not found page" do
        get :handle_download, params: {:handle_id => "1957", :id => "12345", :file => "catasdf"}
        expect(response).to redirect_to '/404/file_not_found/1957/12345/catasdf'
      end
    end
    context "when a work exists and returns too many file matches" do
      before do
        allow(controller).to receive(:find_work).and_return(work)
        allow(controller).to receive(:filesets_for_work).and_return([fileset, fileset])
      end 
      it "Should reroute the user to the show page" do
        get :handle_download, params: {:handle_id => "1957", :id => "12345", :file => "cat.jpg"}
        expect(response).to redirect_to '/concern/' + work.class.to_s.downcase.pluralize + '/' + work.id
      end
    end
  end
end
