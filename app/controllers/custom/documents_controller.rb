class Custom::DocumentsController < ApplicationController
  def index
    @documents = policy_scope([:custom, Document]).includes(attachment_attachment: :blob)
  end
end
