module ApplicationHelper
  FLASH_CLASSES = {
    success: "alert-success",
    error: "alert-danger",
    alert: "alert-warning",
    notice: "alert-info"
  }.freeze

  def bootstrap_class_for(flash_type)
    FLASH_CLASSES[flash_type.to_sym] || flash_type.to_s
  end

  def flash_messages
    flash.map do |msg_type, message|
      content_tag(:div, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show", role: "alert") do
        safe_join([
          content_tag(:button, '', class: "btn-close", data: { bs_dismiss: 'alert' }),
          message
        ])
      end
    end.join.html_safe
  end
end
