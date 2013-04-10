require 'java'
require File.expand_path(File.dirname(__FILE__) + "/../deps/uwnapi.jar")


module Uwn
  module Api
      
    class Connect

      import 'org.lexvo.uwn.UWN'
      import 'org.lexvo.uwn.Entity'
      import 'org.lexvo.uwn.Statement'


      def initialize
        begin
          # setup plugin directory
          plugins = File.expand_path(File.dirname(__FILE__) + "/../deps/plugins")
          f = java.io.File.new(plugins.to_s)
          # load uwn
          @uwn = UWN.new(f)
        rescue Exception => e
          # hide java verbose output
          raise e.message
        end
      end

      def meaning term, language
        meaning = Meaning.new connect: self, term: term, language: language
        # get meaning entities
        mes = @uwn.get_meaning_entities term, language
        # iterate entities
        while mes.has_next do
          # append statment to meaning object
          meaning.statement << mes.next
        end
        meaning
      end


      def statements object_string
        ret = []
        mes = @uwn.get(Entity.new(object_string))
        while mes.has_next do
          ret << mes.next
        end
        ret 
      end

      
    end

  end
end
