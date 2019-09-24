class People::PeopleDatatable < Datatable
  include Rails.application.routes.url_helpers
  delegate :content_tag, :fa_icon, :link_to, :current_user, to: :@view

  def initialize(view)
    super view
  end

  private

  def data
    paginated_arrays.map do |person|
      [
        link(person['id'], person['first_name']),
        link(person['id'], person['last_name']),
        link(person['id'], person['aliases']),
        link_delete(person['id'])
      ]
    end
  end

  def records
    uri = URI('http://localhost:3001/api/v1/people.json')
    Net::HTTP.get(uri)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def columns
    %w(people.first_name people.last_name people.aliases)
  end

  def filter
    query = []
    binds = []
    if params[:search][:value].present?
      search = QueryUtil::like params[:search][:value]
      query << "(people.first_name ILIKE ? or
                 people.last_name ILIKE ? or
                 people.aliases ILIKE ?)"
      binds += [search] * 3
    end
  end

  def link_delete(person_id)
    if current_user.present?
      confirm = 'you will delete this person, are you sure?'
      title = 'Delete Person'
      destroy = content_tag :div, fa_icon('trash-o'), class: "datatable-btn datable-btn-warning"
      content_tag :div,
        link_to(destroy, person_path(id: person_id),
          method: :delete, data: { confirm: confirm, turbolinks: false }, title: title,
          class: "text-center"), class: 'text-center'
    end
  end

  def link(person_id, title)
    link_to(title, person_path(person_id)) if title.present?
  end
end
