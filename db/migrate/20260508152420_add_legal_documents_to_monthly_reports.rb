class AddLegalDocumentsToMonthlyReports < ActiveRecord::Migration[7.2]
  def change
    add_column :monthly_reports, :legal_documents, :json
  end
end
