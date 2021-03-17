class CustomMail < ApplicationRecord
  belongs_to :mailable, polymorphic: true

  delegate :user, to: :mailable

  validates :body, presence: true

  def body_default_value
    "Bonjour,\n\n#{sentence}\n\nPour y accéder, veuillez cliquer sur le lien ci dessous:"
  end

  private

  def sentence
    case mailable_type
    when "SharedFolder"
      "#{user.full_name} souhaite partager un dossier avec vous."
    when "SharedDocument"
      "#{user.full_name} souhaite partager un document avec vous."
    when "SharedList"
      "#{user.full_name} souhaite partager des documents avec vous."
    end
  end
end

# <p>Bonjour,</p>

# <% if @contact.contactable_type == "SharedList" %>
#   <p><%= @user.full_name %> souhaite partager des documents avec vous.</p>
# <% elsif @contact.contactable_type == "SharedDocument" %>
#   <p><%= @user.full_name %> souhaite partager un document avec vous.</p>
# <% elsif @contact.contactable_type == "SharedFolder" %>
#   <p><%= @user.full_name %> souhaite partager un dossier avec vous.</p>
# <% end %>
