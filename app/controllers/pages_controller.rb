class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if current_user.admin?
      @documents = policy_scope(Document).includes(attachment_attachment: :blob)
    else
      @documents = policy_scope(Document).validated.includes(attachment_attachment: :blob)
    end
  end
end
