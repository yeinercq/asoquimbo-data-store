module ApplicationHelper
  def form_error_notification(object)
    if object.errors.any?
      tag.div class: "alert alert-danger alert-dismissible fade show", role: "alert" do
        I18n.t("common.form.error_message") + object.errors.full_messages.to_sentence.capitalize
      end
    end
  end

  def enum_options_for_select(model, enum, selected = nil)
    model.send(enum.to_s).map { |key, _| [ key.to_s.humanize, key ] }
  end

  def render_turbo_stream_flash_messages
    turbo_stream.prepend "flash_notifications", partial: "layouts/flash_notifications"
  end
end
