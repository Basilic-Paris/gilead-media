class SharedListsController < ApplicationController
  before_action :find_shared_list, only: %i[show add_contacts]

  def index
    @shared_lists = policy_scope(SharedList)
  end

  def show
  end

  def add_contacts
    @shared_list.contacts.destroy_all if @shared_list.contacts.present?
    emails = contacts_params[:contacts][:email].split(/\s{1,}*[,;\/]\s{1,}*|\s{1,}/).uniq
    # \s{1,}*[,;\/]\s{1,}* (, ; ou / précédé et optionnellement précédé par un ou plusieurs espaces OU un ou plusieurs espaces
    @errors = Array.new
    emails.each do |email|
      contact = @shared_list.contacts.new(email: email)
      if contact.save
      else
        @errors << "#{contact.email}: #{contact.errors.full_messages.join(', ')}"
      end
    end
    if @errors.empty?
      redirect_to shared_lists_path
    else
      flash.now.alert = @errors.join("<br>").html_safe
      render :show
    end
  end

  private

  def find_shared_list
    @shared_list = SharedList.find(params[:id]).decorate
    authorize @shared_list
  end

  def contacts_params
    params.require(:shared_list).permit(contacts: [:email])
  end
end
