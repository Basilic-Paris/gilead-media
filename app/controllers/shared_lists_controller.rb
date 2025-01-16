class SharedListsController < ApplicationController
  include ListHelper
  before_action :find_shared_list, only: %i[show add_contacts]
  before_action :disable_turbo_cache, only: %i[show]

  def index
    @shared_lists = policy_scope(SharedList)
  end

  def show
    @shared_list.build_custom_mail
  end

  def add_contacts
    @shared_list.validate_custom_mail = true
    emails = arrange_list(contacts_params[:contacts][:email])

    emails.each do |email|
      @shared_list.contacts.build(email: email)
    end

    @shared_list.assign_attributes(custom_mail_params)
    if @shared_list.save
      @shared_list.add_contacts!
      @shared_list.notify_contacts
      @message = "Votre liste de partage a bien été envoyée."
      respond_to do |format|
        format.html { redirect_to shared_list_path(@shared_list), flash: { validation_message: true, message: @message } }
        format.turbo_stream { render turbo_stream: [
          turbo_stream.replace("edit_shared_list_#{@shared_list.id}", partial: "shared_lists/add_contacts_form", locals: { shared_list: @shared_list }),
          turbo_stream.replace("validationModal", partial: "shared/validation_modal", locals: { message: @message }),
          turbo_stream.action(:open_modal, ".modal#validationModal"),
          turbo_stream.replace_element_attribute({ element: "#shared-list-nav-item a", attribute: "href", newAttributeValue: shared_lists_path })
        ]}
      end
    else
      render :show
    end
  end

  private

  def find_shared_list
    @shared_list = SharedList.find(params[:id])
    authorize @shared_list
  end

  def find_folder
    @folder = Folder.find(params[:folder_id])
  end

  def contacts_params
    params.require(:shared_list).permit(contacts: [:email])
  end

  def shared_list_params
    params.require(:shared_list).permit(:title, :validity, :download)
  end

  def custom_mail_params
    params.require(:shared_list).permit(custom_mail_attributes: [:subject, :body, :signature])
  end
end
