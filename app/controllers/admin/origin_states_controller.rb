module Admin
  class OriginStatesController < AdminController
    before_action :load_origin_states, only: :index
    load_and_authorize_resource

    def index; end

    def edit; end

    def update
      if @origin_state.update(origin_state_params)
        flash[:success] = t('.success')
        redirect_to admin_origin_states_path
      else
        render :edit
      end
    end

    private
    def origin_state_params
      params.require(:origin_state).permit(:estimated_shipment_days)
    end

    def load_origin_states
      @origin_states = OriginState.all
    end
  end
end
