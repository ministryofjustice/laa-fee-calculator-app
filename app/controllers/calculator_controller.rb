class CalculatorController < ApplicationController
  attr_reader :fee_scheme

  # before_action :setup, only: [:new, :calculate, :fee_scheme_changed, :select_list_changed]

  FEE_CALCULATOR_FIELDS = %i[fee_scheme scenario offence_class advocate_type fee_type_code case day defendant fixed halfday hour month ppe pw third number_of_cases number_of_defendants trial_length pages_of_prosection_evidence retrial_interval third_cracked]

  def new
    setup
  end

  def calculate
    set_fee_scheme
    set_select_lists
    set_text_fields
    @amount = fee_scheme.calculate do |options|
      FEE_CALCULATOR_FIELDS.each do |field|
        options[field] = calculator_params[field] if calculator_params[field].present?
      end
    end

    respond_to do |format|
      format.js
      format.html { render action: :new }
    end
  end

  def fee_scheme_changed
    set_fee_scheme
    set_select_lists
    set_text_fields
    respond_to do |format|
      format.js
      format.html { render action: :new }
    end
  end

  def select_list_changed
    set_fee_scheme
    set_select_lists
    set_text_fields
    respond_to do |format|
      format.js
    end
  end

  private

  def client
    @client ||= LAA::FeeCalculator.client
  end

  def set_fee_scheme
    @fee_scheme = client.fee_schemes(id: calculator_params[:fee_scheme] || 1)
  end

  def common_options
    options = {}
    options[:scenario] = calculator_params[:scenario] if calculator_params[:scenario].present?
    options[:offence_class] = calculator_params[:offence_class] if calculator_params[:offence_class].present?
    options[:advocate_type] = calculator_params[:advocate_type] if calculator_params[:advocate_type].present?
    options[:fee_type_code] = calculator_params[:fee_type_code] if calculator_params[:fee_type_code].present?
    options
  end

  def set_text_fields
    @units = fee_scheme.units(common_options).map { |u| u.id.downcase }
    @modifiers = fee_scheme.modifier_types(common_options).map { |m| m.name.downcase }
  end

  def set_select_lists
    @fee_schemes = client.fee_schemes.map { |fs| [fs.description, fs.id] }
    @scenarios = fee_scheme.scenarios.map { |s| [s.name, s.id] }
    @advocate_types = fee_scheme.advocate_types.map { |at| [at.name, at.id] }
    @offence_classes = fee_scheme.offence_classes.map { |oc| ["#{oc.name} - #{oc.description}", oc.id] }
    @fee_types = fee_scheme.fee_types.map { |ft| [ft.name, ft.code] }
  end

  def setup
    set_fee_scheme
    set_select_lists
    set_text_fields
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
