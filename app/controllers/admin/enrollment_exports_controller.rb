module Admin
  class EnrollmentExportsController < ApplicationController
    def index
      authorize EnrollmentExport

      @enrollment_export = EnrollmentExport.new(to_date: Date.today)

      find_exports

      render :index
    end

    def show
      export = EnrollmentExport.completed.find(params[:id])

      authorize export

      respond_to do |format|
        format.csv do
          # Don't really like this if but not sure how to extend service object with send_data and/or redirect_to,
          # include ActionController::DataStreaming does not do it
          if ENV["EXPORT_USE_FILESYSTEM_NOT_AWS_S3"]
            send_data ReadEnrollmentExportReport.run(export), type: "text/plain", filename: export.full_path.to_s
          else
            redirect_to ReadEnrollmentExportReport.run(export), allow_other_host: true
          end
        end
      end
    end

    def create
      authorize EnrollmentExport

      @enrollment_export = EnrollmentExport.new(enrollment_export_params)
      @enrollment_export.populate_file_name

      if @enrollment_export.save
        flash[:created_export_id] = @enrollment_export.id

        EnrollmentExportJob.perform_later(@enrollment_export)

        redirect_to admin_enrollment_exports_path, notice: flash_notice
      else
        find_exports
        render :index
      end
    end

    private

    def find_exports
      @exports = policy_scope(EnrollmentExport).order(created_at: :desc).page(params[:page])
    end

    def enrollment_export_params
      params.require(:enrollment_export).permit(
        :from_date, :to_date, :date_field_scope
      ).merge(created_by: current_user.email)
    end

    def flash_notice
      t("enrollment_export_requested", criteria: @enrollment_export.to_s)
    end
  end
end
