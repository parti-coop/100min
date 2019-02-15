class TinymceAssetsController < ApplicationController
  def create
    image = Image.create params.permit(:file, :alt, :hint)

    render json: {
      image: {
        url: image.file.url
      }
    }, content_type: "text/html"
  end
end
