
module Uwn
  module Api
    
    # 
    class Meaning

      attr_accessor :connect, :parent, :term, :language, :statements

      def initialize options={}
        self.connect = options[:connect] if options.include? :connect
        self.term = options[:term] if options.include? :term
        self.language = options[:language] if options.include? :language
        self.statements = []
        # self.statement = Statement.new parent: self
      end

      def has_meaning?
        !self.statements.empty?
      end

      def append_statement statement
        self.statements << Statement.new(parent: self, object: statement)
      end

      # short handeded methods


      def synsets
        self.statements.flat_map{ |s| s.synsets }
      end

      def synonyms
        self.statements.flat_map{ |s| s.synonyms }
      end

      def lexicalizations
        self.statements.flat_map{ |s| s.lexicalizations }
      end

      def glosses
        self.statements.flat_map{ |s| s.glosses }
      end

      def subclasses
        self.statements.flat_map{ |s| s.subclasses }
      end

      def lexical_categories
        self.statements.flat_map{ |s| s.lexical_categories }
      end



    end

  end
end