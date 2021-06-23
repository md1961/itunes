module BooleanMethodDefiner

  def self.included(model)
    model.content_columns.map(&:name).find_all { |column_name|
      column_name.starts_with?('is_')
    }.each do |column_name|
      method_name = "#{column_name.sub(/\Ais_/, '')}?"
      define_method method_name do
        send(column_name)
      end
    end
  end
end
