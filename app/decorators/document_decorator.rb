class DocumentDecorator < Draper::Decorator
  delegate_all

  def display_language
    Document::LANGUAGES[object.language.to_sym]
  end

end
