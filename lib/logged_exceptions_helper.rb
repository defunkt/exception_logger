module LoggedExceptionsHelper
  def filtered?
    [:query, :date_ranges_filter, :exception_names_filter, :controller_actions_filter].any? { |p| params[p] }
  end

  def pagination_remote_links(collection)
    will_paginate collection, 
      :renderer   => 'LoggedExceptionsHelper::PaginationRenderer',
      :prev_label => '',
      :next_label => '',
      :container  => false
  end

  class PaginationRenderer < WillPaginate::LinkRenderer
    def page_link_or_span(page, span_class = 'current', text = nil)
      text ||= page.to_s
      if page and page != current_page
        @template.link_to_function text, "ExceptionLogger.setPage(#{page})"
      else
        @template.content_tag :span, text, :class => span_class
      end
    end
  end
end
