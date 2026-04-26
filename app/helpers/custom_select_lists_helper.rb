module CustomSelectListsHelper
  def get_model_name_associations
    model_names_list = {
      social_ecological_characterization: I18n.t("activerecord.models.social_ecological_characterization.others")
    }
    model_names_list.map { |key, value| [ value, key.to_sym ] }
  end
end
