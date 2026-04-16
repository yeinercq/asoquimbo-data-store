class SocialEcologicalCharacterizationsController < ApplicationController
  before_action :set_social_ecological_characterization, only: %i[show edit update destroy]
  def index
    @social_ecological_characterizations = SocialEcologicalCharacterization.all.ordered
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
end
