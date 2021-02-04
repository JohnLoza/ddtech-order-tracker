module Admin
  class SuppliersController < AdminController
    before_action :load_suppliers, only: :index
    load_and_authorize_resource

    def index; end

    def new; end

    def create
      if @supplier.save
        flash[:success] = t('.success')
        redirect_to new_admin_supplier_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @supplier.update(supplier_params)
        flash[:success] = t('.success')
        redirect_to admin_suppliers_path
        return
      end

      render :edit
    end

    def destroy
      if @supplier.destroy
        flash[:success] = t('.success')
      else
        flash[:warning] = t('.failure')
      end

      redirect_to admin_suppliers_path
    end

    private
    def load_suppliers
      @pagy, @suppliers = pagy(Supplier.active)
    end

    def supplier_params
      params.require(:supplier).permit(:name)
    end
  end
end
