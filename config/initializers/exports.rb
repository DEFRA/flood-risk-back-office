
export_directory = Rails.root.join("private", "exports")

FileUtils.mkdir_p(export_directory) unless File.directory?(export_directory)
