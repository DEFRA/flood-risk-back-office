module Admin
  class EnrollmentExportsController < ApplicationController
    def index
      authorize EnrollmentExport

      form = form_factory

      find_exports

      render :index, locals: { form: form }
    end

    def create
      authorize EnrollmentExport

      form = form_factory

      if form.validate(params) && form.save
        flash[:created_export_id] = form.model.id

        EnrollmentExportJob.perform_later(form.model)

        redirect_to admin_enrollment_exports_path, notice: t("enrollment_export_requested", criteria: form.model.to_s)
      else
        find_exports
        render :index, locals: { form: form }
      end
    end

    def show
      export = EnrollmentExport.completed.find_by!(id: params[:id])

      authorize export

      respond_to do |format|
        format.csv do
          send_data ReadEnrollmentExportReport.new(export).call, type: "text/plain", filename: export.full_path
        end
      end
    end

    private

    def form_factory
      # Form does not have access to current user
      export = EnrollmentExport.new do |ee|
        ee.created_by = current_user.email
      end

      Enrollment::ExportForm.new(export)
    end

    def find_exports
      @exports = policy_scope(EnrollmentExport).order(created_at: :desc).page(params[:page])
    end

  end
end
