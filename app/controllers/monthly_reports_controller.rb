class MonthlyReportsController < ApplicationController
  before_action :set_custom_select_list, except: %i[destroy]
  def index
    @monthly_report = MonthlyReport.includes(:user).ordered
  end

  def show
  end

  def new
    @monthly_report = current_user.monthly_reports.new
  end

  def create
    @monthly_report = current_user.monthly_reports.build(monthly_report_params)
    if @monthly_report.save
      redirect_to monthly_reports_path, notice: "Informe mensual creado exitosamente."
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
  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: MonthlyReport.name.underscore)
  end

  def monthly_report_params
    params.require(:monthly_report).permit(:date_period, :component)
  end
end
