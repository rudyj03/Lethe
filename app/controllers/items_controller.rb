class ItemsController < ApplicationController

  before_filter :authenticate, :only => [:create, :destroy]

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
  end

  def new
    @title = "Add Item"
    @item = Item.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # POST /items
  # POST /items.xml
  def create

    @item = Item.new(params[:item])
    current_user.items.push @item

    respond_to do |format|
      if @item.save
        format.html { redirect_to(root_path, :notice => 'Item was successfully created.') }
        format.xml  { render :xml => @item, :status => :created, :location => @item }
      else

        format.html { render :action => "new" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def show
    @item = Item.find(params[:id])
    @title = @item.description

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @item }
    end
  end

  # GET /cars/1/edit
  def edit
    @item = Item.find(params[:id])
    @title = "Edit item"
  end

  # PUT /items/1
  # PUT /items/1.xml
  def update
    @item = Item.find(params[:id])

    respond_to do |format|
      if @item.update_attributes(params[:item])
        format.html { redirect_to(@item)}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def return
    @item = Item.find(params[:id])

    UserMailer.returned_notification_email(@item).deliver


    if(@item.update_attribute(:borrower, ""))
      redirect_to(root_path, :notice => "Thank you for returning #{@item.description}")
    else
      redirect_to(root_path, :notice => "Unable to update #{@item.description} right now")
    end

  end

  # DELETE /items/1
  # DELETE /items/1.xml
  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    respond_to do |format|
      format.html { redirect_to(current_user) }
      format.xml  { head :ok }
    end
  end
end
