class SharedListsController < ApplicationController
  include ListHelper
  before_action :find_shared_list, only: %i[show add_contacts]

  def index
    @shared_lists = policy_scope(SharedList)
  end

  def show
  end

  def add_contacts
    emails = arrange_list(contacts_params[:contacts][:email])

    emails.each do |email|
      @shared_list.contacts.build(email: email)
    end

    if @shared_list.save
      @shared_list.add_contacts!
      @shared_list.notify_contacts
      redirect_to shared_list_path(@shared_list), flash: { validation_message: true, message: "Votre liste de partage a bien été envoyée." }
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
end
