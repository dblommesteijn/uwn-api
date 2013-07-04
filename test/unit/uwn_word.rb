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

  def test_adverbs
    words = ["above", "along", "below", "beside", "between", "during", "for", "from", "in", "near", "on", "outside", "over", "past", "through", "towards", "under", "up", "with"]
    words.each do |word|
      meaning = @uwn.meaning(word, "eng")
      # skip unable to find
      if meaning.statements.size <= 0
        puts "word: #{word}"
        next
      end
      assert meaning.lexical_categories.map(&:lexcat).include?("adverb"), "word: `#{word}` not an adverb"
    end
  end

  def test_verbs
    words = ["go", "do"]
    words.each do |word|
      meaning = @uwn.meaning(word, "eng")
      assert meaning.lexical_categories.map(&:lexcat).include?("verb"), "word: `#{word}` not a verb"
    end
  end



end


