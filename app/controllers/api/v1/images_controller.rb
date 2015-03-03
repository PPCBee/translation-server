require 'uri'

module API
  module V1
    class ImagesController < ApiController

      def create
        location_path = URI.parse(params[:location]).path
        location = Location.where(path: location_path).first_or_create
        params[:images].each do |data|
          key = Key.where(key: data[:key].split('.', 2).last).first_or_create

          if image = Image.where(location: location, key: key).first
            image.update image_params(data)
          else
            Image.create image_params(data).merge(location: location, key: key)
          end
        end

        render json: {
          message: "Imported #{params[:images].size} images"
        }
      end

      private

      def image_params(data)
        data.slice(:image, :x, :y, :width, :height)
            .permit(:image, :x, :y, :width, :height)
      end
    end
  end
end