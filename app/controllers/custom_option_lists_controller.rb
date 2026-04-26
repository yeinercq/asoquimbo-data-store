class CustomOptionListsController < ApplicationController
  before_action :set_custom_select_list

  def new
    @custom_option_list = @custom_select_list.custom_option_lists.new
  end

  def create
    @custom_option_list = @custom_select_list.custom_option_lists.build(custom_option_list_params)
    if @custom_option_list.save
      redirect_to custom_select_lists_path, notice: "Lista de opciones creada exitosamente."
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

  private

  def custom_option_list_params
    params.require(:custom_option_list).permit(:model_field)
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.find(params[:custom_select_list_id])
  end
end
