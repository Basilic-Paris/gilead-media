class CustomMail < ApplicationRecord
  belongs_to :mailable, polymorphic: true

  delegate :user, to: :mailable

  validates :subject, presence: true
  validates :body, presence: true
  validates :signature, presence: true

  def subject_default_value
    general_sentence
  end

  def body_default_value
    "Bonjour,\n\n#{general_sentence}.\n\nPour y accéder, veuillez cliquer sur le lien ci dessous:"
  end

  def signature_default_value
    "Nous vous en souhaitons bonne réception.\n\nBien cordialement,"
  end

  private

  def general_sentence
    case mailable_type
    when "SharedFolder"
      "#{user.full_name} souhaite partager un dossier avec vous"
    when "SharedDocument"
      "#{user.full_name} souhaite partager un document avec vous"
    when "SharedList"
      "#{user.full_name} souhaite partager des documents avec vous"
    end
  end
end
