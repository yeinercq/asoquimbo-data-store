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
    respond_to do |format|
      if @custom_option_list.valid?(:is_destroyed)
        if @custom_option_list.destroy
          format.html { redirect_to custom_select_lists_path, notice: "Opción de lista configurable eliminada exitosamente." }
          format.turbo_stream { flash.now[:notice] = "Opción de lista configurable eliminada exitosamente." }
        else
          redirect_to custom_select_lists_path, alert: "No se pudo eliminar la opción de lista configurable."
        end
      else
        format.html { redirect_to custom_select_lists_path, alert: @custom_option_list.errors.full_messages.to_sentence }
        format.turbo_stream do
          flash.now[:alert] = @custom_option_list.errors.full_messages.to_sentence
          render turbo_stream: turbo_stream.prepend("flash_notifications", partial: "layouts/flash_notifications")
        end
      end
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
