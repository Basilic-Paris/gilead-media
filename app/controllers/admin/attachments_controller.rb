module Admin
  class AttachmentsController < ApplicationController
    skip_after_action :verify_authorized, only: :destroy
    before_action :find_document, :find_attachment, only: %i[destroy]

    def destroy
      @attachment.destroy
      respond_to do |format|
        format.html {
          redirect_to edit_admin_document_path(@document), { flash: { validation_message: true, message: "La pièce jointe a bien été supprimée." } }
        }
        format.js
      end
    end

    private

    def find_document
      @document = Document.find(params[:document_id])
    end

    def find_attachment
      @attachment = @document.attachments.find_by(id: params[:id])
    end
  end
end
