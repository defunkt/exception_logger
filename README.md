ExceptionLogger
===============

The Exception Logger (forgive the horrible name) logs your Rails exceptions in the database and provides a funky web interface to manage them.

First you need to generate the migration:

  ./script/generate exception_migration

Next, you'll need to include the ExceptionLoggable module into ApplicationController.  Once that's done you might want to modify key methods to customize the logging:

  render_404(exception) - Shows the 404 template.
  
  render_500(exception) - Shows the 500 template.
  
  log_exception(exception) - Logs the actual exception in the database.
  
  rescue_action_in_public(exception) - Does not log these exceptions: ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction

Now add a new route to your routes.rb:

  map.connect "logged_exceptions/:action/:id", :controller => "logged_exceptions"

After that, visit /logged_exceptions in your application to manage the exceptions.

Once you have done that, open up the vendor/plugins/init.rb file and choose your pagination,
supported options are will_paginate, paginating_find, and simple mysql based pagination (Uses LIMIT)
The current default is none. To use the other options you need to uncomment the $PAGINATION_TYPE line
and the require for that pagination, you should comment out what you won't use etc...

It's understandable that you may want to require authentication.  Add this to your config/environments/production.rb:

  # config/environments/production.rb
  config.after_initialize do
    require 'application' unless Object.const_defined?(:ApplicationController)
    LoggedExceptionsController.class_eval do
      # set the same session key as the app
      session :session_key => '_beast_session_id'
      
      # include any custom auth modules you need
      include AuthenticationSystem
      
      before_filter :login_required
      
      # optional, sets the application name for the rss feeds
      self.application_name = "Beast"
      
      protected
        # only allow admins
        # this obviously depends on how your auth system works
        def authorized?
          current_user.is_a?(Admin)
        end
        
        # assume app's login required doesn't use http basic
        def login_required_with_basic
          respond_to do |accepts|
            # alias_method_chain will alias the app's login_required to login_required_without_basic
            accepts.html { login_required_without_basic }
            
            # access_denied_with_basic_auth is defined in LoggedExceptionsController
            # get_auth_data returns back the user/password pair
            accepts.rss do
              access_denied_with_basic_auth unless self.current_user = User.authenticate(*get_auth_data)
            end
          end
        end
        
        alias_method_chain :login_required, :basic
    end
  end

The exact code of course depends on the specific needs of your application.

CREDITS

Jamis Buck  - original exception_notification plugin
Rick Olson  - model/controller code
Josh Goebel - design
Jason Knight - Pagination support, built on/inspired by Ryanb's willpaginate support.
