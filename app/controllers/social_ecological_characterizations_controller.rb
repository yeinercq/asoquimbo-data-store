class SocialEcologicalCharacterizationsController < ApplicationController
  def index
    @social_ecological_characterizations = SocialEcologicalCharacterization.all
  end

  def show
  end

  def new
    @social_ecological_characterization = SocialEcologicalCharacterization.new
  end

  def create
    @social_ecological_characterization = SocialEcologicalCharacterization.new(social_ecological_characterization_params)
    if @social_ecological_characterization.save
      redirect_to social_ecological_characterizations_path, notice: "Caracterización social y ecológica creada exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def import_csv
  end

  private

  def social_ecological_characterization_params
    params.require(:social_ecological_characterization).permit(:authors, :year, :title, :resource_type, :institution, :url, :access_level, :geographic_area, :spatial_coverage, :analysis_scale, :study_period, :study_objective, :approach, :general_methodology_used)
  end
end
