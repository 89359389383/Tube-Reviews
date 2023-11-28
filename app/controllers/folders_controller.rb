class FoldersController < ApplicationController
  before_action :set_folder, only: [:edit, :update, :destroy]

  # GET /folders/new
  def new
    @folder = Folder.new
  end

  # POST /folders
  def create
    @folder = Folder.new(folder_params)
    if @folder.save
      redirect_to folders_path, notice: 'Folder was successfully created.'
    else
      render :new
    end
  end

  # GET /folders/:id/edit
  def edit
  end

  # PATCH/PUT /folders/:id
  def update
    if @folder.update(folder_params)
      redirect_to folders_path, notice: 'Folder was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /folders/:id
  def destroy
    @folder.destroy
    redirect_to folders_path, notice: 'Folder was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_folder
      @folder = Folder.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def folder_params
      params.require(:folder).permit(:name)
    end
end
