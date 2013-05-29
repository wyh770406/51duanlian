module PathHelper
  def resource_view_path(model, *options)
    options = options.extract_options!
    path = File.join(model.class.model_name.split('::').map(&:pluralize).map(&:underscore))
    path = File.join(options[:namespace], path) if options[:namespace]
    path = File.join(path, options[:action]) if options[:action]
    path = File.join(path, options[:partial]) if options[:partial]
    path
  end
end