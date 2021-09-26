class TopController < ApplicationController
  def index
    # @post = "aaaaaaaaaaaaaaaaaaaaaa"
    @post = Post.find("2")
  end
end
