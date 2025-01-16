module TurboStreamActionsHelper
  def remove_validation_errors
    turbo_stream_action_tag :remove_validation_errors
  end

  def set_validation_errors(attributes)
    turbo_stream_action_tag :set_validation_errors, attributes: attributes.to_json
  end

  def replace_element_attribute(attributes)
    turbo_stream_action_tag :replace_element_attribute, attributes: attributes.to_json
  end

  def remove_parent(elementSelector)
    turbo_stream_action_tag :remove_parent, target: elementSelector
  end

  def remove_element(elementSelector)
    turbo_stream_action_tag :remove_element, target: elementSelector
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
