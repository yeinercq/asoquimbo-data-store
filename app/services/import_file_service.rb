class ImportFileService
  require "csv"

  def initialize(file, model_name, current_user)
    @file = file
    @model_name = model_name
    @current_user = current_user
  end

  def call
    return [ false, "El archivo está vacío" ] if @file.blank? || @file.size.zero?

    rows_read = 0
    if @model_name == CustomSelectList
      CustomSelectList.transaction do
        CSV.foreach(@file.path, headers: true, encoding: "bom|utf-8", col_sep: ";") do |row|
          data = row.to_h
          rows_read += 1
          custom_select_list = CustomSelectList.find_or_create_by(model_name_association: data["model_name_association"])
          custom_option_list = custom_select_list.custom_option_lists.find_or_create_by(model_field: data["model_field"])
          custom_option = custom_option_list.custom_options.build(name: data["name"])
          custom_option.save!
        end
      end
      [ true, "Se importaron #{rows_read} opciones." ]
    elsif @model_name == DataBaseRecord
      # quote_chars = %w[" | ~ ^ & *]
      DataBaseRecord.transaction do
        CSV.foreach(@file.path, headers: true, encoding: "bom|utf-8", col_sep: "=") do |row|
          data = row.to_h
          data.store("user_id", @current_user.id)
          rows_read += 1

          data_base_record = DataBaseRecord.new(data)
          data_base_record.save!
        end
      end
      [ true, "Se importaron #{rows_read} opciones." ]
    else
      [ false, "No se reconoce el tipo de importacion" ]
    end
  rescue CSV::MalformedCSVError => e
    [ false, "El CSV no tiene un formato válido: #{e.message}" ]
  rescue StandardError => e
    [ false, "Error al importar el archivo, en la linea #{rows_read}: #{e.message}" ]
  end
end
