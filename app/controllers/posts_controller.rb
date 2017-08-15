class PostsController < ApplicationController
    def index
        @posts = Post.page params[:page]
        # @posts = Post.page(6)
        # @posts = Post.offset(25).limit(5)
    end
end
