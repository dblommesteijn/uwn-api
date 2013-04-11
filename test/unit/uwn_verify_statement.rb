require 'rubygems'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/uwn/api")
require 'uri'

#
# Test the constructed tree for faults
#

class UwnVerifyStatement < Test::Unit::TestCase

  def setup
    @uwn = Uwn::Api::Connect.new
  end

  def teardown
  end

  def test_statement_contents
    # test object creation
    assert @uwn.is_a?(Uwn::Api::Connect), "expected Connect object"
    # query meaning for gem in English
    meaning = @uwn.meaning("gem", "eng")
    assert meaning.is_a?(Uwn::Api::Meaning), "expected Meaning object"
    assert meaning.statements.size == 7

    # iterate statements
    meaning.statements.each do |statement|
      assert statement.is_a?(Uwn::Api::Statement), "expected Statement object"
      # object
      assert statement.object.is_a?(Java::OrgLexvoUwn::Entity), "expected Java Entity"
      # subject
      assert statement.subject.is_a?(Java::OrgLexvoUwn::Entity), "expected Java Entity"
      subject_id = statement.subject.get_id
      assert subject_id.start_with?("t/")
      assert subject_id.include?(statement.subject.get_term_language)
      assert subject_id.include?(statement.subject.get_term_str)
      assert ::URI.parse(statement.subject.get_uri).is_a?(URI::Generic) unless statement.subject.get_uri.nil?
      # predicate
      assert statement.predicate.is_a?(Java::OrgLexvoUwn::Entity), "expected Java Entity"
      # weight
      assert statement.weight.is_a?(Float), "expected Float"
    end
  end
end