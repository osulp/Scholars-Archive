# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'
RSpec.describe ScholarsArchive::Actors::NestedFieldsOperationsActor do
  let(:curation_concern) do
      Default.new do |work|
        work.attributes = attributes
      end
  end
  let(:user) do
    User.new(email: 'test@example.com', guest: false)
  end
  let(:ability) { double(current_user: user) }
  let(:env) { Hyrax::Actors::Environment.new(curation_concern, ability, attributes) }
  let(:terminator) { Hyrax::Actors::Terminator.new }
  let(:attributes) {
        {
            title: ['test'],
            creator: ['Blah'],
            rights_statement: ['blah.blah'],
            resource_type: ['blah'],
        }
      }
  let(:nested_geo_attributes) {
    {
        '2' => {
            'id'=>'http://127.0.0.1:8984/rest/dev/pz/50/gw/08/pz50gw084#nested_geog70269864184480',
            '_destroy'=>'false',
            'bbox_lat_north'=>'1',
            'bbox_lon_west'=>'2',
            'bbox_lat_south'=>'3',
            'bbox_lon_east'=>'4',
            'label'=>'test bbox1',
            'bbox'=>''
        },
        '4' => {
            'id'=>'http://127.0.0.1:8984/rest/dev/pz/50/gw/08/pz50gw084#nested_geog70269621263140',
            '_destroy'=>'false',
            'point_lat'=>'a',
            'point_lon'=>'b',
            'label'=>'test point1',
            'point'=>''
        }
    }
  }
  let(:expected_point) { 'a,b' }
  let(:expected_bbox) { '1,2,3,4' }

  subject(:middleware) do
    stack = ActionDispatch::MiddlewareStack.new.tap do |middleware|
      middleware.use described_class
    end
    stack.build(terminator)
  end

  describe '#create' do
    context 'with nested geo attributes' do
      before do
        allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other]])
        allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([%w[Other Other]])
        allow(user).to receive(:admin?).and_return(true)
        allow(terminator).to receive(:create).with(Hyrax::Actors::Environment).and_return(true)
        env.attributes['nested_geo_attributes'] = nested_geo_attributes
      end
      it 'sets the point from user input' do
        expect(subject.create(env)).to be true
        expect(env.attributes['nested_geo_attributes']['2']['bbox']).to eq expected_bbox
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lat_north']).to be nil
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lon_west']).to be nil
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lat_south']).to be nil
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lon_east']).to be nil

        expect(env.attributes['nested_geo_attributes']['4']['point']).to eq expected_point
        expect(env.attributes['nested_geo_attributes']['4']['point_lat']).to be nil
        expect(env.attributes['nested_geo_attributes']['4']['point_lon']).to be nil
      end
    end
  end

  describe '#update' do
    context 'with nested geo attributes' do
      before do
        allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_all_options).and_return([%w[Other Other]])
        allow_any_instance_of(ScholarsArchive::DegreeFieldService).to receive(:select_sorted_current_options).and_return([%w[Other Other]])
        allow(user).to receive(:admin?).and_return(true)
        allow(terminator).to receive(:update).with(Hyrax::Actors::Environment).and_return(true)
        env.attributes['nested_geo_attributes'] = nested_geo_attributes
      end
      it 'sets the box from user input' do
        expect(subject.update(env)).to be true
        expect(env.attributes['nested_geo_attributes']['2']['bbox']).to eq expected_bbox
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lat_north']).to be nil
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lon_west']).to be nil
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lat_south']).to be nil
        expect(env.attributes['nested_geo_attributes']['2']['bbox_lon_east']).to be nil

        expect(env.attributes['nested_geo_attributes']['4']['point']).to eq expected_point
        expect(env.attributes['nested_geo_attributes']['4']['point_lat']).to be nil
        expect(env.attributes['nested_geo_attributes']['4']['point_lon']).to be nil
      end
    end
  end
end
