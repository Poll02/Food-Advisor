class CompetizioneController < ApplicationController
  def index
    @competizioni = Competizione.all
  end
end
