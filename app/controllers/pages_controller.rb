class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :landing, :data_bases_index, :data_base_record_detail ]
  before_action :set_custom_select_list, only: [ :data_bases_index, :data_base_record_detail ]

  def home
  end

  def landing
  end

  def data_bases_index
    scope = DataBaseRecord.includes(:user).ordered
    # Apply filters based on query parameters
    filtering_record_params(params).each do | key, value |
      scope = scope.public_send("filter_by_#{key}", value) if value.present?
    end

    @data_base_records = scope
    respond_to do |format|
      format.html
    end
  end

  def data_base_record_detail
    @data_base_record = DataBaseRecord.find(params[:id])
  end

  def filtering_record_params(params)
    params.slice(:document_family, :geographic_area, :access_level, :territorial_scale, :record_type, :year)
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: DataBaseRecord.name.underscore)
  end
end
