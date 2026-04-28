class SocialEcologicalCharacterizationsController < ApplicationController
  before_action :set_social_ecological_characterization, only: %i[show edit update destroy]
  before_action :set_custom_select_list, only: %i[show]

  require "csv"
  def index
    # Check if the custom select list exists and if all option listable fields have their options defined
    custom_select_list = CustomSelectList.find_by(model_name_association: SocialEcologicalCharacterization.name.underscore)
    if custom_select_list.blank?
      flash.now[:notice] = "No hay una lista de selección definida para estas caracterizaciones. Por favor, revisa la opción de Listas de seleccion."
    elsif SocialEcologicalCharacterization.option_listable_fields.map(&:to_s).any? { |field| custom_select_list.custom_option_lists.pluck(:model_field).exclude? field }
      flash.now[:notice] = "Hay campos que aún no tinen sus opciones definidas en estas caracterizaciones. Por favor, revisa la opción de Listas de seleccion."
    end

    scope = SocialEcologicalCharacterization.includes(:user).ordered
    # Apply filters based on query parameters
    filtering_params(params).each do | key, value |
      scope = scope.public_send("filter_by_#{key}", value) if value.present?
    end

    @social_ecological_characterizations = scope
    respond_to do |format|
      format.html
      format.turbo_stream
      format.csv { send_data generate_csv(@social_ecological_characterizations), filename: "caracterizaciones-sociales-y-ecologicas-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @social_ecological_characterization = current_user.social_ecological_characterizations.build
  end

  def create
    @social_ecological_characterization = current_user.social_ecological_characterizations.build(social_ecological_characterization_params)
    respond_to do |format|
      if @social_ecological_characterization.save
        format.html { redirect_to social_ecological_characterizations_path, notice: "Caracterización social y ecológica creada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Caracterización social y ecológica creada exitosamente." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @social_ecological_characterization.update(social_ecological_characterization_params)
        format.html { redirect_to social_ecological_characterizations_path, notice: "Caracterización social y ecológica actualizada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Caracterización social y ecológica actualizada exitosamente." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @social_ecological_characterization.destroy
    respond_to do |format|
      format.html { redirect_to social_ecological_characterizations_path, notice: "Caracterización social y ecológica eliminada exitosamente." }
      format.turbo_stream { flash.now[:notice] = "Caracterización social y ecológica eliminada exitosamente." }
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

  def social_ecological_characterization_params
    params.require(:social_ecological_characterization).permit(:authors, :year, :title, :resource_type, :institution, :url, :access_level, :geographic_area, :spatial_coverage, :analysis_scale, :study_period, :study_objective, :approach, :general_methodology_used, :source_file)
  end

  def set_social_ecological_characterization
    @social_ecological_characterization = SocialEcologicalCharacterization.includes(:user).find(params[:id])
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: SocialEcologicalCharacterization.name.underscore)
  end

  def filtering_params(params)
    params.slice(:resource_type, :access_level, :geographic_area, :spatial_coverage, :analysis_scale, :approach)
  end

  def generate_csv(collection)
    attributes = %w[id authors year title resource_type institution url access_level geographic_area spatial_coverage analysis_scale study_period study_objective approach general_methodology_used]
    CSV.generate(headers: true) do |csv|
      csv << attributes

      collection.find_each do |characterization|
        csv << attributes.map { |attr| characterization.send(attr) }
      end
    end
  end
end
