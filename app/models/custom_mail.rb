class CustomMail < ApplicationRecord
  belongs_to :mailable, polymorphic: true

  delegate :user, to: :mailable

  validates :subject, presence: true
  validates :body, presence: true
  validates :signature, presence: true

  def subject_default_value
    "#{user.full_name} souhaite partager des documents avec vous"
  end

  def body_default_value
    "Bonjour,\n\n#{body_sentence}\n\nPour y accéder, veuillez cliquer sur le lien ci dessous:"
  end

  def signature_default_value
    "Nous vous en souhaitons bonne réception.\n\nBien cordialement,"
  end

  private

  def body_sentence
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
