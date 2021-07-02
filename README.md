# DynamicModel

Welcome to the DynamicModel gem. This gem provides all the functionality to create dynamic data models in your (Rails) application. This can help you to provide a data model which your users can adapt during runtime, without the requiring a redeployment.

Tested with Rails & Postgresql and SQLite databases.

Currently supporte DataAttribute types:

- Number
- Text
- Reference

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dynamic_model'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dynamic_model

## Usage

To use this gem, you have to create the following models:

### DataType

```ruby
class DataType < ActiveRecord::Base
  dynamic_model
end
```

The database table for this model not need to include any specific fields

### DataAttribute
For the DataAttribute you have to specify which class represents the DataType.

```ruby
class DataAttribute < ActiveRecord::Base
  dynamic_model_attribute(
    data_type_class_name: "DataType"
  )
end
```

The database table for this model needs to include the following fields:

```ruby
 - validation_definition: JSON(B)
 - attribute_type: String
 - data_type_id: Integer
```

### DataObject

For the DataAttribute you have to specify which class represents the DataType, and which column contains the data of a data objects (`data` by default).

```ruby
class DataObject < ActiveRecord::Base
  dynamic_model_data_object(
    data_column_name: "data", 
    data_type_class_name: "DataType"
  )
end
```

The database table for this model needs to include the following fields:

```ruby
 - data: JSON(B) # Can also have a different name, if specified in the model.
 - data_type_id: Integer
```

Each model can be expanded with your own attributes which you might deem relevant. A basic idea to make the model more intuitive is to add a name field to the DataType and DataAttribute model, so you can present something different than ids to your user.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Test
You can run all the tests by executing the following command:

    $ bundle exec rspec ./spec

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dynamic_model. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/dynamic_model/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
