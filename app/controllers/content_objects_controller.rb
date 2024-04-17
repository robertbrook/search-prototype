class ContentObjectsController < ApplicationController

  def index
    # used as landing page during development
    @page_title = 'Examples'
  end

  def show
    @response = SolrQuery.new(object_uri: params[:object]).all_data['response']

    if @response.has_key?('code')
      # error state
      case @response['code']
      when 404
        render template: 'layouts/shared/error/404', locals: { status: @response['code'], message: @response['msg'] }
      when 500
        render template: 'layouts/shared/error/500', locals: { status: @response['code'], message: @response['msg'] }
      when 401
        render template: 'layouts/shared/error/401', locals: { status: @response['code'], message: @response['msg'] }
      else
        raise 'unknown error occurred'
      end
    elsif @response['docs'].blank?
      # API responds with success but no results - show a 404
      render template: 'layouts/shared/error/404', locals: { status: 404, message: 'Page not found' }
    else
      object_data = @response['docs'].first
      @object = ContentObject.generate(object_data)
      @ses_data = @object.ses_data
      @page_title = @object.object_title

      if @ses_data.has_key?(:error)
        render template: 'layouts/shared/error/500', locals: { status: 500, message: 'There was an error resolving names using the SES service' }
      else
      render template: @object.template, :locals => { :object => @object }
      end
    end

  end
end