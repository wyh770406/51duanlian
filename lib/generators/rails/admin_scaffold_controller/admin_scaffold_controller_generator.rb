require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class AdminScaffoldControllerGenerator < NamedBase
      include ResourceHelpers
      source_root File.expand_path('../templates', __FILE__)

      check_class_collision :suffix => "Controller"

      class_option :orm, :banner => "NAME", :type => :string, :required => true,
                         :desc => "ORM to generate the controller for"

      def create_controller_files
        template 'controller.rb', File.join('app/controllers/admin', class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :template_engine, :as => :admin_scaffold
    end
  end
end
