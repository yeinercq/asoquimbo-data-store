class CollaboratorsController < ApplicationController
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
        format.html { redirect_to collaborators_path, notice: "Collaborador creado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Collaborador creado exitosamente." }
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
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :role)
  end
end
