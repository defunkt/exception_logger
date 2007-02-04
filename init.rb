if LoggedExceptionsController.respond_to?(:view_paths)
  LoggedExceptionsController.view_paths = [File.join(directory, 'views')]
else
  LoggedExceptionsController.template_root = File.join(directory, 'views')
end