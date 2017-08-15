json.extract! board, :id, :title, :content, :created_at, :updated_at
json.url board_url(board, format: :json)
