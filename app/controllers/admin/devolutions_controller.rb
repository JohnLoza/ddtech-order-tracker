# frozen_string_literal: true

module Admin
  # Admin Devolutions Controller
  class DevolutionsController < AdminController
    before_action :load_devolutions, only: :index
    load_and_authorize_resource

    def index; end

    def show; end

    def new; end

    def create
      if @devolution.save
        redirect_to admin_devolutions_path, flash: { success: t('.success', devolution: @devolution) }
      else
        render :new
      end
    end

    def edit; end

    def update
      if @devolution.update_attributes devolution_params
        redirect_to admin_devolutions_path, flash: { success: t('.success', devolution: @devolution) }
      else
        render :edit
      end
    end

    def destroy
      if @devolution.destroy
        flash[:success] = t('.success', devolution: @devolution)
      else
        flash[:info] = t('.failure', devolution: @devolution)
      end
      redirect_to admin_devolutions_path
    end

    private

    def devolution_params
      params.require(:devolution).permit(
        :client_name,
        :email,
        :telephone,
        :client_type,
        :order_id,
        :products,
        :description,
        :devolution_address,
        :comments
      )
    end

    def load_devolutions
      @pagy, @devolutions = pagy(Devolution.all.recent)
    end
  end
end

