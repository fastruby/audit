class GemfilesController < ApplicationController
  def create
    @file = Gemfile.new(gemfile_params)

    debugger
    if @file.save
      redirect_to file_path(@file), notice: "Gemfile successfully imported"
    else
      redirect_to "/", error: "There was a problem"
    end
  end

  private

  def gemfile_params
    params.require(:gemfile).permit(:file)
  end
end
