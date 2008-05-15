module LoggedExceptionsHelper
  def filtered?
    [:query, :date_ranges_filter, :exception_names_filter, :controller_actions_filter].any? { |p| params[p] }
  end

  def pagination_remote_links(collection)
		ret = ''
		if $PAGINATION_TYPE == 'will_paginate'
			pagination = will_paginate (collection, 
				:renderer   => 'LoggedExceptionsHelper::PaginationRenderer',
				:prev_label => '',
				:next_label => '',
				:container  => false)
			if collection.total_pages > 1 then
				ret = ":: Pages : <strong>#{pagination}</strong>"
			end
		elsif $PAGINATION_TYPE == 'paginating_find' then
			pagination = paginating_links collection
			ret = ":: Pages : <strong>#{pagination}</strong>"
		else
			next_page = params[:page].to_i + 1
			prev_page = 0
			prev_link = ''
			if params[:page].to_i > 0 then
				prev_page = params[:page].to_i - 1
				prev_link = "<a href=\"?page=#{prev_page}\"> Previous page</a>"
			end
			next_link = "<a href=\"?page=#{next_page}\">Next page</a>"		
			ret = "Pagination not available#{prev_link} - #{next_link}"
		end
  end
	
  if $PAGINATION_TYPE == 'will_paginate'
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
end
