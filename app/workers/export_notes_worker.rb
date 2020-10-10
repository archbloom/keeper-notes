require 'csv'

class ExportNotesWorker
  include Sidekiq::Worker
  def perform(user_id)
    headers = ['ID', 'Title', 'Content', 'Reader', 'Collaborator']

    export_file = "#{Rails.root}/public/#{user_id}/export_#{DateTime.now.to_i * user_id}.csv"

    user = User.find(user_id)
    notes = user.notes
    CSV.open(export_file, 'w', write_headers: true, headers: headers) do |csv|
      notes.each do |note|
        csv << [note.id, note.title, note.content, note.readers, note.collaborators]
      end
    end

    ExportFileDeletionWorker.perform_in(24.hours, export_file)
  end
end
