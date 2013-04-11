# Uwn::Api

This project is a Ruby on Rails (gem) wrapper for the UWN database (build from Wordnet), using JRuby (Java) and uwnapi.jar (which are included). Ruby MRI users will NOT be successful using this gem!!

 * UWN/MENTA: Towards a Universal Multilingual Wordnet API.
 * http://www.mpi-inf.mpg.de/yago-naga/uwn/downloads.html

## Installation

Add this line to your application's Gemfile (bundler):

    gem 'uwn-api', git: "git://github.com/dblommesteijn/uwn-api.git"

And then execute:

    $ bundle

Or install it yourself as (RubyGems):

    $ gem install uwn-api


## Roadmap

  * Version (0.0.2)

    Depth query on synset subclasses

    Depth search over multiple nodes


## Usage

### Download and install

Before using UWN you'll need to download Wordnet and UWN plugin libraries (http://www.mpi-inf.mpg.de/yago-naga/uwn/downloads.html) which are ~100Mb, and place it in the appropriate directory.

Place the uwn.dat/plg (and/or) wordnet.dat/plg into your plugins directory
  
    ~/yourgems/uwn-api/lib/uwn/api/deps/plugins (default directory)

OR Point Uwn::Api::Connect to the plugins path.

```ruby
uwn = Uwn::Api::Connect.new plugins_path: "/location/of/your/plugins"
```

### Connecting and word Query

```ruby
# connect to UWN and point the plugins dir
uwn = Uwn::Api::Connect.new plugins_path: "/location/of/your/plugins"
# perform query word gem in English
meaning = uwn.meaning "gem", "eng"
# iterate the found statements
meaning.statements.each do |statement|
  # print statement
  puts statement
end
```

### More advanced lists

Uwn::Api::Meaning includes shorthand methods that invocate, and flatten nested statement lists. Therefor meaning_instance.synsets are equivalent to meaning_instance.statments.flat_map{|s| s.synsets}.


#### Basic iteration example
```ruby
# connect to UWN and point the plugins dir
uwn = Uwn::Api::Connect.new plugins_path: "/location/of/your/plugins"
# perform query word gem in English
meaning = uwn.meaning "gem", "eng"

# iterate synsets (part of speech) on all nested statements
meaning.synsets.each do |synset|
  # print statement synset
  puts synset
end
```

#### Lexical Categories (word type: verb, noun etc.)

```ruby
# iterate lexical_categories (word type: verb, noun etc.)
meaning.lexical_categories.each do |lexical_category|
  # print statement lexical_category
  puts lexical_category
  # you can verify lexical_categories using:
  lexical_category.is_lexical_category?
  # word types can be retreived using:
  lexical_category.lexcat
end
```

#### Synonyms (based on synset word)

```ruby
# iterate synonyms (word synonyms based on synset)
meaning.synonyms.each do |synonym|
  # print statement synonym
  puts synonym
  # you can verify synonyms using:
  synonym.is_synonym?
  # word retreival can be done using:
  synonym.term_str
end
```

#### Lexicalizations (translations)

```ruby
# iterate lexicalizations (translations)
meaning.lexicalizations.each do |lexicalization|
  # print statement lexicalization
  puts lexicalization
  # word language
  lexicalization.language
  # word itself
  lexicalization.term_str
end
```

#### Subclasses (synset related classes)

```ruby
# iterate related classes
meaning.subclasses.each do |subclass|
  # the related subclass (synset id)
  subclass.to_s
  #TODO: do an in depth query on this synset is not yet supported!
end
```

#### Glossary (text explanation of word)

```ruby
meaning.glosses.each do |gloss|
  # print statement glossary
  puts gloss
end
```





