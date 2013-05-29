<% module_namespacing do -%>
module Admin
  class <%= controller_class_name %>Controller < BaseController
    def index
      @<%= plural_table_name %> = <%= class_name %>.page(params[:page]).per(15)
    end

    def show
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def new
      @<%= singular_table_name %> = <%= orm_class.build(class_name) %>
    end

    def edit
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
    end

    def create
      @<%= singular_table_name %> = <%= orm_class.build(class_name, "params[:#{singular_table_name}]") %>

      if @<%= orm_instance.save %>
        redirect_to admin_<%= singular_table_name %>_path(@<%= singular_table_name %>)
      else
        render <%= key_value :action, '"new"' %>
      end
    end

    def update
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>

      if @<%= orm_instance.update_attributes("params[:#{singular_table_name}]") %>
        redirect_to admin_<%= singular_table_name %>_path(@<%= singular_table_name %>)
      else
        render <%= key_value :action, '"edit"' %>
      end
    end

    def destroy
      @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
      @<%= orm_instance.destroy %>

      redirect_to admin_<%= index_helper %>_url
    end
  end
end
<% end -%>
