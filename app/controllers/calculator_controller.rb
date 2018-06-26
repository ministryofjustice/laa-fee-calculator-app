class CalculatorController < ApplicationController
  attr_reader :fee_scheme

  before_action :set_list_data, only: [:new, :fee_scheme_changed]
  before_action :set_fee_scheme, only: :calculate

  def new
  end

  def calculate
    @amount = fee_scheme.calculate do |options|
      options[:scenario] = calculator_params[:scenario] if calculator_params[:scenario].present?
      options[:offence_class] = calculator_params[:offence_class] if calculator_params[:offence_class].present?
      options[:advocate_type] = calculator_params[:advocate_type] if calculator_params[:advocate_type].present?
      options[:fee_type_code] = calculator_params[:fee_type_code] if calculator_params[:fee_type_code].present?
      options[:day] = calculator_params[:day] if calculator_params[:day].present?
      options[:number_of_defendants] = calculator_params[:number_of_defendants] if calculator_params[:number_of_defendants].present?
      options[:number_of_cases] = calculator_params[:number_of_cases] if calculator_params[:number_of_cases].present?
    end

    respond_to do |format|
      format.html { set_list_data; render action: :new }
      format.js
    end
  end

  def fee_scheme_changed
    # respond_to do |format|
    #   format.html { set_list_data; render actions: :new }
    #   format.js
    # end
    render :new
  end

  private

  def set_fee_scheme
    @fee_scheme = client.fee_schemes(id: calculator_params[:fee_scheme] || 1)
  end

  def set_list_data
    set_fee_scheme
    @fee_schemes = client.fee_schemes.map { |fs| [fs.description, fs.id] }
    @scenarios = fee_scheme.scenarios.map { |s| [s.name, s.id] }
    @advocate_types = fee_scheme.advocate_types.map { |at| [at.name, at.id] }
    @offence_classes = fee_scheme.offence_classes.map { |oc| ["#{oc.name} - #{oc.description}", oc.id] }
    @fee_types = fee_scheme.fee_types.map { |ft| [ft.name, ft.code] }
  end

  def client
    @client ||= LAA::FeeCalculator.client
  end

  def agfs_scheme_9
    return @agfs_scheme_9 if @agfs_scheme_9
    @agfs_scheme_9 = client.fee_schemes(1)
  end

  def calculator_params
    params.permit(
      :fee_scheme,
      :scenario,
      :offence_class,
      :advocate_type,
      :fee_type_code,
      :day,
      :case,
      :defendant,
      :fixed,
      :halfday,
      :hour,
      :month,
      :ppe,
      :pw,
      :third,
      :number_of_cases,
      :number_of_defendants,
      :pages_of_prosection_evidence,
      :trial_length,
      :retrial_interval,
      :third_cracked
    )
  end
end
