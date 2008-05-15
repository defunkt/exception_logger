require File.dirname(__FILE__) + '/../../../config/environment'
puts IO.read(File.join(File.dirname(__FILE__), 'README'))
puts "\n\nAltering ApplicationController, this can be undone by editing that file..."
#install alter the app controller
app_controller = File.readlines(RAILS_ROOT + '/app/controllers/application.rb')
i = 0
new_app_controller = ''
app_controller.each do |line|
 if line.include?  'class ApplicationController' then
	 i = i + 1
	 app_controller[i] = "\s\sinclude ExceptionLoggable #Automatically Added by install script\n" + app_controller[i]
 end
 i = i + 1
 new_app_controller << line
end
app_controller_target = File.open(RAILS_ROOT + '/app/controllers/application.rb','w')
app_controller_target.write(new_app_controller)
app_controller_target.close
#app controller alter done
puts ".....Completed.\n"
puts "Altering routes.rb, this can be undone by editing that file..."
#modify the routes
routes = File.readlines(RAILS_ROOT + '/config/routes.rb')
i = 0
new_routes = ''
routes.each do |line|
	if line.include? 'ActionController::Routing::Routes.draw' then
		i = i + 1
		routes[i] = "map.connect \"logged_exceptions/:action/:id\", :controller => \"logged_exceptions\" #Automatically Added by install script\n" + routes[i]
	end
	i = i + 1
	new_routes << line
end
routes_target = File.open(RAILS_ROOT + '/config/routes.rb','w')
routes_target.write(new_routes)
routes_target.close
#altered routes file
puts ".....Completed.\n"
puts "Attempting to determine your pagination plugin..."
@pagination = 'none'
Dir.foreach(RAILS_ROOT + '/vendor/plugins') do |file|
	if file.strip == 'will_paginate' then
		@pagination = 'will_paginate'
	elsif file.strip == 'paginating_find' then
		@pagination = 'paginating_find'
	end
end
puts @pagination
if @pagination == 'will_paginate' then
	puts "You are using will_paginate, editing init.rb to reflect that..."
		#set it to will_paginate
		init_rb = File.readlines(File.join(File.dirname(__FILE__), 'init.rb'))
		i = 0
		new_init = ''
		init_rb.each do |line|
			if line.include? "$PAGINATION_TYPE = 'none'"
				line = '#' + line
			  j = i + 1
				init_rb[j] = init_rb[j].gsub('#','')
				j = j + 1
				init_rb[j] = init_rb[j].gsub('#','')
				j = j + 1
				init_rb[j] = init_rb[j].gsub('#','')
			end
			i = i + 1
			new_init << line
		end
		target = File.open(File.join(File.dirname(__FILE__), 'init.rb'),'w')
		target.write(new_init)
		target.close
elsif @pagination == 'paginating_find' then
	puts "You are using paginating_find, editing init.rb to reflect that..."
		#set it to paginating_find
		init_rb = File.readlines(File.join(File.dirname(__FILE__), 'init.rb'))
		i = 0
		new_init = ''
		init_rb.each do |line|
			if line.include? "$PAGINATION_TYPE = 'none'"
				line = '#' + line
			  j = i + 4
				init_rb[j] = init_rb[j].gsub('#','')
				j = j + 1
				init_rb[j] = init_rb[j].gsub('#','')
			end
			i = i + 1
			new_init << line
		end
		target = File.open(File.join(File.dirname(__FILE__), 'init.rb'),'w')
		target.write(new_init)
		target.close
else
	puts "Could not detect a pagination plugin, using home brewed pagination instead..."
end
#generate migration
puts "...Completed\n"
puts "Now use script/generate exception_migration\n Then run rake db:migrate\n\n"
