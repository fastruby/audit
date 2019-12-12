module GemfileHelper
  def render_description(desc)
    @markdown.render(desc)
  end
end
