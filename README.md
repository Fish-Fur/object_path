# Object Path Resolver

Ruby class representing an path through an object graph.  Instance of the +ObjectPath+ class can be used to navigate through an object graph and the value(s) in the final step of the path are returned.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'object_path'
```

And then execute:
```
bundle install
```

Or install it yourself as:
```
gem install object_path
```

## Usage

Paths are defined as a set of steps.  These can be declared in a number of ways :-

- As a +String+ with each step separated by a '/' delimiter.
- As an array of +Strings+.
- As an array of +Symbols+.
- As an existing +ObjectPaths::ObjectPath+

```ruby
require 'object_paths/object_path'

path = ObjectPaths::ObjectPath.new('address/street')
path = ObjectPaths::ObjectPath.new(['address', 'street'])
path = ObjectPaths::ObjectPath.new([:address, :street])
path = ObjectPaths::ObjectPath.new(ObjectPaths::ObjectPath.new('address/street'))
```

The path can then be used to navigate through an object graph :-

```ruby
require 'object_paths/object_path'

class Address
  attr_accessor :street
end

class Person
  attr_accessor :address
end

address1 = Address.new
address1.street = '123 Main Street'

address2 = Address.new
address2.street = '456 High Street'

person1 = Person.new
person1.address = address1

person2 = Person.new
person2.address = address2

path.resolve(person1) # => '123 Main Street'
path.resolve(person2) # => '456 High Street'
```

If any step on the path is +Enumerable+ then the following steps with be resolved for each item and an +Array+ of results will be returned.  If multiple steps are +Enumerable+ then the process will be repeated for each item.  The resulting nested +Array+ will be flattened to a single +Array+. All +Array+ results are also comapected :-

```ruby
require 'object_paths/object_path'

class Address
  attr_accessor :street
end

class Person
  attr_accessor :addresses
end

address1 = Address.new
address1.street = '123 Main Street'
address2 = Address.new
address2.street = '456 High Street'

person = Person.new
person.addresses = [address1, address2]

path = ObjectPaths::ObjectPath.new('addresses/street')
path.resolve(person) # => ['123 Main Street', '456 High Street']
```

### String & Array Extensions

To ease the creating of new Object Paths the +String+ and +Array+ classes have been extended to allow them to be converted to Object Paths.  In both cases the instance method +to_object_path+ can be called to perform the conversions.

```ruby
require 'object_paths/object_path'

'address/street'.to_object_path
['address', 'street'].to_object_path
%i[address street].to_object_path
```
