class StaticPagesController < ApplicationController
  # skip_before_action :authenticate_user!, :only => [:index]
  skip_before_action :authenticate_user!

  def index
  end

  def about
  end

  def pricing
  end

  def privacy
  end

  def terms
  end
end
