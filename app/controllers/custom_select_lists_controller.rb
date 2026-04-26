class CustomSelectListsController < ApplicationController
  before_action :set_custom_select_list, only: %i[edit update destroy]

  def index
    @custom_select_lists = CustomSelectList.ordered
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
    if @custom_select_list.destroy
      respond_to do |format|
        format.html { redirect_to custom_select_lists_path, notice: "Lista de selección personalizada eliminada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Lista de selección personalizada eliminada exitosamente." }
      end
    else
      redirect_to custom_select_lists_path, alert: "No se pudo eliminar la lista de selección personalizada."
    end
  end

  private

  def custom_select_list_params
    params.require(:custom_select_list).permit(:model_name_association, :status)
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.find(params[:id])
  end
end
