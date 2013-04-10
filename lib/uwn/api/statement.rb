
module Uwn
  module Api
      
    class Statement

      attr_accessor :parent, :statements

      def initialize options={}
        self.parent = options[:parent] if options.include? :parent
        @object = options[:object] if options.include? :object
        self.statements = []
        @parent_language = Util.parent_root(self).language
      end

      def <<(statement)
        self.statements << Statement.new(parent: self, object: statement)
      end

      # term name as a string
      def term_str
        @object.get_object.to_s.gsub(/^([t][\/]#{@parent_language}[\/]){1}/, "")
      end

      # language of object
      def language
        match = @object.get_object.to_s.match(/[t][\/]([a-z]{3})[\/]{1}[\w]*/)
        return match[1] unless match.nil?
        nil
      end

      # subject object
      def subject
        @object.get_subject
      end

      # object of object
      def object
        @object.get_object
      end

      # predicate object
      def predicate
        @object.get_predicate
      end

      # weight object
      def weight
        @object.get_weight
      end

      # current synset (not tested, depends on predicate!)
      def synset
        unless @object.nil?
          os = @object.get_object.to_s
          return os unless os.match(/([s][\/][n]){1}[0-9]+/).nil?
          su = @object.get_subject.to_s
          return su unless su.match(/([s][\/][n]){1}[0-9]+/).nil?
        end
      end

      def lexical_categories
        self.predicate_match "rel:lexical_category"
      end

      def lexicalizations
        self.predicate_match "rel:lexicalization"
      end

      def synonyms
        sts = self.predicate_match "rel:lexicalization"
        sts.reject{|t| t.object.to_s.match(/[t][\/]#{@parent_language}[\/][\w]+/).nil? }
      end

      def subclasses
        self.predicate_match "rel:subclass"
      end

      def glosses
        self.predicate_match "rel:has_gloss"
      end

      def synsets
        self.lookup_synset self.synset
      end

      protected

      def predicate_match predicate_name
        sts = self.synsets
        sts.map!{|s| Statement.new(parent: self, object: s) }
        sts.reject{|t| t.predicate.to_s != predicate_name}
      end

      def lookup_synset synset
        root = Util.parent_root self
        root.connect.statements(synset)
      end

    end

  end
end