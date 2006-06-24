class LoggedExceptionsController < ActionController::Base
  self.template_root = File.join(RAILS_ROOT, 'vendor/plugins/exception_logger/views')
  layout nil

  def index
    @exception_names    = LoggedException.find_exception_class_names
    @controller_actions = LoggedException.find_exception_controllers_and_actions
    query
  end

  def query
    conditions = []
    parameters = []
    unless params[:query].blank?
      conditions << 'message LIKE ?'
      parameters << "%#{params[:query]}%"
    end
    unless params[:date_ranges_filter].blank?
      conditions << 'created_at >= ?'
      parameters << params[:date_ranges_filter].to_f.days.ago.utc
    end
    unless params[:exception_names_filter].blank?
      conditions << 'exception_class = ?'
      parameters << params[:exception_names_filter]
    end
    unless params[:controller_actions_filter].blank?
      conditions << 'controller_name = ? AND action_name = ?'
      parameters += params[:controller_actions_filter].split('/').collect(&:downcase)
    end
    @exception_pages, @exceptions = paginate :logged_exceptions, :order => 'created_at desc', :per_page => 30, 
      :conditions => conditions.empty? ? nil : parameters.unshift(conditions * ' and ')
  end
  
  def show
    @exc = LoggedException.find params[:id]
  end
  
  def destroy
    LoggedException.destroy params[:id]
  end
end