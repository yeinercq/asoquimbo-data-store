module ApplicationHelper
  def form_error_notification(object)
    if object.errors.any?
      tag.div class: "alert alert-danger alert-dismissible fade show", role: "alert" do
        t("common.form.error_message") + object.errors.full_messages.to_sentence.capitalize
      end
    end
  end
end
