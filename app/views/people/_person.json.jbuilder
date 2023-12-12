json.extract! person, :id, :first_name, :last_name, :sick, :date_exposed, :date_logged, :created_at, :updated_at
json.url person_url(person, format: :json)
