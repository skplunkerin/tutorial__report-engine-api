class Api::V1::EnginesController < ApplicationController
  before_filter   :super_admin_check,  except: [:show]
  before_filter   :owned_engine_check, only: [:show]

  def index
    render json: Engine.all.as_json, status: 200
  end

  def show
    if Engine.exists?({apikey: params[:id]})
      render json: Engine.find_by_apikey(params[:id]).as_json, status: 200
    else
      render json: { error: "Engine Endpoint: Unknown engine." }, status: 200
    end
  end

  def create
    engine = Engine.new(engine_params)
    if engine.status.nil?
      engine.status = "reviewing"
    end
    if engine.save
      render json: engine.as_json, status: 200
    else
      render json: { error: engine.errors.full_messages.to_sentence }, status: 500
    end
  end

  def update
    engine = Engine.find_by_apikey(params[:id])
    if engine.update_attributes(engine_params)
      render json: engine.as_json, status: 200
    else
      render json: { error: engine.errors.full_messages.to_sentence }, status: 500
    end
  end

  def destroy
    engine = Engine.find_by_apikey(params[:id])
    if engine && engine.status != "deleted"
      if engine.update_attributes({status: "deleted"})
        render json: { success: "Engine Endpoint: Engine deleted." }, status: 200
      else
        render json: { error: engine.errors.full_messages.to_sentence }, status: 500
      end
    else
      render json: { error: "Engine Endpoint: Unknown engine." }, status: 200
    end
  end

  private
  def engine_params
    params.permit(:name, :status)
  end

  def super_admin_check
    if !@is_super_admin
      render json: { error: "Engine Endpoint: Access denied." }, status: 401
    end
  end

  def owned_engine_check
    if (@is_admin && params[:id] != @current_engine_token) || @is_reporter || @is_client
      render json: { error: "Engine Endpoint: Access denied." }, status: 401
    end
  end
end
