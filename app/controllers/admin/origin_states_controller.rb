module Admin
  class OriginStatesController < AdminController
    before_action :load_origin_states, only: :index
    load_and_authorize_resource

    def index; end

    def new; end

    def create
      if @origin_state.save
        flash[:success] = t('.success')
        redirect_to admin_origin_states_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @origin_state.update(origin_state_params)
        flash[:success] = t('.success')
        redirect_to admin_origin_states_path
      else
        render :edit
      end
    end

    def destroy
      if @origin_state.destroy
        flash[:success] = t('.success')
      else
        flash[:warning] = r('.failure')
      end

      redirect_to admin_origin_states_path
    end

    private
    def origin_state_params
      params.require(:origin_state).permit(:name, :estimated_shipment_days)
    end

    def load_origin_states
      @origin_states = OriginState.active.order(name: :asc)
    end
  end
end
