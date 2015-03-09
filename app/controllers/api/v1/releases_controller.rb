module API
  module V1
    class ReleasesController < ApiController
      before_action :set_release, only: [:show, :show_head]

      def index_head
        stale? etag: index_etag
        head :ok
      end

      def show_head
        stale? etag: show_etag
        head :ok
      end

      def index
        return unless stale? etag: index_etag

        @releases = Release.all

        respond_with releases: @releases
      end

      def show
        return unless stale? etag: show_etag

        respond_with @release
      end

      private

      def index_etag
        release = Release.unscope(:order).order(:updated_at).last
        updated_at = release ? release.updated_at : ''
        [updated_at]
      end

      def set_release
        @release = Release.where(version: params[:id]).first

        unless @release
          raise ActiveRecord::RecordNotFound,
                "Release could not be found by version: #{params[:id]}"
        end
      end

      def show_etag
        [@release.updated_at || '']
      end

      def translation_params(data)
        data.slice(:text).permit(:text)
      end
    end
  end
end
