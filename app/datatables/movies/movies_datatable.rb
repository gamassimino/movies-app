class Movies::MoviesDatatable < Datatable
  include Rails.application.routes.url_helpers
  delegate :content_tag, :fa_icon, :link_to, :current_user, to: :@view

  def initialize(view)
    super view
  end

  private

  def data
    paginated_arrays.map do |movie|
      [
        link(movie['id'], movie['title']),
        link(movie['id'], movie['release_year']),
        link_delete(movie['id'])
      ]
    end
  end

  def records
    uri = URI("#{ENV['API_DOMAIN']}/api/v1/movies.json")
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

  def link_delete(movie_id)
    if current_user.present?
      confirm = 'you will delete this movie, are you sure?'
      title = 'Delete Movie'
      destroy = content_tag :div, fa_icon('trash-o'), class: "delete-button datatable-btn datable-btn-warning", data: { id: movie_id }
      content_tag :div,
        link_to(destroy, '', data: { confirm: confirm, turbolinks: false }, title: title,
          class: "text-center"), class: 'text-center'
    end
  end

  def link(movie_id, title)
    link_to(title, movie_path(movie_id)) if title.present?
  end
end
