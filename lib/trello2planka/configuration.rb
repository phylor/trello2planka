module Trello2planka
  class Configuration
    def initialize
      load_or_create
    end

    def path
      'config.yml'
    end

    def trello_credentials?
      @configuration.dig(:trello, :developer_public_key) && @configuration.dig(:trello, :member_token)
    end

    def trello_credentials
      @configuration.dig(:trello)
    end

    def store_trello_credentials(public_key, member_token)
      @configuration[:trello] ||= {}
      @configuration[:trello][:developer_public_key] = public_key
      @configuration[:trello][:member_token] = member_token

      save
    end

    def planka_server_url?
      !!@configuration.dig(:planka, :server_url)
    end

    def planka_server_url
      @configuration.dig(:planka, :server_url)
    end

    def store_planka_server_url(server_url)
      @configuration[:planka] ||= {}
      @configuration[:planka][:server_url] = server_url

      save
    end

    def planka_credentials?
      !!planka_credentials
    end

    def planka_credentials
      @configuration.dig(:planka, :access_token)
    end

    def store_planka_credentials(access_token)
      @configuration[:planka] ||= {}
      @configuration[:planka][:access_token] = access_token

      save
    end

    private

    def load_or_create
      if File.exists?(path)
        @configuration = YAML.load(File.read(path))
      else
        @configuration = {}
      end
    end

    def save
      File.write(path, @configuration.to_yaml)
    end
  end
end
