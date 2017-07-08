class BooklistsController < ApplicationController
  before_action :set_booklist, only: [:show, :edit, :update, :destroy]

  def new
  end

  # GET /booklists/1/edit
  def edit
  end


  def create
    @booklist = Booklist.new(booklist_params)

    if @booklist.save
      redirect_to root_path, notice: I18n.t('controllers.booklists.created')
    else
      render :new
    end
  end

  # PATCH/PUT /booklists/1
  # PATCH/PUT /booklists/1.json
  def update
    respond_to do |format|
      if @booklist.update(booklist_params)
        format.html { redirect_to @booklist, notice: 'Booklist was successfully updated.' }
        format.json { render :show, status: :ok, location: @booklist }
      else
        format.html { render :edit }
        format.json { render json: @booklist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booklists/1
  # DELETE /booklists/1.json
  def destroy
    @booklist.destroy
    respond_to do |format|
      format.html { redirect_to booklists_url, notice: 'Booklist was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booklist
      @booklist = Booklist.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def booklist_params
      params.require(:booklist).permit(:book_id, :list_id)
    end
end
