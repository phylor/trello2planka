module Trello2planka
  class TrelloApi
    def authenticate
      configuration = Trello2planka::Configuration.new

      if configuration.trello_credentials?
        @public_key = configuration.trello_credentials[:developer_public_key]
        @member_token = configuration.trello_credentials[:member_token]
      else
        Trello.open_public_key_url
        print 'Enter your public key: '
        @public_key = STDIN.gets.chomp

        Trello.open_authorization_url key: @public_key
        print 'Enter your member token: '
        @member_token = STDIN.gets.chomp

        configuration.store_trello_credentials(
          @public_key,
          @member_token
        )
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

    def get_lists(trello_board_id)
      board = Trello::Board.find(trello_board_id)
      board.lists.sort_by { |list| list.pos }
    end

    def download_attachment(url)
      trello_key = Trello.configuration.developer_public_key
      trello_token = Trello.configuration.member_token

      if url.starts_with?('https://trello-attachments')
        # Old URLs are accessible publicly
        URI.open(url).read
      else
        # New URLs require authentication
        trello_response = HTTP
          .auth("OAuth oauth_consumer_key=\"#{trello_key}\", oauth_token=\"#{trello_token}\"")
          .get(url)
      end
    end
  end
end
