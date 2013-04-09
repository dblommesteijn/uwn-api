require 'rubygems'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../../lib/uwn/api")


class UwnConnect < Test::Unit::TestCase

  def setup
    @uwn_connect = Uwn::Api::Connect.new
  end

  def teardown
  end

  def test_connection_uwn_offline
    it = @uwn_connect.uwn.get_meaning_entities("muscular", "eng")

    puts @uwn_connect.uwn.inspect
    @uwn_connect.uwn

    while it.has_next do

      puts "------------------"
      meaningStatement = it.next

      puts meaningStatement.inspect

      subject = meaningStatement.get_subject
      predicate = meaningStatement.get_predicate
      weight = meaningStatement.get_weight
      predicate_id = predicate.get_id

      puts subject
      puts predicate
      puts weight


    end
  end

  def test_connection_uwn_online
  end


  def test_connect_subject_uris
  end


end
