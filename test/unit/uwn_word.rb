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

  def test_predicate_match_for_empty_synset
    meaning = @uwn.meaning("loot", "eng")
    begin
      meaning.synonyms
      meaning.synsets.each do |synset|
        assert synset.is_a?(Uwn::Api::Statement), "expected a statement"
      end
    rescue Exception => e
      assert false, "crashing on predicate_match"
    end
  end

  def test_behaviour_behavior
    # puts "-- running" 
    meaning = @uwn.meaning("CRM", "eng")
    # puts meaning.inspect
  end

  def test_unique_synsets
    meaning = @uwn.meaning("between", "eng")
    assert meaning.lexical_categories.map(&:lexcat).include? "adverb"
  end

end


