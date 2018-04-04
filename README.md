# Dependencytree

Parses ruby source codes and tries to build a dependency tree from the seen classes, modules and references.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dependencytree'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dependencytree

## Usage

Use the program in the shell and give it all ruby sources or folders containing ruby sources.

        ruby -Ilib lib/dependencytree.rb lib

The output will be a JSON of the references:
```
[
   {
      "uuid" : "738bed4c-f320-47c4-999f-f8a931531ea9",
      "unresolved_refs" : [],
      "name" : "Kernel",
      "constants" : [],
      "resolved_refs" : [],
      "methods" : [],
      "type" : "module",
      "refs" : [],
      "path" : null,
      "full_name" : "Kernel"
   },
   {
      "full_name" : "Dependencytree",
      "type" : "module",
      "refs" : [
         [
            "File"
         ],
         [
            "Dir"
         ],
         [
            "Parser",
            "CurrentRuby"
         ],
         [
            "Logger"
         ],
         [
            "Regexp"
         ],
         [
            "OptionParser"
         ],
         [
            "DependencyAggregator"
         ],
         [
            "ARGV"
         ],
         [
            "ClassContainer"
         ]
      ],
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "resolved_refs" : [
         "d8f6667b-cc22-4575-b39c-ff16ba53d5c6",
         "4eaca801-dd61-476a-b58f-fb89bd6b9c00",
         "2d8b1a14-720b-492b-8e32-c0212d2e369f"
      ],
      "methods" : [],
      "uuid" : "d8f6667b-cc22-4575-b39c-ff16ba53d5c6",
      "unresolved_refs" : [
         [
            "Parser",
            "CurrentRuby"
         ]
      ],
      "constants" : [
         "VERSION"
      ],
      "name" : "Dependencytree"
   },
   {
      "unresolved_refs" : [],
      "constants" : [],
      "name" : "ClassContainer",
      "uuid" : "2d8b1a14-720b-492b-8e32-c0212d2e369f",
      "resolved_refs" : [],
      "parent_uuid" : "d8f6667b-cc22-4575-b39c-ff16ba53d5c6",
      "methods" : [
         "initialize",
         "resolve_references",
         "resolve_reference",
         "resolve_reference_as_constant",
         "resolve_reference_direct",
         "resolve_by_full_name",
         "resolve_by_name"
      ],
      "refs" : [],
      "type" : "class",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "full_name" : "Dependencytree::ClassContainer"
   },
   {
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/astprinter.rb",
      "type" : "class",
      "refs" : [],
      "full_name" : "Dependencytree::ASTPrinter",
      "uuid" : "273adc92-0f70-4ef4-934d-d622b88a2472",
      "unresolved_refs" : [],
      "name" : "ASTPrinter",
      "constants" : [],
      "parent_uuid" : "d8f6667b-cc22-4575-b39c-ff16ba53d5c6",
      "methods" : [
         "initialize",
         "visit"
      ],
      "resolved_refs" : []
   },
   {
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classmodel.rb",
      "type" : "class",
      "refs" : [
         [
            "SecureRandom"
         ],
         [
            "ArgumentError"
         ]
      ],
      "full_name" : "Dependencytree::ClassModel",
      "uuid" : "79977b8e-621e-40bf-a62f-63d68d72cf2e",
      "unresolved_refs" : [
         [
            "SecureRandom"
         ],
         [
            "ArgumentError"
         ]
      ],
      "constants" : [],
      "name" : "ClassModel",
      "methods" : [
         "initialize",
         "full_name_array",
         "full_name",
         "set_parent",
         "as_json",
         "to_json",
         "add_method",
         "add_constant",
         "add_reference"
      ],
      "parent_uuid" : "d8f6667b-cc22-4575-b39c-ff16ba53d5c6",
      "resolved_refs" : []
   },
   {
      "full_name" : "Dependencytree::DependencyAggregator",
      "refs" : [
         [
            "ArgumentError"
         ],
         [
            "ClassModel"
         ],
         [
            "Exception"
         ]
      ],
      "type" : "class",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/dependencyaggregator.rb",
      "resolved_refs" : [
         "79977b8e-621e-40bf-a62f-63d68d72cf2e"
      ],
      "methods" : [
         "initialize",
         "top_of_stack",
         "to_json",
         "flatten_const_tree",
         "_resolve",
         "_const",
         "_module",
         "_class",
         "_handle_class_module_common",
         "_def",
         "_casgn",
         "visit_node",
         "visit_children",
         "visit"
      ],
      "parent_uuid" : "d8f6667b-cc22-4575-b39c-ff16ba53d5c6",
      "unresolved_refs" : [
         [
            "ArgumentError"
         ],
         [
            "Exception"
         ]
      ],
      "constants" : [],
      "name" : "DependencyAggregator",
      "uuid" : "4eaca801-dd61-476a-b58f-fb89bd6b9c00"
   }
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dependencytree.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
