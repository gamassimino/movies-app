class Movies::MoviesDatatable < Datatable
  include Rails.application.routes.url_helpers
  delegate :t, :content_tag, :fa_icon, :link_to,
           :current_user, to: :@view

  def initialize(view)
    super view
  end

  private

  def data
    paginated_arrays.map do |movie|
      [
        movie['title'],
        movie['release_year']
      ]
    end
  end

  def records
    uri = URI('http://localhost:3001/api/v1/movies.json')
    Net::HTTP.get(uri)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body)
  end

  def columns
    %w(movies.title)
  end

  def filter
    query = []
    binds = []
    if params[:search][:value].present?
      search = QueryUtil::like params[:search][:value]
      query << "(movies.title ILIKE ? ILIKE ?)"
      binds += [search] * 1
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
