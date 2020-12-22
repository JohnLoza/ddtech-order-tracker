# frozen_string_literal: true

module Admin
  # Admin Tags Controller
  class TagsController < AdminController
    before_action :load_tags, only: :index
    load_and_authorize_resource

    def index; end

    def new; end

    def create
      if @tag.save
        redirect_to admin_tags_path, flash: { success: t('.success', tag: @tag) }
      else
        render :new
      end
    end

    def edit; end

    def update
      if @tag.update tag_params
        redirect_to admin_tags_path, flash: { success: t('.success', tag: @tag) }
      else
        render :edit
      end
    end

    def destroy
      if @tag.destroy
        flash[:success] = t('.success', tag: @tag)
      else
        flash[:info] = t('.failure', tag: @tag)
      end
      redirect_to admin_tags_path
    end

    private

    def tag_params
      params.require(:tag).permit(:name, :css_class)
    end

    def load_tags
      @pagy, @tags = pagy(Tag.all)
    end
  end
end

