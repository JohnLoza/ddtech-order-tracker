# frozen_string_literal: true

module Admin
  # Admin Notes Controller
  class NotesController < AdminController
    before_action :set_new_note, only: :create

    load_and_authorize_resource

    def create
      if @note.save
        respond_to do |format|
          format.js { render json: {
              data: @note,
              template: render_to_string(@note)
            }
          }
          format.any { head :forbidden, content_type: 'text/html' }
        end
      else
        respond_to do |format|
          format.js { render status: 400, json: @note.errors.as_json }
          format.any { head :forbidden, content_type: 'text/html' }
        end
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
