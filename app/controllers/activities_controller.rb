class ActivitiesController < ApplicationController
  before_action :set_monthly_report
  before_action :set_activity, only: [ :edit, :update, :destroy ]
  before_action :set_custom_select_list
  def new
    @activity = @monthly_report.activities.new
    @activity.custom_select_list = @custom_select_list
  end

  def create
    @activity = @monthly_report.activities.build(activity_params)
    @activity.custom_select_list = @custom_select_list
    if @activity.save
      respond_to do |format|
        format.html { redirect_to monthly_report_path(@monthly_report), notice: "Actividad creada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Actividad creada exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @activity.update(activity_params)
      respond_to do |format|
        format.html { redirect_to monthly_report_path(@monthly_report), notice: "Actividad actualizada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Actividad actualizada exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @activity.destroy
      respond_to do |format|
        format.html { redirect_to monthly_report_path(@monthly_report), notice: "Actividad eliminada exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Actividad eliminada exitosamente." }
      end
    end
  end

  private

  def set_activity
    @activity = @monthly_report.activities.find(params[:id])
  end

  def set_monthly_report
    @monthly_report = current_user.monthly_reports.find(params[:monthly_report_id])
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: Activity.name.underscore)
  end

  def activity_params
    params.require(:activity).permit(:project, :associated_objective, :activity_name, :description, :start_date, :end_date, :status)
  end
end
