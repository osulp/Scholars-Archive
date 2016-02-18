# app/models/generic_file.rb
class GenericFile < ActiveFedora::Base
  include Sufia::GenericFile
  include Hydra::AccessControls::Embargoable

  def self.property(name, options)
    super(name, {:class_name => TriplePoweredResource}.merge(options)) do |index|
      index.as :stored_searchable, :symbol
    end
  end 

  apply_schema ScholarsArchiveSchema,
    ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:stored_searchable, :symbol])
    )

  property :nested_authors, :predicate => ::RDF::URI("http://id.loc.gov/vocabulary/relators/aut"), :class_name => NestedAuthor

  accepts_nested_attributes_for :nested_authors, :allow_destroy => true, :reject_if => :all_blank

  def to_solr(solr_doc = {})
    super.tap do |doc|
      doc[ActiveFedora::SolrQueryBuilder.solr_name("nested_authors_label", :symbol)] = nested_authors.flat_map(&:name).select(&:present?)
      doc[ActiveFedora::SolrQueryBuilder.solr_name("nested_authors_label", :stored_searchable)] = nested_authors.flat_map(&:name).select(&:present?)
    end
  end

  def export_as_apa_citation
    text = ''
    authors_list = []
    authors_list_final = []

    authors = author_list

    authors.each do |author|
      next if author.blank?
      authors_list.push(abbreviate_name(author))
    end
    authors_list.each do |author|
      if author == authors_list.first # first
        authors_list_final.push(author.strip)
      elsif author == authors_list.last # last
        authors_list_final.push(", &amp; " + author.strip)
      else # all others
        authors_list_final.push(", " + author.strip)
      end
    end
    text << authors_list_final.join
    unless text.blank?
      if text[-1, 1] != "."
        text << ". "
      else
        text << " "
      end
    end
    # Get Pub Date
    text << "(" + setup_pub_date + "). " unless setup_pub_date.nil?
    title_info = setup_title_info
    text << "<i>" + title_info + "</i> " unless title_info.nil?

    # Publisher info
    text << setup_pub_info unless setup_pub_info.nil?
    text += "." if text[-1, 1] != "." unless text.blank?
    text.html_safe
  end

  def export_as_mla_citation
    text = ''
    authors_final = []

    # setup formatted author list
    authors = author_list

    if authors.length < 4
      authors.each do |author|
        if author == authors.first # first
          authors_final.push(author)
        elsif author == authors.last # last
          authors_final.push(", and " + name_reverse(author) + ".")
        else # all others
          authors_final.push(", " + name_reverse(author))
        end
      end
      text << authors_final.join
      unless text.blank?
        if text[-1, 1] != "."
          text << ". "
        else
          text << " "
        end
      end
    else
      text << authors.first + ", et al. "
    end
    # setup title
    title_info = setup_title_info
    text << "<i>" + mla_citation_title(title_info) + "</i> " unless title.blank?

    # Publication
    text << setup_pub_info + ", " unless setup_pub_info.nil?

    # Get Pub Date
    text << setup_pub_date unless setup_pub_date.nil?
    text << "." unless text.blank? if text[-1, 1] != "."
    text.html_safe
  end

  def export_as_chicago_citation
    author_text = ""
    authors = all_authors
    unless authors.blank?
      if authors.length > 10
        authors.each_with_index do |author, index|
          if index < 7
            if index == 0
              author_text << "#{author}"
              if author.ends_with?(",")
                author_text << " "
              else
                author_text << ", "
              end
            else
              author_text << "#{name_reverse(author)}, "
            end
          end
        end
        author_text << " et al."
      elsif authors.length > 1
        authors.each_with_index do |author, index|
          if index == 0
            author_text << "#{author}"
            if author.ends_with?(",")
              author_text << " "
            else
              author_text << ", "
            end
          elsif index + 1 == authors.length
            author_text << "and #{name_reverse(author)}."
          else
            author_text << "#{name_reverse(author)}, "
          end
        end
      else
        author_text << authors.first
      end
    end
    title_info = ""
    title_info << citation_title(clean_end_punctuation(CGI.escapeHTML(title.first)).strip) unless title.blank?

    pub_info = ""
    place = based_near.first
    publisher = self.publisher.first
    unless place.blank?
      place = CGI.escapeHTML(CGI.escapeHTML(is_triple_powered?(place) ? place.preferred_label : place))
      pub_info << place
      pub_info << ": " unless publisher.blank?
    end
    unless publisher.blank?
      publisher = CGI.escapeHTML(CGI.escapeHTML(is_triple_powered?(publisher) ? publisher.preferred_label : publisher))
      pub_info << publisher
      pub_info << ", " unless setup_pub_date.nil?
    end
    pub_info << setup_pub_date unless setup_pub_date.nil?

    citation = ""
    citation << "#{author_text} " unless author_text.blank?
    citation << "<i>#{title_info}.</i> " unless title_info.blank?
    citation << "#{pub_info}." unless pub_info.blank?
    citation.html_safe
  end

  def setup_pub_info
    text = ''
    place = based_near.first
    publisher = self.publisher.first
    unless place.blank?
      place = CGI.escapeHTML(CGI.escapeHTML(is_triple_powered?(place) ? place.preferred_label : place))
      text << place
      text << ": " unless publisher.blank?
    end
    unless publisher.blank?
      publisher = CGI.escapeHTML(CGI.escapeHTML(is_triple_powered?(publisher) ? publisher.preferred_label : publisher))
      text << publisher
    end
    return nil if text.strip.blank?
    clean_end_punctuation(text.strip)
  end

  def author_list
    creator.map do |author| 
        clean_end_punctuation(CGI.escapeHTML(is_triple_powered?(author) ? author.preferred_label : author)) 
    end.uniq
  end

  def is_triple_powered?(field_value)
    field_value.is_a?(TriplePoweredResource)
  end

  def clean_end_punctuation(text)
    if [".", ",", ":", ";", "/"].include? text[-1, 1]
      return text[0, text.length - 1]
    end
    text
  end

end
