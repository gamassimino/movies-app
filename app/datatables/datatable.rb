class Datatable
  class MethodNotImplementedError < StandardError; end

  delegate :params, to: :@view

  require 'net/http'

  def initialize(view)
    @view = view
  end

  def as_json(_options = {})
    {
      sEcho: params[:sEcho].to_i,
      iTotalRecords: records.count,
      iTotalDisplayRecords: records.count,
      data: data
    }
  end

  def like(param)
    "('%' || #{param} || '%')"
  end

  protected

  def value_filter(column)
    params[:columns][column][:search][:value]
  end

  def data
    fail(
      MethodNotImplementedError,
      'Please implement this method in your class.'
    )
  end

  def records
    fail(
      MethodNotImplementedError,
      'Please implement this method in your class.'
    )
  end

  def per_page
    params[:length].to_i > 0 ? params[:length].to_i : 25
  end

  def page
    params[:start].to_i / per_page + 1
  end

  def columns
    fail(
      MethodNotImplementedError,
      'Please implement this method in your class.'
    )
  end

  def sort_column(column)
    columns[column.to_i]
  end

  def order_by
    orders = ""
    params[:order].each do |_key, value|
      dir = value[:dir]
      field = sort_column(value[:column]).to_s + " #{dir}"
      field += ' NULLS LAST' if dir.downcase == "desc"
      orders << field
    end
    orders
  end

  def paginated_records
    records.page(page).per(per_page)
  end

  def paginated_arrays
    Kaminari.paginate_array(records).page(page).per(per_page)
  end
end
