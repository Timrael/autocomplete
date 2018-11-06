class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  def index
    @companies = Company.order(:id).page(params[:page])
  end

  # GET /companies/1
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
    redirect_to companies_url, notice: 'Company was successfully destroyed.'
  end

  private

  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(
      :name, :number, :previous_name_1_company_name,
      :previous_name_2_company_name, :previous_name_3_company_name,
      :previous_name_4_company_name, :previous_name_5_company_name,
      :previous_name_6_company_name, :previous_name_7_company_name,
      :previous_name_8_company_name, :previous_name_9_company_name,
      :previous_name_10_company_name
    )
  end
end
