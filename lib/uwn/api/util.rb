module Uwn
  module Api
    
    class Util

      class << self

        def parent_root current_object
          current = current_object
          while true do
            break if current.parent.nil?
            current = current.parent
          end
          current
        end

      end

    end

  end
end
