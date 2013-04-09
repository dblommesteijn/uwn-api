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

      def uwn
        @uwn
      end

    end

  end
end
