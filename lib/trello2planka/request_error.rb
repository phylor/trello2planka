module Trello2planka
  class RequestError < StandardError
    attr_reader :response

    def initialize(message, response)
      super(message)

      @response = response
    end

    def message
      <<~EOM
        REQUEST FAILED
        #{response}

        #{response.body}
      EOM
    end
  end
end
