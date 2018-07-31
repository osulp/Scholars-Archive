class MultiValueOrderedInput < MultiValueInput
  def input_type
    'multi_value'.freeze
  end

  def input(wrapper_options)
    @rendered_first_element = false
    input_html_classes.unshift('string')
    input_html_options[:name] ||= "#{object_name}[#{attribute_name}][]"

    outer_wrapper do
      buffer_each(collection) do |value, index|
        inner_wrapper do
          build_field(value, index)
        end
      end
    end
  end

  protected

  def outer_wrapper
   "<div class='panel-group dd' id='dd'>
      <ol id='sorted-creators'>\n
        #{yield}\n
      </ol>
    </div>\n"
  end

  def inner_wrapper
    "<li class='dd-item dd3-item featured-item form-control'>
       <div class='dd-handle dd3-handle'></div>
       <div class='dd3-content panel panel-default'>
         <div class='main row'><ul class=\'listing\'>\n
           #{yield}\n
         </div>
       </div>
     </li>\n"
  end
end
