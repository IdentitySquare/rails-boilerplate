module ApplicationHelper

  def flash_messages_display
    flash_messages_display = []
    flash.each do |key, value|
      if value.present? && ['error', 'alert', 'notice', 'success'].include?(key)
        flash_messages_display << {key => value}
      end
    end
    flash_messages_display.reduce(:merge)
  end

  def flash_message_color(keys)
    if keys.include?('success')
      'primary'
    elsif keys.include?('notice')
      'dark'
    elsif keys.include?('alert')
      'warning'
    else
      'danger'
    end
  end

  def errors_for(object)
    if object.errors.any?
      content_tag(:div, class: "card border-danger mb-3") do
        concat(content_tag(:div, class: "card-header bg-danger text-white") do
          concat "#{pluralize(object.errors.count, "error")} while trying to save this #{object.class.name.downcase}"
        end)
        concat(content_tag(:div, class: "card-body") do
          concat(content_tag(:ul, class: 'mb-0') do
            object.errors.full_messages.each do |msg|
              concat content_tag(:li, msg)
            end
          end)
        end)
      end
    end
  end

  def current_page?(controller: nil, action: nil)
    if controller && action
      controller == params[:controller] && params[:action] == action
    else
      controller == params[:controller] || params[:action] == action
    end
  end


end
