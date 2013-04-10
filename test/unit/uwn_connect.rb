require 'rubygems'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/uwn/api")


class UwnConnect < Test::Unit::TestCase


  def setup
    @uwn = Uwn::Api::Connect.new
  end

  def teardown
  end

  def test_connection_uwn_offline
    # test object creation
    assert @uwn.is_a?(Uwn::Api::Connect), "expected Connect object"
    # query meaning for gem in English
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.is_a?(Uwn::Api::Meaning), "expected Meaning object"

    # test nested objects    
    assert meaning.statement.is_a?(Uwn::Api::Statement), "expected Statement object"
    meaning.statement.statements.each do |statement|
      assert statement.is_a?(Uwn::Api::Statement), "expected Statement object"
    end

    # collecting synonyms (synsets depth = 1)
    # assert meaning.synonyms.map{|t| t.term_str }.uniq == []

    # list glossary
    # puts meaning.glosses.map{|t| t.term_str }

    # list translations
    # puts meaning.lexicalizations.map{|t| t.language }

    # list related synsets
    # puts meaning.subclasses.map{|t| t.object.to_s }

  end

  def test_connection_uwn_online
  end


  def test_connect_subject_uris
  end


end
