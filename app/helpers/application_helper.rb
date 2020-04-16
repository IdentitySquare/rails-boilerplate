module ApplicationHelper

  # def flash_messages_display
  #   flash_messages_display = []
  #   flash.each do |key, value|
  #     flash_messages_display << {key => value} if value.present? && ['error', 'alert', 'notice', 'success', 'recaptcha_error'].include?(key)
  #   end
  #   flash_messages_display.reduce(:merge)
  # end

  # def errors_for(object)
  #   if object.errors.any?
  #     content_tag(:div, class: "card border-danger mb-3") do
  #       concat(content_tag(:div, class: "card-header bg-danger text-white") do
  #         concat "#{pluralize(object.errors.count, "error")} while trying to save this #{object.class.name.downcase}"
  #       end)
  #       concat(content_tag(:div, class: "card-body") do
  #         concat(content_tag(:ul, class: 'mb-0') do
  #           object.errors.full_messages.each do |msg|
  #             concat content_tag(:li, msg)
  #           end
  #         end)
  #       end)
  #     end
  #   end
  # end

  def current_page?(controller: nil, action: nil)
    if controller && action
      controller == params[:controller] && params[:action] == action
    else
      controller == params[:controller] || params[:action] == action
    end
  end


end
