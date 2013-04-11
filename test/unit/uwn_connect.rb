require 'rubygems'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/uwn/api")


#
# Test the error handling from uwn
#

class UwnConnect < Test::Unit::TestCase

  def setup
  end

  def teardown
  end

  def test_default_options
    begin
      uwn = Uwn::Api::Connect.new
      assert true
    rescue Exception => e
      assert false, "should not get an exception"
    end
  end

  def test_correct_path_option
    begin
      uwn = Uwn::Api::Connect.new plugins_path: Uwn::Api::Connect::DEFAULT_PATH
      assert true
    rescue Exception => e
      assert false, "should not get an exception" 
    end
  end

  def test_incorrect_path_option
    begin
      uwn = Uwn::Api::Connect.new plugins_path: "/non/existing/path/to/plugins"
    rescue Exception => e
      assert e.message == "The plug-in directory '/non/existing/path/to/plugins' does not exist!"
    end
  end

  def test_word_present
    uwn = Uwn::Api::Connect.new
    assert uwn.is_a?(Uwn::Api::Connect), "expected Connect object"
    begin
      meaning = uwn.meaning("gem", "eng")
      assert true
    rescue Exception => e
      assert false, "word should be found"
    end
  end


end
