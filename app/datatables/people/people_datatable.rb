class People::PeopleDatatable < Datatable
  include Rails.application.routes.url_helpers
  delegate :t, :content_tag, :fa_icon, :link_to,
           :current_user, to: :@view

  def initialize(view)
    super view
  end

  private

  def data
    paginated_arrays.map do |person|
      [
        person['first_name'],
        person['last_name'],
        person['aliases']
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

  # def link_delete(user)
  #   confirm = t 'dashboard.users.destroy.confirm'
  #   title = t 'dashboard.users.destroy.title'
  #   destroy = content_tag :div, fa_icon('trash-o'), class: "datatable-btn datable-btn-warning"
  #   content_tag :div,
  #     link_to(destroy, dashboard_user_path(user),
  #       method: :delete, data: { confirm: confirm, turbolinks: false }, title: title,
  #       class: "text-center"), class: 'text-center'
  # end

  # def link(user, title)
  #   link_to(title.to_s, edit_dashboard_user_path(user),
  #     class: "color-link", data: { turbolinks: false })
  # end
end
