module Trello2planka
  class PlankaApi
    def authenticate
      configuration = Trello2planka::Configuration.new

      if configuration.planka_server_url?
        @server_url = configuration.planka_server_url
      else
        print 'Planka server URL (e.g. https://planka.mydomain.com): '
        @server_url = STDIN.gets.chomp

        configuration.store_planka_server_url(@server_url)
      end

      if configuration.planka_credentials?
        @access_token = configuration.planka_credentials
      else
        print 'Planka username: '
        username = STDIN.gets.chomp
        print 'Planka password: '
        password = STDIN.gets.chomp

        response = HTTP.post("#{@server_url}/api/access-tokens", body: {
          emailOrUsername: username,
          password: password
        }.to_json)

        body = JSON.parse(response.body.to_s)
        @access_token = body['item']

        configuration.store_planka_credentials(@access_token)
      end
    end

    def create_project(project_name)
      parse_json_id post_json(
        "/projects",
        { name: project_name }
      )
    end

    def create_board(project_id, board_name)
      post_json(
        "/projects/#{project_id}/boards",
        { name: board_name, type: 'kanban', position: 65535 })
    end

    def create_list(board_id, list_name, position)
      parse_json_id post_json(
        "/boards/#{board_id}/lists",
        { name: list_name, position: position }
      )
    end

    def create_card(board_id, list_id, title, position, description, due_date, created_at)
      data = {
        name: title,
        listId: list_id,
        position: position,
        createdAt: created_at
      }

      data[:dueDate] = due_date if due_date
      data[:description] = description if description && description != ''

      parse_json_id post_json(
        "/boards/#{board_id}/cards",
        data
      )
    end

    def create_task(card_id, name, completed)
      data = {
        name: name,
        isCompleted: completed
      }

      parse_json_id post_json(
        "/cards/#{card_id}/tasks",
        data
      )
    end

    def create_attachment(card_id, file_name, url, attachment_stream)
      parse_json_id post_form(
        "/cards/#{card_id}/attachments",
        { file: HTTP::FormData::File.new(StringIO.new(attachment_stream), filename: file_name) })
    end

    def get_card(card_id)
      get_json("/cards/#{card_id}") do |response|
        response['item']
      end
    end

    def update_card(card_id, data)
      parse_json_id patch_json("/cards/#{card_id}", data)
    end

    def create_comment(card_id, comment_text, created_at)
      post_json("/cards/#{card_id}/comment-actions", { text: comment_text, createdAt: created_at }) do |response|
        response['item']
      end
    end

    def create_label(board_id, name, color)
      parse_json_id post_json("/boards/#{board_id}/labels", { name: name, color: color })
    end

    def add_label(card_id, label_id)
      parse_json_id post_json("/cards/#{card_id}/labels", { labelId: label_id })
    end

    private

    def get_json(path)
      response = HTTP
        .auth("Bearer #{@access_token}")
        .get("#{@server_url}/api#{path}")

      if block_given?
        yield JSON.parse(response.body.to_s)
      else
        response
      end
    end

    def post_json(path, json)
      response = HTTP
        .auth("Bearer #{@access_token}")
        .post("#{@server_url}/api#{path}", json: json)

      if block_given?
        yield JSON.parse(response.body.to_s)
      else
        response
      end
    end

    def patch_json(path, json)
      response = HTTP
        .auth("Bearer #{@access_token}")
        .patch("#{@server_url}/api#{path}", json: json)

      if block_given?
        yield JSON.parse(response.body.to_s)
      else
        response
      end
    end

    def post_form(path, form)
      response = HTTP
        .auth("Bearer #{@access_token}")
        .post("#{@server_url}/api#{path}", form: form)

      if block_given?
        yield JSON.parse(response.body.to_s)
      else
        response
      end
    end

    def parse_json_id(response)
      if response.status.ok?
        json = JSON.parse(response.body.to_s)

        json['item']['id']
      else
        raise RequestError.new('Request failed', response)
      end
    end
  end
end
