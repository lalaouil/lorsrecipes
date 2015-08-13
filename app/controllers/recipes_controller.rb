class RecipesController < ApplicationController
  before_action :set_recipe, only: [:edit, :update, :show, :like]
  before_action :require_user, except: [:show, :index, :like]
  before_action :require_user_like, only: [:like]
  before_action :require_same_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    @recipes = Recipe.paginate(page: params[:page], per_page: 4)
  end 
  
  def show
    
  end
  
  def new
    @recipe = Recipe.new
  end
  
  def create
    @recipe = Recipe.new(recipe_params)
    @recipe.chef = current_user
    
    if @recipe.save
      redirect_to recipes_path
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @recipe.update(recipe_params)
      redirect_to recipe_path(@recipe)
    else 
      render :edit
    end
  end
  
  def like
    like = Like.create(like: params[:like], chef: current_user, recipe: @recipe)
    if like.valid?
      redirect_to :back
    else
      flash[:danger] ="Tsk tsk. No fair voting more than once!"
      redirect_to :back
    end
  end
    private
  
      def recipe_params
        params.require(:recipe).permit(:name, :summary, :description, :picture, diet_ids: [], course_ids: [])
      end
      
      def set_recipe
        @recipe = Recipe.find(params[:id])
      end
      
      def require_same_user
        if current_user != @recipe.chef
          flash[:danger] = "I'm sorry. You may only edit your own recipes."
          redirect_to recipe_path
        end
      end
      
      def require_user_like
        if !logged_in?
          flash[:danger] = "Uh oh. You must be logged in to perform that action." 
          redirect_to :back
        end
      end
end