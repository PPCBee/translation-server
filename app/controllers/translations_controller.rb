class TranslationsController < BaseProjectController
  before_action :set_translation, only: [:show, :edit, :update, :destroy]
  after_action :cache_translations, only: [:update, :create]

  # GET /translations
  def index
    @translations = current_project.translations.alphabetical.page(params[:page])
    respond_with @translations
  end

  # GET /translations/1
  def show
    respond_with @translation
  end

  # GET /translations/new
  def new
    @translation = current_project.translations.build(new_translation_params)
    @redirect_to = success_location
    respond_with @translation
  end

  # GET /translations/1/edit
  def edit
    respond_with @translation
  end

  # POST /translations
  def create
    @translation = current_project.translations.build(translation_params)
    @translation.save

    respond_with @translation, location: location_after_create
  end

  # PATCH/PUT /translations/1
  def update
    @translation.update(translation_params)
    @project = @translation.project
    if request.xhr?
      head :ok
    else
      respond_with @translation
    end
  end

  # DELETE /translations/1
  def destroy
    @translation.destroy
    respond_with @translation,
                 location: success_location
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_translation
    @translation = Translation.find(params[:id])
  end

  def success_location
    request.referer ? request.referer : [@translation.project, :translations]
  end

  def location_after_create
    params[:redirect_to].present? ? params[:redirect_to] : success_location
  end

  # Only allow a trusted parameter "white list" through.
  def new_translation_params
    params.permit(:key_id, :locale_id)
  end

  def cache_translations
    TranslationCache.cache(
      kind: "#{current_project.id}-yaml",
      etag: TranslationCache.index_etag(current_project),
      cache: YAML.dump(Translation.dump_hash current_project.translations.include_dependencies).html_safe
    )
    puts "CACHING UPDATE: #{TranslationCache.index_etag(current_project)}"
  end

  # Only allow a trusted parameter "white list" through.
  def translation_params
    params
      .require(:translation)
      .permit(:key_id, :locale_id, :text)
      .merge(edited: true)
  end
end
