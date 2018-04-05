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
      "full_name" : "Kernel",
      "unresolved_refs" : [],
      "uuid" : "424ab3a4-60d3-4e7d-9374-8d1d72bd0d91",
      "type" : "module",
      "resolved_refs" : [],
      "refs" : [],
      "constants" : [],
      "path" : null,
      "name" : "Kernel"
   },
   {
      "type" : "module",
      "uuid" : "401771ee-5c37-4bdf-a10d-f9a467827791",
      "constants" : [
         "VERSION"
      ],
      "name" : "Dependencytree",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "resolved_refs" : [
         "aad66db1-8229-4565-8a9e-d1ea73d2281c",
         "1212a5b6-75b8-4836-8867-14a8734bf3e2"
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
      "full_name" : "Dependencytree",
      "methods" : [],
      "unresolved_refs" : [
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
            "ARGV"
         ]
      ]
   },
   {
      "parent_uuid" : "401771ee-5c37-4bdf-a10d-f9a467827791",
      "type" : "class",
      "uuid" : "1212a5b6-75b8-4836-8867-14a8734bf3e2",
      "constants" : [],
      "name" : "ClassContainer",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "refs" : [],
      "resolved_refs" : [],
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
      "unresolved_refs" : []
   },
   {
      "full_name" : "Dependencytree::ClassModel",
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
      "unresolved_refs" : [
         [
            "SecureRandom"
         ],
         [
            "ArgumentError"
         ]
      ],
      "uuid" : "9a267b3e-0784-4114-810f-8d38484dbbc7",
      "type" : "class",
      "parent_uuid" : "401771ee-5c37-4bdf-a10d-f9a467827791",
      "refs" : [
         [
            "SecureRandom"
         ],
         [
            "ArgumentError"
         ]
      ],
      "resolved_refs" : [],
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classmodel.rb",
      "constants" : [],
      "name" : "ClassModel"
   },
   {
      "unresolved_refs" : [
         [
            "ArgumentError"
         ],
         [
            "Exception"
         ]
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
      "full_name" : "Dependencytree::DependencyAggregator",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/dependencyaggregator.rb",
      "constants" : [],
      "name" : "DependencyAggregator",
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
      "resolved_refs" : [
         "9a267b3e-0784-4114-810f-8d38484dbbc7"
      ],
      "parent_uuid" : "401771ee-5c37-4bdf-a10d-f9a467827791",
      "type" : "class",
      "uuid" : "aad66db1-8229-4565-8a9e-d1ea73d2281c"
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
