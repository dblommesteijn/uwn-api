
module Uwn
  module Api
      
    class Meaning

      attr_accessor :connect, :parent, :term, :language, :statement

      def initialize options={}
        self.connect = options[:connect] if options.include? :connect
        self.term = options[:term] if options.include? :term
        self.language = options[:language] if options.include? :language
        self.statement = Statement.new parent: self
      end

      def synsets
        self.statement.statements.map{|s| s.synset }
      end

      def synonyms
        self.statement.statements.flat_map{|s| s.synonyms }
      end

      def lexicalizations
        self.statement.statements.flat_map{|s| s.lexicalizations }
      end

      def glosses
        self.statement.statements.flat_map{|s| s.glosses }
      end

      def subclasses
        self.statement.statements.flat_map{|s| s.subclasses }
      end


    end

  end
end