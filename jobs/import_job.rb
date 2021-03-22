class ImportJob < ApplicationJob
  queue_as :default
  include OldAppCsvImport

  def perform(*args)
    # Do something later
  end
end