require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res, params={})
    @req = req
    @res = res
    @params = params.merge(@req.params)
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "can't render twice" if @already_built_response
    @res.status = 302
    @res.location = url
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)

  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise "can't render twice" if @already_built_response
    @res.set_header("Content-Type", content_type)
    @res.write(content)
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end
  
  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    template_dir = File.dirname(__FILE__) #equal to lib
    
    #path is views/controller_name/template_name.html.erb
    template_file = File.join(template_dir, "..","views", self.class.name.underscore, "#{template_name}.html.erb")
    # "views/#{controller_name}/#{template_name}.html.erb"
    new_template = ERB.new(File.read(template_file))
    result = new_template.result(binding)
    render_content(result,'text/html')
    
  end

  def flash
    @flash ||= Flash.new(req)
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    unless already_built_response?
      render(name)
    end
  end
end


