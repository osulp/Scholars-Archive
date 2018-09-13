require 'rails_helper'

RSpec.describe SolrDocument do
  describe "#academic_affiliation_label" do
    context "when an academic_affiliation_label is indexed" do
      document = described_class.new({
                                        "academic_affiliation_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.academic_affiliation_label).to eq [{"label"=>"label1", "uri"=>"www.blah.com"}]
      end
    end
  end

  describe "#other_affiliation_label" do
    context "when an other_affiliation_label is indexed" do
      document = described_class.new({
                                        "other_affiliation_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.other_affiliation_label).to eq [{"label"=>"label1", "uri"=>"www.blah.com"}]
      end
    end
  end

  describe "#degree_grantors_label" do
    context "when degree_grantors_label is indexed" do
      document = described_class.new({
                                        "degree_grantors_label_ssim" => ["label1$www.blah.com"]
                                     })
      it "should return the label" do
        expect(document.degree_grantors_label).to eq [{"label"=>"label1", "uri"=>"www.blah.com"}]
      end
    end
  end

  describe "#nested_geo" do
    context "when there are no geo points" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_geo_label_ssim" => []
                                       })
        expect(document.nested_geo).to eq []
      end
    end
    context "when there are geo coordinates" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_geo_label_ssim" => ["Test"]
                                       })
        expect(document.nested_geo).to eq ["Test"]
      end
    end
  end

  describe "#nested_related_items" do
    context "when there are no related items" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_related_items_label_ssim" => []
                                       })
        expect(document.nested_related_items_label).to eq []
      end
    end
    context "when there are related items" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_related_items_label_ssim" => ["label1$www.blah.com$0"]
                                       })
        expect(document.nested_related_items_label).to eq [{'label'=>'label1', 'uri'=>'www.blah.com', 'index'=>'0'}]
      end
    end
  end

  describe "#nested_ordered_creator" do
    context "when there are no ordered creators" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_ordered_creator_label_ssim" => []
                                       })
        expect(document.nested_ordered_creator_label).to eq []
      end
    end
    context "when there are ordered creators" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_ordered_creator_label_ssim" => ["creator1$0"]
                                       })
        expect(document.nested_ordered_creator_label).to eq ['creator1']
      end
    end
  end

  describe "#title" do
    context "when there are no core metadata titles and no ordered titles" do
      it "should return an empty array" do
        document = described_class.new({
                                           "title_tesim" => []
                                       })
        expect(document.title).to eq []
      end
    end
    context "when there are only ordered titles" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_ordered_title_label_ssim" => ["title3$0", 'title4$1']
                                       })
        expect(document.title).to eq ['title3', 'title4']
      end
    end
    context "when there are only core metadata titles" do
      it "should return their labels" do
        document = described_class.new({
                                           "title_tesim" => ['title2','title1']
                                       })
        expect(document.title).to eq ['title2', 'title1']
      end
    end
    context "when there are both core metadata titles and ordered titles" do
      it "should return their labels" do
        document = described_class.new({
                                           "title_tesim" => ['title1','title2'],
                                           "nested_ordered_title_label_ssim" => ["title3$0", 'title4$1'],
                                       })
        expect(document.title).to eq ['title3', 'title4']
      end
    end
  end

  describe "#creator" do
    context "when there are no core metadata creators and no ordered creators" do
      it "should return an empty array" do
        document = described_class.new({
                                           "creator_tesim" => []
                                       })
        expect(document.creator).to eq []
      end
    end
    context "when there are only ordered creators" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_ordered_creator_label_ssim" => ["creatorA$0", 'creatorB$1']
                                       })
        expect(document.creator).to eq ['creatorA', 'creatorB']
      end
    end
    context "when there are only core metadata creators" do
      it "should return their labels" do
        document = described_class.new({
                                           "creator_tesim" => ['creatorB','creatorA']
                                       })
        expect(document.creator).to eq ['creatorB', 'creatorA']
      end
    end
    context "when there are both core metadata creators and ordered creators" do
      it "should return their labels" do
        document = described_class.new({
                                           "creator_tesim" => ['creatorA','creatorB'],
                                           "nested_ordered_creator_label_ssim" => ["creatorC$0", 'creatorD$1'],
                                       })
        expect(document.creator).to eq ['creatorC', 'creatorD']
      end
    end
  end

  describe "#nested_ordered_title" do
    context "when there are no ordered titles" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_ordered_title_label_ssim" => []
                                       })
        expect(document.nested_ordered_title_label).to eq []
      end
    end
    context "when there are ordered titles" do
      it "should return their labels" do
        document = described_class.new({
                                           "nested_ordered_title_label_ssim" => ["title1$0"]
                                       })
        expect(document.nested_ordered_title_label).to eq ['title1']
      end
    end
  end

  describe "#oai_nested_related_items_label" do
    context "when there are no related items" do
      it "should return an empty array" do
        document = described_class.new({
                                           "nested_related_items_label_ssim" => []
                                       })
        expect(document.oai_nested_related_items_label).to eq []
      end
    end
    context "when there are related items" do
      it "should return their labels and uris as array" do
        document = described_class.new({
                                           "nested_related_items_label_ssim" => ["label1$www.blah.com", "label3$www.example.org"]
                                       })
        expect(document.oai_nested_related_items_label).to eq ['label1: www.blah.com', 'label3: www.example.org']
      end
    end
  end

  describe "#oai_academic_affiliation_label" do
    context "when there are no related items" do
      it "should return an empty array" do
        document = described_class.new({
                                           "academic_affiliation_label_ssim" => []
                                       })
        expect(document.oai_academic_affiliation_label).to eq []
      end
    end
    context "when there are academic affiliations" do
      it "should return their labels" do
        document = described_class.new({
                                           "academic_affiliation_label_ssim" => ["Technical Journalism$http://opaquenamespace.org/ns/osuAcademicUnits/DhPwxzf1", "Aerospace Studies$http://opaquenamespace.org/ns/osuAcademicUnits/Rn0bhPiY"]
                                       })
        expect(document.oai_academic_affiliation_label).to eq ["Technical Journalism", "Aerospace Studies"]
      end
    end
  end

  describe "#oai_other_affiliation_label" do
    context "when there are no related items" do
      it "should return an empty array" do
        document = described_class.new({
                                           "other_affiliation_label_ssim" => []
                                       })
        expect(document.oai_other_affiliation_label).to eq []
      end
    end
    context "when there are other (non-academic) affiliations" do
      it "should return their labels" do
        document = described_class.new({
                                           "other_affiliation_label_ssim" => ["OSU Press$http://id.loc.gov/authorities/names/n82039655", "Honors College$http://opaquenamespace.org/ns/subject/OregonStateUniversityHonorsCollege"]
                                       })
        expect(document.oai_other_affiliation_label).to eq ["OSU Press", "Honors College"]
      end
    end
  end

  describe "#oai_rights" do
    context "when there is only a Rights Statement" do
      it "should return the Rights Statement label" do
        document = described_class.new({
                                           "rights_statement_label_ssim" => ["In Copyright - Educational Use Permitted"]
                                       })
        expect(document.oai_rights).to eq ["In Copyright - Educational Use Permitted"]
      end
    end
    context "when there is only a License" do
      it "should return the License label" do
        document = described_class.new({
                                           "license_label_ssim" => ["CC0 1.0 Universal"]
                                       })
        expect(document.oai_rights).to eq ["CC0 1.0 Universal"]
      end
    end
    context "when there is both a Rights Statement and a License" do
      it "should return only the License label" do
        document = described_class.new({
                                           "rights_statement_label_ssim" => ["In Copyright - Educational Use Permitted"],
                                           "license_label_ssim" => ["CC0 1.0 Universal"]
                                       })
        expect(document.oai_rights).to eq ["CC0 1.0 Universal"]
      end
    end
  end

  describe "#oai_identifier" do
    context "when there is an item" do
      it "should return the web identifier for OAI use" do
        document = described_class.new({
                                           "has_model_ssim" => ['Default'],
                                           "id" => ['xw42n789j']
                                       })
        expect(document.oai_identifier).to eq 'http://ir.library.oregonstate.edu/concern/defaults/xw42n789j'
      end
    end
  end





end
