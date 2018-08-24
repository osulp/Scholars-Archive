(($) ->
  Blacklight.onLoad ->
    $('.multi_value.nested-field.form-group').manage_fields()
    $(".multi_value.nested-field.form-group").on("managed_field:remove", (event, removed) ->
      # Remove if the nested field is an existing element and is set to be destroyed or removed
      removed = $(removed)
      id_field = removed.find("input[name$='[id]']")
      if(id_field.length > 0)
        destroy_field = $("<input type='hidden'>")
        index = getFieldIndex(id_field)
        if index != -1
          destroy_field.attr("name", id_field.attr("name").replace(/\[id\]/,"[_destroy]"))
          destroy_field.attr("id", id_field.attr("id").replace(new RegExp('_'+index+'_id', 'g'), '_'+index+'__destroy'))
          destroy_field.val('1')
          destroy_field.insertAfter(id_field)
          removed.hide()
          removed.appendTo($(this))
    )

    getFieldIndex = (field) ->
      # get index from name attribute in the form "#{object_name}[#{attribute_name}_attributes][#{index}][label]"
      matches_array = field.attr("name").match(/\[(.*)\]\[(.*)\]\[(.*)\]/)
      if matches_array?
        return parseInt(matches_array[2])
      else
        return -1

    getLastChildId = (last_child) ->
      inputs = last_child.find('input')
      firstChild = inputs.first()
      return getFieldIndex(firstChild)

    removeLastChildId = (last_child) ->
      # remove last_child inputs where the id attribute ends with '_id'
      last_child.find("input[id$='_id']").remove()
      # clear input values
      last_child.find('input').attr('value', "")

    $(".multi_value.nested-field.form-group").on("managed_field:add", (event) ->
      # Find the last child field and update the index (with a unique value) in the name and id attributes so that they
      # follow these patterns needed for nested attributes:
      #   name = "#{object_name}[#{attribute_name}_attributes][#{index}][label]"
      #   id = "#{object_name}_#{attribute_name}_attributes_#{index.to_s}_label"
      # example:
      #   name = "article[nested_related_items_attributes][1][label]"
      #   id = "article_nested_related_items_attributes_1_label"
      window.setTimeout(->
        target = $(event.target)
        last_child = target.find("ul.listing .field-wrapper").last()

        removeLastChildId(last_child)

        # get child id
        id = getLastChildId(last_child)

        if id != -1
          newId = new Date().getTime() + id # use current time to make sure the new id is unique
          last_child.find('input').each (i, e) =>
            swapIdOnElement(i, e, newId)
            return
      , 15)
    )

    resetNestedItemId = (item) ->
      # remove id
      item.find("input[id$='_id']").remove()

      # get child id
      id = getLastChildId(item)

      if id != -1
        newId = new Date().getTime() + id
        item.find('input').each (i, e) =>
            swapIdOnElement(i, e, newId)
            return


    swapIdOnElement = (i, e, newId) ->
      name = $(e).prop('name').replace(/\[\d+\]/g, "[#{newId}]")
      $(e).prop('name', name)
      id = $(e).prop('id').replace(/_\d+_/g, "_#{newId}_")
      $(e).prop('id', id)
      return

    allEmptyItems = (items) ->
      all_items = items.find("input:text")
      empty_items = 0
      all_items.each (i, e) ->
        if $(e).val().length == 0
          empty_items++

      if all_items.length == empty_items
        return true
      else
        return false

    removeEmptyItems = (items) ->
      all_items = items.find("input:text")

      if (allEmptyItems(items) == true)
        all_items.each (i, e) ->
          if $(e).val().length == 0 && i > 0
            $(e).parent().remove()
      else
        all_items.each (i, e) ->
          if $(e).val().length == 0
            $(e).parent().remove()

    resetNestedFieldItems = (field_selector) ->
      reindex_ordered_list = ""
      items = $(field_selector).find('ul.dd-list li.dd-item')
      removeEmptyItems(items)

      items.each (idx, element) ->
        removed = $(element).clone()
        id_field = removed.find("input[name$='[id]']")
        if(id_field.length > 0)
          destroy_field = $("<input type='hidden'>")
          index = getFieldIndex(id_field)
          if index != -1
            destroy_field.attr("name", id_field.attr("name").replace(/\[id\]/,"[_destroy]"))
            destroy_field.attr("id", id_field.attr("id").replace(new RegExp('_'+index+'_id', 'g'), '_'+index+'__destroy'))
            destroy_field.val('1')
            destroy_field.insertAfter(id_field)
            reindex_ordered_list += "<li class='hidden'>"+removed.html()+"</li>"
            resetNestedItemId($(element))

      $(field_selector).append($(reindex_ordered_list))

    resetNestedFieldItems('.nested-ordered-creator.ordered-field-container')
    resetNestedFieldItems('.nested-ordered-title.ordered-field-container')
    resetNestedFieldItems('.nested-ordered-related-items.ordered-field-container')
) jQuery
