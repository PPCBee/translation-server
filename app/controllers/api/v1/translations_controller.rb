module API
  module V1
    class TranslationsController < ApiController

      def index_head
        stale? etag: TranslationCache.find_latest(kind: "#{current_project.id}-#{params[:format]}").try(:etag)
        head :ok
      end

      def index
        cache_key = "#{current_project.id}-#{params[:format]}"
        if translation_cache = TranslationCache.find_latest(kind: cache_key)
          puts "LATEST CACHE #{translation_cache.etag}"
          return unless stale? etag: translation_cache.etag

          response.headers['CustomCache'] = translation_cache.etag

          render status: 200, text: translation_cache.cache
        else
          etag = TranslationCache.index_etag(current_project)
          puts "GENERATING #{etag}"
          @output = Translation.dump_hash current_project.translations.include_dependencies

          TranslationCache.cache(kind: cache_key, etag: etag, cache: dump_cache(@output))

          return unless stale? etag: etag
          puts "GENERATED #{etag}"

          respond_with @output
        end
      end

      def create
        locale = current_project.locales.where(code: params[:locale]).first_or_create
        errors = []
        new_translations = []
        success = 0

        if current_project.screenshots? && params[:location]
          location      = current_project.locations.where(path: params[:location]).first_or_create
          default_image = Image.where(location: location, name: location.path).first_or_create
        end

        found_keys = current_project.keys.where(key: params[:translations].map{ |data| data[:key].split('.', 2).last })
        grouped_keys = found_keys.group_by(&:key)
        grouped_translations = current_project.translations.where(key: found_keys, locale: locale).group_by(&:key_id)

        params[:translations].each do |data|
          key_text = data[:key].split('.', 2).last
          if grouped_keys[key_text] && grouped_keys[key_text].any?
            key = grouped_keys[key_text].first
          else
            key = current_project.keys.build(key: key_text, data_type: data[:data_type])
            key.valid? && key.save
          end

          if key.persisted?
            if grouped_translations[key.id].blank? || grouped_translations[key.id].empty?
              new_translations << { locale: locale.code, key: key.key, text: data[:text] }
              Translation.create translation_params(data).merge(locale: locale, key: key)
            end

            success += 1

            if current_project.screenshots? && default_image
              Highlight.where(
                image:  default_image,
                key:    key,
                locale: locale
              ).first_or_create
            end
          else
            errors << { key: key.key, errors: key.errors.full_messages }
          end
        end

        render json: {
          message: [
            new_translations.size > 0 ? "Created #{new_translations.size} translations" : nil,
            errors.size > 0 ? "Unable to create #{errors.size} translations (check errors)" : nil
          ].select(&:present?).join('and'),
          new_translations: new_translations,
          errors: errors
        }
      end

      private

      def dump_cache(output)
        case params[:format]
        when 'json' then output.to_json
        when 'yaml' then YAML.dump(output).html_safe
        else output.to_json
        end
      end

      def translation_params(data)
        text = data[:text]
        { text: text.is_a?(Array) ? YAML.dump(text).gsub("---\n", '') : text }
      end
    end
  end
end
