require "trello2planka/version"
require 'trello'
require 'yaml'

module Trello2planka
  class Error < StandardError; end

  class TrelloAPI
    def authenticate
      configuration = YAML.load(File.read('config.yml')) if File.exists?('config.yml')

      if configuration && configuration[:trello][:developer_public_key] && configuration[:trello][:member_token]
        @public_key = configuration[:trello][:developer_public_key]
        @member_token = configuration[:trello][:member_token]
      else
        Trello.open_public_key_url
        print 'Enter your public key: '
        @public_key = STDIN.gets.chomp

        Trello.open_authorization_url key: @public_key
        print 'Enter your member token: '
        @member_token = STDIN.gets.chomp

        configuration = {
          trello: {
            developer_public_key: @public_key,
            member_token: @member_token
          }
        }
        File.write('config.yml', configuration.to_yaml)
      end

      Trello.configure do |config|
        config.developer_public_key = @public_key
        config.member_token = @member_token
      end
    end

    def get_board_name(trello_board_id)
      board = Trello::Board.find(trello_board_id)
      board.name
    end
  end
end
