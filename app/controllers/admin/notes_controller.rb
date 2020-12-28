# frozen_string_literal: true

module Admin
  # Admin Notes Controller
  class NotesController < AdminController
    before_action :set_new_note, only: :create

    load_and_authorize_resource

    def create
      if @note.save
        render json: { data: @note.as_json, template: render_to_string(@note) }
      else
        render status: 400, json: { data: @note.errors.as_json }
      end
    end

    private

    def set_new_note
      @order = Order.find(params[:order_id])
      @note = @order.notes.build(note_params)
    end

    def note_params
      params.require(:note).permit(:message, :user_id)
    end
  end
end
