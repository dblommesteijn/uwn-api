require 'rubygems'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/uwn/api")


#
# Test the constructed tree for faults
#

class UwnVerifyTree < Test::Unit::TestCase

  def setup
    @uwn = Uwn::Api::Connect.new
  end

  def teardown
  end

  def test_existing_word_language
    # test object creation
    assert @uwn.is_a?(Uwn::Api::Connect), "expected Connect object"
    # query meaning for gem in English
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.is_a?(Uwn::Api::Meaning), "expected Meaning object"
    # test nested objects    
    assert meaning.has_meaning?, "expected meaning to the query"
    meaning.statements.each do |statement|
      assert statement.is_a?(Uwn::Api::Statement), "expected Statement object"
    end
  end

  def test_non_existing_word_language
    meaning = @uwn.meaning("sakdfjlaksdjfl", "eng")
    assert !meaning.has_meaning?, "expected not to find word" 
  end

  def test_non_existing_language
    meaning = @uwn.meaning("test", "abc")
    assert !meaning.has_meaning?, "expected not to find word" 
  end

  def test_synsets
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.synsets.size == meaning.statements.flat_map{|s| s.synsets}.size
    assert meaning.synsets.size == 560
    # TODO: reduce duplicates (duplicate synsets are pointless, duplicate words are not)!
    assert meaning.synsets.uniq{|t| t.synset}.size == 35
    # iterate synsets
    meaning.synsets.each do |synset|
      assert synset.is_a?(Uwn::Api::Statement), "expected Statement object"
      assert synset.synset.is_a?(String), "expected a string"
      assert !synset.synset.match(/([s][\/][n]){1}[0-9]+/).nil?, "invalid synset token"
      assert synset.predicate.to_s.start_with?("rel:"), "expected rel: start"
      assert synset.has_synset?, "expected object has a synset"
    end
  end

  def test_lexical_categories
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.lexical_categories.size == meaning.statements.flat_map{ |s| s.lexical_categories }.size
    assert meaning.lexical_categories.size  == 7
    # iterate lexical categories
    meaning.lexical_categories.each do |lexical_category|
      assert lexical_category.is_a?(Uwn::Api::Statement), "expected Statement object"
      assert lexical_category.lexcat.is_a?(String), "expected String object"
      assert lexical_category.predicate.to_s == "rel:lexical_category"
      assert lexical_category.is_lexical_category?, "expected predicate lexical_category"
    end
  end

  def test_synonyms_depth_1
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.synonyms.size == meaning.statements.flat_map{ |s| s.synonyms }.size
    assert meaning.synonyms.size == 36
    # iterate synonyms
    meaning.synonyms.each do |synonym|
      assert synonym.is_a?(Uwn::Api::Statement), "expected Statement object"
      assert synonym.term_str.is_a?(String), "expected String object"
      assert synonym.predicate.to_s == "rel:lexicalization"
      assert synonym.object.to_s.start_with?("t/eng/"), "expected term eng"
      assert synonym.object.get_term_language == "eng", "expected eng"
      assert synonym.is_synonym?, "expected a synonym"
    end
  end

  def test_lexicalizations
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.lexicalizations.size == meaning.statements.flat_map{ |s| s.lexicalizations }.size
    assert meaning.lexicalizations.size == 505
    # TODO: reduce duplicates (duplicate synsets are pointless, 
    #       duplicate words are not, not sure if this works though)!
    assert meaning.lexicalizations.uniq{|l| l.subject}.size == 6
    meaning.lexicalizations.each do |lexicalization|
      assert lexicalization.is_a?(Uwn::Api::Statement), "expected Statement object"
      assert lexicalization.language.is_a?(String), "expected String object"
      #TODO: match to language list
      assert lexicalization.language.size == 3, "expected ISO 639-2"
      assert lexicalization.term_str.is_a?(String), "expected String object"
    end
  end

  def test_subclasses
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.subclasses.size == meaning.statements.flat_map{|s| s.subclasses}.size
    assert meaning.subclasses.size == 7
    # iterate subclasses
    meaning.subclasses.each do |subclass|
      assert subclass.is_a?(Uwn::Api::Statement), "expected Statement object"
      assert subclass.synset == subclass.object.to_s, "synset is in object"
      assert subclass.predicate.to_s == "rel:subclass", "rel:subclass"
      assert subclass.is_subclass?, "expected a subclass"
    end
  end

  def test_glosses
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.glosses.size == meaning.statements.flat_map{|s| s.glosses}.size
    assert meaning.glosses.size == 7
    # iterate glosses
    meaning.glosses.each do |gloss|
      assert gloss.is_a?(Uwn::Api::Statement), "expected Statement object"
      assert gloss.term_str.is_a?(String), "expected String object"
      assert gloss.term_str.split(/[\W]+/).size > 1, "expected some words"
    end
  end

  def test_predicate_match_for_empty_synset
    meaning = @uwn.meaning("loot", "eng")
    begin
      meaning.synsets.each do |synset|
        assert synset.is_a?(Uwn::Api::Statement), "expected a statement"
      end
    rescue Exception => e
      assert false, "crashing on predicate_match"
    end
  end

end
