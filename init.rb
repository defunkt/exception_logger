if Kernel.const_defined? 'WillPaginate'
	require 'will_paginate'
	WillPaginate.enable
end
LoggedExceptionsController.view_paths = [File.join(directory, 'views')]
