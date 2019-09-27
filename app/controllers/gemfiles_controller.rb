class GemfilesController < ApplicationController
  def create
    @file = Gemfile.new(gemfile_params)

    respond_to do |format|
      if @file.save
        render_vulnerabilities(@file)
        format.js
      else
        format.js
      end
    end
  end

  def show
    @file = Gemfile.find_by!(alpha_id: params[:id])
    render_vulnerabilities(@file)

    respond_to do |format|
      format.pdf do
        render pdf: "vulnerabilities_list",
          template: "gemfiles/show.html.erb",
          layout: 'pdf.html'
      end
    end
  end

  private

  def gemfile_params
    params.permit(gemfile: [:file])[:gemfile]
  end

  def render_vulnerabilities(file)
    @renderer = Redcarpet::Render::HTML.new(prettify: true)
    @markdown = Redcarpet::Markdown.new(@renderer, fenced_code_blocks: true)
    @vulnerabilities = file.check_with_bundler_audit
    @vulnerabilities_count = vulnerabilities_count(@vulnerabilities)
  end

  def vulnerabilities_count(vulnerabilities)
    vulnerabilities[:advisories].size + vulnerabilities[:warnings].size
  end
end
