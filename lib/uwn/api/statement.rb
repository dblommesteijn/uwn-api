
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

      # term name as a string
      def term_str
        #@object.get_object.to_s.gsub(/^([t][\/]#{@parent_language}[\/]){1}/, "")
        @object.get_object.get_term_str #to_s.gsub(/^([t][\/][a-z]{3}[\/]){1}/, "")
      end

      # language of object
      def language
        @object.get_object.get_term_language
        # match = @object.get_object.get_term_language #to_s.match(/[t][\/]([a-z]{3})[\/]{1}[\w]*/)
        # return match[1] unless match.nil?
        # nil
      end

      # word lexcat (noun, verb, adj etc.)
      def lexcat
        match = @object.get_object.to_s.match(/lexcat:([a-z]+)/)
        return match[1] unless match.nil?
        nil
      end

      def is_synonym?
        @object.get_object.get_term_language == @parent_language #.to_s.match(/[t][\/]#{@parent_language}[\/][\w]+/).nil?
      end

      def has_synset?
        self.synset.is_a? String
      end

      def is_lexical_category?
        @object.get_predicate.to_s == "rel:lexical_category"
      end

      def is_subclass?
        @object.get_predicate.to_s == "rel:subclass"
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
        sts.reject{|t| !t.is_synonym? }
      end

      def subclasses
        self.predicate_match "rel:subclass"
      end

      def glosses
        self.predicate_match "rel:has_gloss"
      end

      def synsets
        self.predicate_match
      end

      protected

      def predicate_match predicate_name = nil
        sts = self.lookup_synset self.synset
        sts.map!{|s| Statement.new(parent: self, object: s) }
        return sts.reject{|t| t.predicate.to_s != predicate_name} unless predicate_name.nil?
        sts
      end

      def lookup_synset synset
        root = Util.parent_root self
        root.connect.statements(synset)
      end

    end

  end
end