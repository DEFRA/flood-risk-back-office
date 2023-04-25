module Admin
  class UsersController < ::ApplicationController
    before_action :find_user, only: %i[edit update disable enable]

    def index
      authorize User

      @users = User.where(disabled_at: nil).order(:email).page(params[:page])
    end

    def all
      authorize User

      @users = User.all.order(:email).page(params[:page])

      @show_all_users = true
      render :index
    end

    def edit
      @user.assigned_role = @user.roles.first&.name
    end

    def edit_disable
      @user = User.find params[:user_id]
      authorize @user, :disable?
    end

    def edit_enable
      @user = User.find params[:user_id]
      authorize @user, :enable?
    end

    def disable
      comment = params[:user][:disabled_comment] if params[:user]

      if @user.disable(comment)
        flash[:updated_user_id] = @user.id
        redirect_to admin_users_path, notice: t("user_disabled_success", name: @user.email)
      else
        render :edit_disable
      end
    end

    def enable
      flash[:updated_user_id] = @user.id
      @user.enable!
      redirect_to admin_users_path, notice: t("user_enabled_success", name: @user.email)
    end

    # TODO: refactor!
    # rubocop:disable Metrics/PerceivedComplexity
    def update
      @user.assign_attributes params.require(:user).permit(:assigned_role)

      # Editting the current user's role is prohibited - this can lead to unwanted access problems
      unless @user == current_user
        if @user.assigned_role.blank?
          @user.errors.add :assigned_role, :blank
        elsif !@user.assigned_role.in? I18n.t("allowed_roles").stringify_keys.keys
          @user.errors.add :assigned_role, :inclusion
        end
      end

      if @user.errors.empty?
        if @user.assigned_role.present? && @user != current_user
          @user.roles = []
          @user.add_role @user.assigned_role
        end

        flash[:updated_user_id] = @user.id
        redirect_to admin_users_path, notice: I18n.t("user_update_success", name: @user.email)
      else
        render :edit
      end
    end
    # rubocop:enable Metrics/PerceivedComplexity

    private

    def find_user
      @user = User.find(params[:id] || params[:user_id])
      authorize @user
    end
  end
end
