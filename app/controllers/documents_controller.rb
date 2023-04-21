class DocumentsController < ApplicationController
  include ListHelper

  before_action :find_document, only: %i[show add_to_shared_list_or_folder attach_to_new_shared_list attach_to_existing_shared_list]
  before_action :disable_turbolinks_cache, only: %i[index]

  def show
    @shared_document = SharedDocument.new
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new
  end

  def index
    @documents = policy_scope(Document).includes(:folders, attachment_attachment: :blob, document_folders: :folder)
    @shared_document = SharedDocument.new
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new

    if search_params.present?
      search_params.reject { |key, value| value.blank? || key == "title" }.each do |key, value|
        if key == "created_at"
          @documents = @documents.created_in_days_range(value.split(" au ").first.to_date, value.split(" au ").last.to_date)
        else
          @documents = @documents.advanced_search(key, value)
        end
      end
      if search_params[:title].present?
        @documents = (@documents.advanced_search(:title, search_params[:title]) + @documents.tagged_with(arrange_list(search_params[:title]), any: true)).uniq
      else
        @documents
      end
    else
      @documents
    end
  end

  def add_to_shared_list_or_folder
    @shared_list = SharedList.new
    @document_shared_list = DocumentSharedList.new
  end

  def attach_to_new_shared_list
    @shared_list = current_user.shared_lists.new(shared_list_params)
    @shared_list.code = SecureRandom.alphanumeric(16)
    @document_shared_list = @shared_list.document_shared_lists.new(document: @document)
    if @shared_list.save
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: "Votre liste de partage a bien été créée et votre document a bien été ajouté à celle-ci." } }
        format.js { @message = "Votre liste de partage a bien été créée et votre document a bien été ajouté à celle-ci." }
      end
    else
      render :add_to_shared_list_or_folder
    end
  end

  def attach_to_existing_shared_list
    @shared_list = current_user.shared_lists.initial.first
    @document_shared_list = @document.document_shared_lists.new(document_shared_list_params)
    if @document_shared_list.save
      respond_to do |format|
        format.html { redirect_to document_path(@document), flash: { validation_message: true, message: "Votre document a bien été ajouté à la liste de partage." } }
        format.js { @message = "Votre document a bien été ajouté à la liste de partage." }
      end
    else
      render :add_to_shared_list_or_folder
    end
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def add_to_shared_list
  #   if @document.update(shared_list_params)
  #     redirect_to document_path(@document)
  #   else
  #     render :show
  #   end
  # end

  # def attach_pdf_thumbnail
  #   # gemfile
  #     # Add gem 'libreconv'
  #   # document.rb
  #     # Add has_one_attached :pdf_thumbnail
  #   @document = Document.second

  #   bucket_name = @document.attachment.service.bucket.name
  #   object_key = @document.attachment.blob.key
  #   local_path = "./#{object_key}"
  #   s3 = Aws::S3::Client.new(
  #     region: Rails.application.credentials.aws[:region],
  #     access_key_id: Rails.application.credentials.aws[:access_key_id],
  #     secret_access_key: Rails.application.credentials.aws[:secret_access_key],
  #   )

  #   target = "#{Rails.root}/app/views/#{@document.attachment.blob.filename}"
  #   resp = s3.get_object({ bucket:bucket_name, key:object_key }, target: target)

  #   Libreconv.convert(target, "#{Rails.root}/app/views/1.pdf")
  #   File.delete(target) if File.exist?(target)

  #   @document.pdf_thumbnail.attach(io: File.open("#{Rails.root}/app/views/1.pdf"), filename: "#{@document.attachment.blob.filename}.pdf", content_type: 'application/pdf')
  #   File.delete("#{Rails.root}/app/views/1.pdf") if File.exist?("#{Rails.root}/app/views/1.pdf")
  # end

  private

  def find_document
    @document = Document.find(params[:id]).decorate
    authorize @document
  end

  def search_params
    params.fetch(:search, {}).permit(:title, :format, :language, :created_at)
  end

  def document_shared_list_params
    params.require(:document_shared_list).permit(:shared_list_id)
  end

  def shared_list_params
    params.require(:shared_list).permit(:title, :validity, :download)
  end

  # TO KEEP: initial version to add folders or documents to shared list directly
  # def shared_list_params
  #   params[:document][:shared_lists_attributes].keys.each do |key|
  #     params[:document][:shared_lists_attributes][key]["user_id"] = current_user.id.to_s
  #   end
  #   params.require(:document).permit(shared_list_ids: [], shared_lists_attributes: [:title, :user_id])
  # end
end
