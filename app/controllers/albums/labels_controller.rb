class Albums::LabelsController < ApplicationController

  def index
    @labels = Albums::Label.all_for_action_index
  end

  def show
    @label = Albums::Label.find(params[:id])
  end
end
