require 'java'
require File.expand_path(File.dirname(__FILE__) + "/../deps/uwnapi.jar")


module Uwn
  module Api
      
    class Connect

      DEFAULT_PATH = File.dirname(__FILE__) + "/../deps/plugins"

      import 'org.lexvo.uwn.UWN'
      import 'org.lexvo.uwn.Entity'
      import 'org.lexvo.uwn.Statement'


      def initialize options={}
        begin
          # setup plugin directory
          unless options.include? :plugins_path
            plugins_path = DEFAULT_PATH
          else
            plugins_path = options[:plugins_path]
          end
          f = java.io.File.new(plugins_path.to_s)
          # load uwn
          @uwn = UWN.new(f)
        rescue Exception => e
          # hide java verbose output
          raise e.message
        end
      end

      # lookup meaning of term by name and language
      def meaning term, language
        meaning = Meaning.new connect: self, term: term, language: language
        # get meaning entities
        mes = @uwn.get_meaning_entities term, language
        # iterate entities
        while mes.has_next do
          # append statment to meaning object
          meaning.append_statement mes.next
        end
        meaning
      end

      # get statements by direct uwn query
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
