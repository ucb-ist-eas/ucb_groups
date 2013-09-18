# UcbGroups

Finds users that belong to a given ucb group

## Installation

Add this line to your application's Gemfile:

    gem 'ucb_groups'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ucb_groups

## Usage

First, authenticate:
```
UcbGroups::LdapConn.authenticate(<username>,  <password>)
```

Then...

Get list of groups in namespace:
```
UcbGroups::CampusGroup.find(<namespace>)
=> [CampusGroup, CampusGroup, ...]
```

Find people in one or more groups:
```
finder = UcbGroups::MembershipFinder.new(<namespace>)
people = finder.find(:groups => [grp1, grp2])
=> [Person, Person, Person, ...]
```

Find people in groups and filter by org:
```
finder = UcbGroups::MembershipFinder.new(<namespace>)
people = finder.find(:groups => [grp1, grp2], :orgs => [:JKASD])
=> [Person, Person, Person, ...]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
