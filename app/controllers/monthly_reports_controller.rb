class MonthlyReportsController < ApplicationController
  before_action :set_custom_select_list, except: %i[destroy]
  before_action :set_monthly_report, only: %i[show edit update destroy trigger_status legal_documents_list add_legal_documents save_legal_documents destroy_legal_document export_pdf]
  load_and_authorize_resource :monthly_report
  # load_and_authorize_resource :activity, through: :monthly_report

  def index
    helpers.custom_select_custom_options_validation(MonthlyReport)
    # helpers.custom_select_custom_options_validation(Activity)

    if current_user.role.in? [ "admin", "director", "coordinator", "inspector" ]
      scope = MonthlyReport.includes(:user).ordered
    else
      scope = current_user.monthly_reports.includes(:user).ordered
    end

    # Apply filters based on query parameters
    filtering_params(params).each do | key, value |
      scope = scope.public_send("filter_by_#{key}", value) if value.present?
    end

    @monthly_reports = scope
    respond_to do |format|
      format.html
      format.turbo_stream
    end
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

  def trigger_status
    event = params[:event] # event es un string
    status, message = MonthlyReports::TriggerEventService.new.call(@monthly_report, event, current_user)
    respond_to do |format|
      if status
        format.html { redirect_to @monthly_report, flash[:notice] = message }
        format.turbo_stream { flash.now[:notice] = message }
      else
        format.html { redirect_to @monthly_report, flash[:alert] = message }
        format.turbo_stream { flash.now[:alert] = message }
      end
    end
  end

  def legal_documents_list
  end

  def add_legal_documents
  end

  def destroy_legal_document
    legal_document_identifier = params[:legal_document_identifier]
    legal_document = @monthly_report.legal_documents.find { |f| f.identifier == legal_document_identifier }
    if legal_document
      new_legal_documents = @monthly_report.legal_documents.reject { |f| f.identifier == legal_document_identifier }
      @monthly_report.legal_documents = new_legal_documents
      legal_document.remove!
      @monthly_report.save
      respond_to do |format|
        format.html { redirect_to monthly_report_path(@monthly_report), notice: "Documento parafiscal eliminado exitosamente." }
        format.turbo_stream { flash.now[:notice] = "Documento parafiscal eliminado exitosamente." }
      end
    else
      respond_to do |format|
        format.html { redirect_to monthly_report_path(@monthly_report), alert: "Documento parafiscal no encontrado." }
        format.turbo_stream { flash.now[:alert] = "Documento parafiscal no encontrado." }
      end
    end
  end

  def save_legal_documents
    if @monthly_report.update(monthly_report_params)
      respond_to do |format|
        format.html { redirect_to monthly_report_path(@monthly_report), notice: "Documentos parafiscales subidos exitósamente." }
        format.turbo_stream { flash.now[:notice] = "Documentos parafiscales subidos exitósamente." }
      end
    else
      render :add_legal_documents, status: :unprocessable_entity
    end
  end

  def export_pdf
    # authorize! :read, @monthly_report

    respond_to do |format|
      format.pdf do
        render pdf: "informe_mensual_#{@monthly_report.user.name.underscore}_#{ l @monthly_report.date_period, format: ('%B_%Y')}",
               template: "monthly_reports/export_pdf",
               layout: "pdf",
               page_size: "A4",
               orientation: "Landscape",
               margin: { top: 10, bottom: 10, left: 15, right: 15 }
      end
    end
  end

  private

  def set_monthly_report
    @monthly_report = MonthlyReport.includes(:activities).find(params[:id])
  end

  def set_custom_select_list
    @custom_select_list = CustomSelectList.includes(custom_option_lists: :custom_options).find_by(model_name_association: MonthlyReport.name.underscore)
  end

  def monthly_report_params
    params.require(:monthly_report).permit(:date_period, :component, { legal_documents: [] })
  end

  def filtering_params(params)
    params.slice(:user_id, :component)
  end
end
