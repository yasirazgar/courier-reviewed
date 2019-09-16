class Paginator
  include Rails.application.routes.url_helpers

  DEFAULT_LIMIT = 10
  DEFAULT_PAGE = 1

  attr_accessor :relation, :params, :limit, :page, :total_count, :next_page, :prev_page, :first_page, :last_page

  def initialize(relation, params, url)
    @relation = relation
    @params = format_params(params)
    @url = url

    @limit = get_limit
    @page = get_page
    @first_page = DEFAULT_PAGE
    @total_count = relation.size
    @total_pages = @last_page = (@total_count.to_f / @page.to_f).ceil
    @next_page = next_page
    @prev_page = prev_page
    @offset = (@page -1) * @limit
  end

  def paginate
    @relation.limit(@limit).offset(@offset)
  end

  def prev_link
    send(@url, @params.merge({ limit: @limit, page: @prev_page }))
  end

  def next_link
    send(@url, @params.merge({
      limit: @limit,
      page: @next_page
    }))
  end

  def first_link
    return unless @first_page

    send(@url, @params.merge({
      limit: @limit,
      page: @first_page
    }))
  end

  def last_link
    return unless @last_page

    send(@url, @params.merge({
      limit: @limit,
      page: @last_page
    }))
  end

  def links
    {
      first: first_link,
      last: last_link,
      prev: prev_link,
      next: next_link
    }
  end

  def header_links
    {
      Link: links.map(&method(:gen_header_link)),
      Total: @total_pages,
      Limit: @limit,
      Current: @page
    }.map(&method(:gen_header_link)).join(', ')
  end

  private

  def format_params(params)
    params.clone.permit!
          .to_h.symbolize_keys # needs for converting to url via url_helper
          .except(:format, :controller, :action)
  end

  def gen_header_link(key, url)
    "<#{url}>; rel=\"#{key}\""
  end

  def next_page
    return nil if @page == @total_count

    @page + 1
  end

  def prev_page
    return nil if @page == 1

    @page - 1
  end

  def get_limit
    limit = @params[:limit].to_i

    (limit <= 0) ? DEFAULT_LIMIT : limit
  end

  def get_page
    page = @params[:page].to_i

    (page <= 0) ? DEFAULT_PAGE : page
  end
end
