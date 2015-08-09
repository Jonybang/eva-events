class <%= controller_class_name %>Controller < InheritsController
<% if options[:singleton] -%>
  defaults :singleton => true
<% end -%><% if Rails::VERSION::MAJOR >= 4 || defined?(ActiveModel::ForbiddenAttributesProtection) -%>
  private

    def <%= singular_name %>_params
      params.require(:<%= singular_name %>).permit!
      #params.require(:<%= singular_name %>).permit(<%= attributes_names.map{ |a_name| ":#{a_name}" }.join(", ") %>)
    end
<% end -%>
end
