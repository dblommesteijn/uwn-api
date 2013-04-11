module Uwn
  module Api
    
    # Wrapper class for UWN Statement equivalent (with some abstracter function)
    class Statement

      attr_accessor :parent, :statements

      # Statement constructor
      def initialize options={}
        self.parent = options[:parent] if options.include? :parent
        @object = options[:object] if options.include? :object
        self.statements = []
        @parent_language = Util.parent_root(self).language
      end

      # term name as a string
      def term_str
        @object.get_object.get_term_str
      end

      # language of object
      def language
        @object.get_object.get_term_language
      end

      # word lexcat (noun, verb, adj etc.)
      def lexcat
        match = @object.get_object.to_s.match(/lexcat:([a-z]+)/)
        return match[1] unless match.nil?
        nil
      end

      # match current to the Meaning (root object) language
      def is_synonym?
        @object.get_object.get_term_language == @parent_language
      end

      # is the current object referenced to a synset?
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

      # object of object (raw object)
      def object
        @object.get_object
      end

      # predicate object (tells something about the object)
      def predicate
        @object.get_predicate
      end

      # weight of the link
      def weight
        @object.get_weight
      end

      def to_s
        @object.get_subject.to_s
      end

      # synset for current statement (not tested, depends on predicate!)
      def synset
        unless @object.nil?
          os = @object.get_object.to_s
          return os unless os.match(/([s][\/][n]){1}[0-9]+/).nil?
          su = @object.get_subject.to_s
          return su unless su.match(/([s][\/][n]){1}[0-9]+/).nil?
        end
      end

      # get filtered categories (word types ex. verb, noun) from synset
      def lexical_categories
        self.predicate_match "rel:lexical_category"
      end

      # get filtered lexicalizations (translations) from synset
      def lexicalizations
        self.predicate_match "rel:lexicalization"
      end

      # get filtered synonyms from synset
      def synonyms
        sts = self.predicate_match "rel:lexicalization"
        sts.reject{|t| !t.is_synonym? }
      end

      # get filtered subclasses from synset
      def subclasses
        self.predicate_match "rel:subclass"
      end

      # get filtered glosses from synset
      def glosses
        self.predicate_match "rel:has_gloss"
      end

      # get raw synsets
      def synsets
        self.predicate_match
      end

      protected

      # get predicates (with or without name filter)
      def predicate_match predicate_name = nil
        sts = self.lookup_synset self.synset
        sts.map!{|s| Statement.new(parent: self, object: s) }
        return sts.reject{|t| t.predicate.to_s != predicate_name} unless predicate_name.nil?
        sts
      end

      # get unique synsets from uwn
      def lookup_synset synset
        root = Util.parent_root self
        root.connect.statements(synset)
      end

    end

  end
end