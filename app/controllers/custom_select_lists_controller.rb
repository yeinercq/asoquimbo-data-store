require "csv"

class CustomSelectListsController < ApplicationController
  before_action :set_custom_select_list, only: %i[edit update destroy]

  def index
    @custom_select_lists = CustomSelectList.includes(:custom_option_lists).ordered
    respond_to do |format|
      format.html
      format.csv { send_data generate_csv(@custom_select_lists), filename: "listas-de-seleccion-configurables-#{Date.today}.csv" }
    end
  end

  def new
    @custom_select_list = CustomSelectList.new
  end

  def create
    @custom_select_list = CustomSelectList.new(custom_select_list_params)
    if @custom_select_list.save
      respond_to do |format|
        format.html { redirect_to custom_select_lists_path, notice: "Lista de selección personalizada creada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Lista de selección personalizada creada exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
    respond_to do |format|
      if @custom_select_list.valid?(:is_destroyed)
        if @custom_select_list.destroy
          format.html { redirect_to custom_select_lists_path, notice: "Lista de selección personalizada eliminada exitosamente." }
          format.turbo_stream { flash.now[:notice] = "Lista de selección personalizada eliminada exitosamente." }
        else
          redirect_to custom_select_lists_path, alert: "No se pudo eliminar la lista de selección personalizada."
        end
      else
        format.html { redirect_to custom_select_lists_path, alert: @custom_select_list.errors.full_messages.to_sentence }
        format.turbo_stream do
          flash.now[:alert] = @custom_select_list.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.prepend("flash_notifications", partial: "layouts/flash_notifications")
        end
      end
    end
  end

  def import_form
  end

  def import_file
    file = params[:file]
    respond_to do |format|
      if file.present?
        result, message = ImportFileService.new(file, CustomSelectList).call
        if result
          @custom_select_lists = CustomSelectList.includes(:custom_option_lists).ordered
          format.html { redirect_to custom_select_lists_path, notice: "Archivo importado exitosamente: #{message}" }
          format.turbo_stream { flash.now[:notice] = "Archivo importado exitosamente: #{message}" }
        else
          @custom_select_lists = CustomSelectList.includes(:custom_option_lists).ordered
          format.html { redirect_to custom_select_lists_path, alert: "Error al importar el archivo: #{message}}" }
          format.turbo_stream { flash.now[:notice] = "Error al importar el archivo: #{message}" }
        end
      else
        @custom_select_lists = CustomSelectList.includes(:custom_option_lists).ordered
        format.html { redirect_to custom_select_lists_path, alert: "Por favor, seleccione un archivo para importar." }
        format.turbo_stream { flash.now[:notice] = "Por favor, seleccione un archivo para importar" }
      end
    end
  end

  private

  def custom_select_list_params
    params.require(:custom_select_list).permit(:model_name_association)
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.find(params[:id])
  end

  def generate_csv(collection)
    CSV.generate(headers: true) do |csv|
      csv << %w[model_name_association model_field name id]

      collection.where(model_name_association: "data_base_record").each do |custom_select_list|
        custom_select_list.custom_option_lists.each do |custom_option_list|
          custom_option_list.custom_options.each do |custom_option|
            csv << [ I18n.t("activerecord.models.#{custom_select_list.model_name_association}.one"), I18n.t("activerecord.attributes.#{custom_select_list.model_name_association}.#{custom_option_list.model_field}"), custom_option.name, custom_option.id ]
          end
        end
      end
    end
  end
end
