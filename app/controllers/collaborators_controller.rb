class CollaboratorsController < ApplicationController
  before_action :set_collaborator, only: [ :edit, :update, :destroy ]
  load_and_authorize_resource :user
  def index
    @collaborators = User.ordered_by_name
  end

  def new
    @collaborator = User.new
  end

  def create
    @collaborator = User.build(user_params)
    if @collaborator.save
      respond_to do |format|
        format.html { redirect_to collaborators_path, notice: "Colaborador creado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Colaborador creado exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @collaborator.update(user_params)
      respond_to do |format|
        format.html { redirect_to collaborators_path, notice: "Colaborador editado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Colaborador editado exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_collaborator
    @collaborator = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :role)
  end
end
