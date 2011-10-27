class UsersController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :update]
  before_filter :correct_user, :only => [:edit, :update, :show]

  # GET /users
  # GET /users.xml
  def index
    @users = User.paginate(:page => params[:page])
    @title = "All Users"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @loaned_items = @user.items.select{|item| !item.borrower.empty? && item.borrower != @user.email}
    #items_without_borrowers = @user.items.select{|item| item.borrower.nil?}
    #@loaned_items = @user.items.select{|item| !item.borrower.nil?}#.paginate(:page => params[:page])
    @items = @user.items.select{|item| item.borrower.empty?}#.select{|item| item.borrower.nil?}#.paginate(:page => params[:page])
    @borrowed_items = Item.find_all_by_borrower(@user.email, :order => :expiration)

    puts @borrowed_items
    @title = @user.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @title = "Sign Up"
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @title = "Edit User"
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        UserMailer.welcome_email(@user).deliver
        sign_in @user
        flash[:success] = "Welcome to Lethe!";
        format.html { redirect_to(@user) }

        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:success] = "Profile Updated"
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  private

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

end
