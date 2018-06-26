class CalculatorController < ApplicationController
  def new
    set_list_data
  end

  def calculate
    fee_scheme = agfs_scheme_9
    @amount = fee_scheme.calculate do |options|
      # options[:scenario] = 5
      # options[:offence_class] = 'E'
      # options[:advocate_type] = 'JRALONE'
      # options[:fee_type_code] = 'AGFS_APPEAL_CON'
      # options[:day] = 1
      # options[:number_of_defendants] = 1
      # options[:number_of_cases] = 1

      options[:scenario] = calculator_params[:scenario] if calculator_params[:scenario].present?
      options[:offence_class] = calculator_params[:offence_class] if calculator_params[:offence_class].present?
      options[:advocate_type] = calculator_params[:advocate_type] if calculator_params[:advocate_type].present?
      options[:fee_type_code] = calculator_params[:fee_type_code] if calculator_params[:fee_type_code].present?
      options[:day] = calculator_params[:day] if calculator_params[:day].present?
      options[:number_of_defendants] = calculator_params[:number_of_defendants] if calculator_params[:number_of_defendants].present?
      options[:number_of_cases] = calculator_params[:number_of_cases] if calculator_params[:number_of_cases].present?
    end

    respond_to do |format|
      format.html { set_list_data; render actions: :new }
      format.js
    end
  end

  private

  def set_list_data
    fee_scheme = agfs_scheme_9
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
