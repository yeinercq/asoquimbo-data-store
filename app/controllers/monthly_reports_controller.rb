class MonthlyReportsController < ApplicationController
  before_action :set_custom_select_list, except: %i[destroy]
  before_action :set_monthly_report, only: %i[show edit update destroy]
  def index
    helpers.custom_select_custom_options_validation(MonthlyReport)
    @monthly_reports = current_user.monthly_reports.includes(:user).ordered
  end

  def show
  end

  def new
    @monthly_report = current_user.monthly_reports.new
    @monthly_report.custom_select_list = @custom_select_list
  end

  def create
    @monthly_report = current_user.monthly_reports.build(monthly_report_params)
    @monthly_report.custom_select_list = @custom_select_list
    if @monthly_report.save
      respond_to do |format|
        format.html { redirect_to monthly_reports_path, notice: "Informe mensual creado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Informe mensual creado exitosamente." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @monthly_report.update(monthly_report_params)
      respond_to do |format|
        format.html { redirect_to monthly_reports_path, notice: "Informe mensual creado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Informe mensual actualizado exitosamente." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @monthly_report.destroy
      respond_to do |format|
        format.html { redirect_to monthly_reports_path, notice: "Informe mensual eliminado exitosamente." }
        format.turbo_stream
      end
    end
  end

  private

  def set_monthly_report
    @monthly_report = MonthlyReport.find(params[:id])
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: MonthlyReport.name.underscore)
  end

  def monthly_report_params
    params.require(:monthly_report).permit(:date_period, :component)
  end
end
