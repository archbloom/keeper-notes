class ExportFileDeletionWorker
  include Sidekiq::Worker
  def perform(path_to_file)
    File.delete(path_to_file) if File.exist?(path_to_file)
  end
end
