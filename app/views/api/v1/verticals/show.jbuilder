json.links { json.self api_v1_vertical_path(@vertical) }
json.data @vertical, partial: 'vertical', as: :vertical
