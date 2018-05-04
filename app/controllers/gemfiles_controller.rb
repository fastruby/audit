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
    @renderer = Redcarpet::Render::HTML.new(prettify: true)
    @markdown = Redcarpet::Markdown.new(@renderer, fenced_code_blocks: true)
    @file = Gemfile.find(params[:id])
    @vulnerabilities = @file.check_with_bundler_audit
    @vulnerabilities_count = @vulnerabilities[:advisories].size + @vulnerabilities[:warnings].size
  end

  private

  def gemfile_params
    params.require(:gemfile).permit(:file)
  end
end
