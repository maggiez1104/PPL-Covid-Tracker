json.extract! person, :id, :first_name, :last_name, :sick, :days_sick, :date_logged, :created_at, :updated_at
json.url person_url(person, format: :json)
