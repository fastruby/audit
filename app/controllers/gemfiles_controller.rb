class GemfilesController < ApplicationController
  def create
    @file = Gemfile.new(gemfile_params)

    if @file.save
      redirect_to gemfile_path(@file), notice: "Gemfile successfully imported"
    else
      redirect_to root_path, error: "There was a problem"
    end
  end

  def show
    @file = Gemfile.find(params[:id])
    @vulnerabilities = @file.check_with_bundler_audit
  end

  private

  def gemfile_params
    params.require(:gemfile).permit(:file)
  end
end
