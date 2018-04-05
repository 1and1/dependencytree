# Dependencytree

Parses ruby source codes and tries to build a dependency tree from the seen classes, modules and references.
The output is a JSON file that contains all modules/classes along with their references.

The references can be used to build a dependency tree for your project.

## Installation

Get the latest release gem from https://github.com/1and1/dependencytree/releases

Install it yourself as:

    $ gem install dependencytree-0.1.1.gem

## Usage

Use the program in the shell and give it all ruby sources or folders containing ruby sources.

        dependencytree ./lib

The output will be a JSON of the references. The interesting parts are:
* **uuid**: Every class/module has a unique UUID for referencing. The UUID will stay unique only for one parsing run.
* **resolved_refs**: Resolved / found references that are pointing to the UUID of the refered class.
* **unresolved_refs**: Unresolved references that could not be found inside the sources provided.
  This can be Ruby classes or other classes from gems that were not scanned.
  The unresolved_refs entries are arrays of the name parts, for example `[ "moduleA", "mobuleB", "classC" ]`
* **methods**: List of seen method names.
* **constants**: List of seen constant names.
* **path**: Filesystem path of the first source file with a class/module definition.
* **type**: `"module"` or `"class"`.
* **refs**: An array of all references (resolvable and unresolvable) in array notation (see above).
* **name**: The local module/class name, for example `"Stat"`.
* **full_name**: The full name of the module/class, for example `"File::Stat"`.

The following is the example for the dependency tree tool itself:

```
[
   {
      "methods" : [],
      "resolved_refs" : [],
      "uuid" : "ace12917-bafd-4be5-b63b-c63be9f8acbf",
      "type" : "module",
      "full_name" : "Kernel",
      "path" : null,
      "name" : "Kernel",
      "unresolved_refs" : [],
      "refs" : [],
      "constants" : []
   },
   {
      "unresolved_refs" : [
         [
            "Parser",
            "CurrentRuby"
         ]
      ],
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
      "constants" : [
         "VERSION"
      ],
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "name" : "Dependencytree",
      "resolved_refs" : [
         "c185c2ea-b26c-4b2b-be39-42222bfb8cf3",
         "2cf6eb45-274f-43b5-85ff-8a3c6713e6a0",
         "d454f744-86c4-4ddb-ad5f-d0484a181b35"
      ],
      "methods" : [],
      "uuid" : "c185c2ea-b26c-4b2b-be39-42222bfb8cf3",
      "type" : "module",
      "full_name" : "Dependencytree"
   },
   {
      "parent_uuid" : "c185c2ea-b26c-4b2b-be39-42222bfb8cf3",
      "type" : "class",
      "full_name" : "Dependencytree::ClassContainer",
      "methods" : [
         "initialize",
         "resolve_references",
         "resolve_reference",
         "resolve_reference_as_constant",
         "resolve_reference_direct",
         "resolve_by_full_name",
         "resolve_by_name"
      ],
      "resolved_refs" : [],
      "uuid" : "d454f744-86c4-4ddb-ad5f-d0484a181b35",
      "name" : "ClassContainer",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "constants" : [],
      "refs" : [],
      "unresolved_refs" : []
   },
   {
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classmodel.rb",
      "name" : "ClassModel",
      "resolved_refs" : [],
      "uuid" : "2fab2d8d-44db-49f1-bfa0-7cd795e9488b",
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
      "parent_uuid" : "c185c2ea-b26c-4b2b-be39-42222bfb8cf3",
      "full_name" : "Dependencytree::ClassModel",
      "type" : "class",
      "refs" : [
         [
            "SecureRandom"
         ],
         [
            "ArgumentError"
         ]
      ],
      "unresolved_refs" : [
         [
            "SecureRandom"
         ],
         [
            "ArgumentError"
         ]
      ],
      "constants" : []
   },
   {
      "type" : "class",
      "parent_uuid" : "c185c2ea-b26c-4b2b-be39-42222bfb8cf3",
      "full_name" : "Dependencytree::DependencyAggregator",
      "resolved_refs" : [
         "2fab2d8d-44db-49f1-bfa0-7cd795e9488b"
      ],
      "methods" : [
         "initialize",
         "top_of_stack",
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
      "uuid" : "2cf6eb45-274f-43b5-85ff-8a3c6713e6a0",
      "name" : "DependencyAggregator",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/dependencyaggregator.rb",
      "constants" : [],
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
      "unresolved_refs" : [
         [
            "ArgumentError"
         ],
         [
            "Exception"
         ]
      ]
   }
]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/1and1/dependencytree.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
