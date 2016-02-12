class MeasuresController < ApplicationController
  before_action :set_measure, only: [:show, :update, :destroy]
  before_action :set_attribute, only: [:index, :create]
  layout nil

  # GET /measures
  # GET /measures.json
  def index
    period = params[:period]
    if period.present?
      if period == "day"
        @measures = @attribute.measures.where("created_at >= ?", Date.today.beginning_of_day)
      elsif period == "week"
        #@measures = @attribute.measures.where(created_at: Date.today.all_week)
        @measures = @attribute.measures.find_by_sql("SELECT created_at as created_at, ROUND(AVG(value),2) as value FROM measures WHERE (created_at BETWEEN '#{1.week.ago}' AND '#{Time.now}') GROUP BY date(created_at), hour(created_at)")
      elsif period == "month"
        #@measures = @attribute.measures.where(created_at: Date.today.all_month)
        @measures = @attribute.measures.find_by_sql("SELECT created_at as created_at, ROUND(AVG(value),2) as value FROM measures WHERE (created_at BETWEEN '#{1.month.ago}' AND '#{Time.now}') GROUP BY date(created_at)")
      elsif period == "year"
        #@measures = @attribute.measures.where(:created_at => Date.today.all_year).order(:created_at).group("date(created_at)").average(:value)
        @measures = @attribute.measures.find_by_sql("SELECT created_at as created_at, ROUND(AVG(value),2) as value FROM measures WHERE (created_at BETWEEN '#{1.year.ago}' AND '#{Time.now}') GROUP BY date(created_at)")
      else
        @measures = @attribute.measures.all
      end
    else
      @measures = @attribute.measures.all
    end

    render json: @measures.to_json(only:[:value,:created_at])
  end

  # GET /measures/1
  # GET /measures/1.json
  def show
    render json: @measure
  end

  # POST /measures
  # POST /measures.json
  def create
    @measure = @attribute.measures.new(measure_params)
    if @measure.save
      render json: @measure, status: :created, location: entity_attribute_measure_url(@entity, @attribute, @measure)
    else
      render json: @measure.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /measures/1
  # PATCH/PUT /measures/1.json
  def update
    if @measure.update(measure_params)
      head :no_content
    else
      render json: @measure.errors, status: :unprocessable_entity
    end
  end

  # DELETE /measures/1
  # DELETE /measures/1.json
  def destroy
    @measure.destroy

    head :no_content
  end

  private

  def set_measure
    @measure = Measure.find(params[:id])
  end

  def set_attribute
    @entity = Entity.find_by(name: params[:entity_id])
    @attribute = @entity.entity_attributes.find_by(name: params[:attribute_id])
  end

  def measure_params
    params.require(:measure).permit(:value)
  end
end
