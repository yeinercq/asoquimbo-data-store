module CustomOptionListsHelper
  def get_available_model_fields
    [] unless @custom_select_list

    model_name_association = @custom_select_list.model_name_association
    used_fields = @custom_select_list.custom_option_lists.pluck(:model_field).map(&:to_sym)
    option_listable_fields = model_name_association.camelize.constantize.option_listable_fields - used_fields
    options = option_listable_fields.map { |field| [ I18n.t("activerecord.attributes.#{model_name_association}.#{field}"), field ] }

    if @custom_option_list.persisted?
      options << [ I18n.t("activerecord.attributes.#{model_name_association}.#{@custom_option_list.model_field}"), @custom_option_list.model_field ]
    end

    options
  end
end
