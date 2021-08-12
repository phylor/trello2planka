# Trello2planka

Trello2planka is a Ruby gem to copy Trello boards to [Planka](https://planka.app).

## Installation

    $ gem install trello2planka

## Usage

1. Find the Trello board ID
2. Create a Planka board
3. Find the Planka board ID

```shell
$ trello2planka import <trello_board_id> <planka_board_id>
```

## Imported Data

- Lanes (incl. their order on board)
- Cards (incl. description, order in lane)
- Checklists
- Comments
- Attachments
- Labels

### Caveats

- Boards
  - Planka boards can not be created, because the Planka HTTP API for creating boards is currently disabled.
- Cards
  - Creation date of card not copied. Cards appear in Planka with the creation date of the import. This is because we cannot set the `createdAt` attribute in Planka in the API.
- Checklists
  - Planka does not support multiple checklists, but only one list of tasks. All Trello checklist items are copied to the Planka tasklist. The name of the Trello checklists are lost.
- Comments
  - Creation date is not imported. The order of comments on the cards should (probably) be correct.
- Attachments
  - Planka does not support links as attachments. Links are concatenated and added to the description of the card.
- Labels
  - Planka does not support labels without a name. As a label name the Planka color is used.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

To run it during development:

    $ ruby -Ilib ./exe/trello2planka

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/phylor/trello2planka.
