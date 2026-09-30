class DataBaseRecordsController < ApplicationController
  before_action :set_data_base_record, only: %i[show edit update destroy]
  before_action :set_custom_select_list, except: %i[destroy]
  def index
    helpers.custom_select_custom_options_validation(DataBaseRecord)

    scope = DataBaseRecord.includes(:user).ordered
    # Apply filters based on query parameters
    filtering_params(params).each do | key, value |
      scope = scope.public_send("filter_by_#{key}", value) if value.present?
    end

    @data_base_records = scope
    respond_to do |format|
      format.html
      format.turbo_stream
      format.csv { send_data generate_csv(@data_base_records), filename: "registro-base-de-datos-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @data_base_record = current_user.data_base_records.build
    @data_base_record.custom_select_list = @custom_select_list
  end

  def create
    @data_base_record = current_user.data_base_records.build(data_base_record_params)
    @data_base_record.custom_select_list = @custom_select_list

    if @data_base_record.save
      respond_to do |format|
        format.html { redirect_to data_base_redors_path, notice: "Registro de base de datos creado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Registro de base de datos creado exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @data_base_record.update(data_base_record_params)
      respond_to do |format|
        format.html { redirect_to data_base_records_path, notice: "Registro de base de datos actualizado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Registro de base de datos actualizado exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @data_base_record.destroy
    respond_to do |format|
      format.html { redirect_to data_base_records_path, notice: "Registro de base de datos eliminado exitosamente." }
      format.turbo_stream { flash.now[:notice] = "Registro de base de datos eliminado exitosamente." }
    end
  end

  def import_form
  end

  def import_file
    file = params[:file]
    if file.present?
      # result = SocialEcologicalCharacterizationImportService.new(file).call
      # if result[:success]
      #   redirect_to social_ecological_characterizations_path, notice: "Archivo importado exitosamente. #{result[:imported_count]} registros importados."
      # else
      #   redirect_to social_ecological_characterizations_path, alert: "Error al importar el archivo: #{result[:error]}"
      # end
    else
      redirect_to social_ecological_characterizations_path, alert: "Por favor, seleccione un archivo para importar."
    end
  end

  private

  def data_base_record_params
    params.require(:data_base_record).permit(
      :ecological_component,
      :document_title,
      :authors,
      :year,
      :document_type,
      :document_family,
      :institutions_entities,
      :apa_citation,
      :geographic_area,
      :specific_geographic_area,
      :access_level,
      :taken_from,
      :documental_comment,
      :spatial_coverage,
      :analysis_scale,
      :territorial_scale,
      :study_period,
      :study_goal,
      :focus_families,
      :approach,
      :methodology,
      :record_type,
      :source_file
    )
  end

  def set_data_base_record
    @data_base_record = DataBaseRecord.includes(:user).find(params[:id])
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: DataBaseRecord.name.underscore)
  end

  def filtering_params(params)
    params.slice(:document_family, :geographic_area, :access_level, :territorial_scale, :record_type)
  end

  def generate_csv(collection)
    attributes =  DataBaseRecord.attribute_names.select { |attr| [ "source_file", "created_at", "updated_at" ].exclude? attr }
    CSV.generate(headers: true) do |csv|
      csv << attributes

      collection.find_each do |record|
        csv << attributes.map { |attr| record.send(attr) }
      end
    end
  end
end
