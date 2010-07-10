require 'formtastic'

class MyCustomBuilder < Formtastic::SemanticFormBuilder 

      def check_boxes_input(method, options)
        collection = find_collection_for_column(method, options)
        html_options = options.delete(:input_html) || {}

        input_name      = generate_association_input_name(method)
        value_as_class  = options.delete(:value_as_class)
        unchecked_value = options.delete(:unchecked_value) || ''
        html_options    = { :name => "#{@object_name}[#{input_name}][]" }.merge(html_options)
        input_ids       = []

        selected_option_is_present = [:selected, :checked].any? { |k| options.key?(k) }
        selected_values = (options.key?(:checked) ? options[:checked] : options[:selected]) if selected_option_is_present
        Rails.logger.debug "**Formtastic selected values: #{[*selected_values].inspect} : #{[*selected_values].compact.inspect}"
        selected_values  = [*selected_values].compact

        disabled_option_is_present = options.key?(:disabled)
        disabled_values = [*options[:disabled]] if disabled_option_is_present

        list_item_content = collection.map do |c|
          label = c.is_a?(Array) ? c.first : c
          value = c.is_a?(Array) ? c.last : c
          input_id = generate_html_id(input_name, value.to_s.gsub(/\s/, '_').gsub(/\W/, '').downcase)
          input_ids << input_id

          html_options[:checked] = selected_values.include?(value) if selected_option_is_present
          html_options[:disabled] = disabled_values.include?(value) if disabled_option_is_present
          html_options[:id] = input_id

          li_content = template.content_tag(:label,
            Formtastic::Util.html_safe("#{self.check_box(input_name, html_options, value, unchecked_value)} #{label}"),
            :for => input_id
          )

          li_options = value_as_class ? { :class => [method.to_s.singularize, value.to_s.downcase].join('_') } : {}
          template.content_tag(:li, Formtastic::Util.html_safe(li_content), li_options)
        end

        field_set_and_list_wrapping_for_method(method, options, list_item_content)
      end
end
