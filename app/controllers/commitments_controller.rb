class CommitmentsController < ApplicationController
  before_action :set_commitment, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /commitments
  # GET /commitments.json
  def index
    respond_to do |format|
      format.json { render json: Commitment.all }
      format.html do
        @date = params[:date] ? Date.parse(params[:date]) :
          Time.now.hour < 12 ? Date.today : Date.tomorrow
        @commitments =
          Commitment.where(date: @date).includes(:user).sort do |a, b|
            x = [[Commitments::DISPLAY_ORDER.index(a.class) -
                  Commitments::DISPLAY_ORDER.index(b.class),
                  1].min,
                 -1].max
            x.zero? ? (a.user.last_name > b.user.last_name ? 1 : -1) : x
        end
        @events = Commitment.group([:date, :type]).count.map do |key, count|
          commitment_class = key[1].constantize
          { color: commitment_class.display_color,
            start: key[0].strftime('%Y-%m-%d'),
            title: "#{commitment_class.display_text}: #{count}" }
        end
      end
    end
  end

  # GET /commitments/1
  # GET /commitments/1.json
  def show
  end

  # GET /commitments/new
  def new
    @commitment = Commitment.new
  end

  # GET /commitments/1/edit
  def edit
  end

  # POST /commitments
  # POST /commitments.json
  def create
    @commitment = Commitment.new(commitment_params)

    respond_to do |format|
      if @commitment.save
        format.html { redirect_to @commitment, notice: 'Commitment was successfully created.' }
        format.json { render :show, status: :created, location: @commitment }
      else
        format.html { render :new }
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commitments/1
  # PATCH/PUT /commitments/1.json
  def update
    respond_to do |format|
      if @commitment.update(commitment_params)
        format.html { redirect_to @commitment, notice: 'Commitment was successfully updated.' }
        format.json { render :show, status: :ok, location: @commitment }
      else
        format.html { render :edit }
        format.json { render json: @commitment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commitments/1
  # DELETE /commitments/1.json
  def destroy
    @commitment.destroy
    respond_to do |format|
      format.html { redirect_to commitments_url, notice: 'Commitment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commitment
      @commitment = Commitment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commitment_params
      params.require(:commitment).permit(:user_id, :date, :type)
    end
end
