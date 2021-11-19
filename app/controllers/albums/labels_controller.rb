class Albums::LabelsController < ApplicationController

  def index
    @labels = Albums::Label.all
  end
end
