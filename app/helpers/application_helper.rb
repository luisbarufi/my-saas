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
      content_tag(:div, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible fade show auto-dismiss", role: "alert") do
        safe_join([
          content_tag(:button, '', class: "btn-close", data: { bs_dismiss: 'alert' }),
          message
        ])
      end
    end.join.html_safe
  end

  def mount_breadcrumb(items)
    safe_join(
      items.each_with_index.map do |(name, path), index|
        is_last = index == items.size - 1
        classes = "breadcrumb-item#{' active' if is_last}"

        content_tag(:li, is_last ? name : link_to(name, path), class: classes, aria: (is_last ? { current: 'page' } : {}))
      end
    )
  end
end
