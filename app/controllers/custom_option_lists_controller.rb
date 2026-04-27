class CustomOptionListsController < ApplicationController
  before_action :set_custom_select_list
  before_action :set_custom_option_list, only: %i[edit update destroy]

  def new
    @custom_option_list = @custom_select_list.custom_option_lists.new
    @custom_option_list.custom_options.build
  end

  def create
    @custom_option_list = @custom_select_list.custom_option_lists.build(custom_option_list_params)
    if @custom_option_list.save
      respond_to do |format|
        format.html { redirect_to custom_select_lists_path, notice: "Opción de lista configurable creada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Opción de lista configurable creada exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @custom_option_list.update(custom_option_list_params)
      respond_to do |format|
        format.html { redirect_to custom_select_lists_path, notice: "Opción de lista configurable actualizada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Opción de lista configurable actualizada exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @custom_option_list.destroy
      respond_to do |format|
        format.html { redirect_to custom_select_lists_path, notice: "Opción de lista configurable eliminada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Opción de lista configurable eliminada exitosamente." }
      end
    else
      redirect_to custom_select_lists_path, alert: "No se pudo eliminar la opción de lista configurable."
    end
  end

  private

  def custom_option_list_params
    params.require(:custom_option_list).permit(:model_field, custom_options_attributes: [ :id, :name, :_destroy ])
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.find(params[:custom_select_list_id])
  end

  def set_custom_option_list
    @custom_option_list = @custom_select_list.custom_option_lists.find(params[:id])
  end
end
