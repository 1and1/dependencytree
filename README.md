# Dependencytree

Parses ruby source codes and tries to build a dependency tree from the seen classes, modules and references.
The output is a JSON file that contains all modules/classes along with their references.

The references can be used to build a dependency tree for your project.

## Installation

Install it yourself as from https://rubygems.org/ by calling:

    $ gem install dependencytree

## Usage

Use the program in the shell and give it all ruby sources or folders containing ruby sources.

### Example

An example call would look like this:

        dependencytree ./lib

### Command line options

The following is a list of possible command line options:

        -v, --verbose                    Verbose output
        -d, --debug                      Log debugging output to file 'dependencytree.log'
        -p, --pattern[=OPTIONAL]         Pattern to accept source codes with (default: (?-mix:.*\.rb))
        -i, --ignore[=OPTIONAL]          Paths to not load (default: (?-mix:^$))
        -o, --output[=OPTIONAL]          Output path for the JSON file
        -h, --help                       Show this message

### About the JSON output

The output will be a JSON of the references. The interesting parts are:
* **uuid**: Every class/module has a unique generated UUID for referencing. The UUID will stay unique only for one parsing run to allow graph building.
* **resolved_refs**: Resolved / found references that are pointing to the UUID of the refered class.
* **unresolved_refs**: Unresolved references that could not be found inside the sources provided.
  This can be Ruby classes or other classes from gems that were not scanned.
  The unresolved_refs entries are in ::-notation for example `"moduleA::mobuleB::classC"`
* **methods**: List of seen method names.
* **constants**: List of seen constant names.
* **path**: Filesystem path of the first source file with a class/module definition.
* **type**: `"module"` or `"class"`.
* **refs**: An array of all references (resolvable and unresolvable) in ::-notation (see above).
* **name**: The local module/class name, for example `"Stat"`.
* **full_name**: The full name of the module/class, for example `"File::Stat"`.

### Example JSON output

The following is the example for the dependency tree tool itself.
A similar output will be written for the example call given above.

```
[
   {
      "path" : null,
      "resolved_refs" : [],
      "full_name" : "Kernel",
      "type" : "module",
      "uuid" : "686bef0a-b4bc-4b19-bb70-eb0417b06779",
      "methods" : [],
      "name" : "Kernel",
      "constants" : [],
      "unresolved_refs" : [],
      "refs" : []
   },
   {
      "constants" : [
         "VERSION"
      ],
      "name" : "Dependencytree",
      "refs" : [
         "File",
         "STDERR",
         "Dir",
         "Parser::CurrentRuby",
         "Logger",
         "OptionParser",
         "DependencyAggregator",
         "ARGV",
         "ClassContainer"
      ],
      "unresolved_refs" : [
         "File",
         "STDERR",
         "Dir",
         "Parser::CurrentRuby",
         "Logger",
         "OptionParser",
         "ARGV"
      ],
      "full_name" : "Dependencytree",
      "resolved_refs" : [
         "38e0ac7a-9296-4b17-80cf-3e6aa99dd8ad",
         "904001e8-6b0b-4829-a64b-6c4c1c8736c7"
      ],
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "methods" : [],
      "uuid" : "8617cd01-c842-4f87-812c-16aa7c1e3945",
      "type" : "module"
   },
   {
      "uuid" : "904001e8-6b0b-4829-a64b-6c4c1c8736c7",
      "type" : "class",
      "methods" : [
         "initialize",
         "resolve_references",
         "resolve_reference",
         "resolve_reference_as_constant",
         "resolve_reference_direct",
         "resolve_by_full_name",
         "resolve_by_name"
      ],
      "parent_uuid" : "8617cd01-c842-4f87-812c-16aa7c1e3945",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classcontainer.rb",
      "full_name" : "Dependencytree::ClassContainer",
      "resolved_refs" : [],
      "unresolved_refs" : [],
      "refs" : [],
      "name" : "ClassContainer",
      "constants" : []
   },
   {
      "name" : "ClassModel",
      "constants" : [],
      "unresolved_refs" : [
         "SecureRandom",
         "ArgumentError"
      ],
      "refs" : [
         "SecureRandom",
         "ArgumentError"
      ],
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/classmodel.rb",
      "parent_uuid" : "8617cd01-c842-4f87-812c-16aa7c1e3945",
      "full_name" : "Dependencytree::ClassModel",
      "resolved_refs" : [],
      "uuid" : "b427a62b-46ee-4a01-8c03-2c595b8ac434",
      "type" : "class",
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
      ]
   },
   {
      "refs" : [
         "ArgumentError",
         "ClassModel",
         "Exception"
      ],
      "unresolved_refs" : [
         "ArgumentError",
         "Exception"
      ],
      "constants" : [],
      "name" : "DependencyAggregator",
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
      "uuid" : "38e0ac7a-9296-4b17-80cf-3e6aa99dd8ad",
      "type" : "class",
      "resolved_refs" : [
         "b427a62b-46ee-4a01-8c03-2c595b8ac434"
      ],
      "full_name" : "Dependencytree::DependencyAggregator",
      "path" : "/home/stephan/git/z/dependencytree/lib/dependencytree/dependencyaggregator.rb",
      "parent_uuid" : "8617cd01-c842-4f87-812c-16aa7c1e3945"
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
