# A Contractor Request
class ContractorRequest < Request
  VALID_EMPLOYEE_TYPES = ['Contingent 2', 'Contract Faculty'].freeze
  VALID_REQUEST_TYPES = %w[Renewal New ConvertC1].freeze

  class << self
    def human_name
      'Contractor Requests'
    end

    # all the fields associated to the model
    def fields
      %i[ position_title employee_type request_type
          contractor_name number_of_months annual_base_pay
          nonop_funds nonop_source justification organization__name unit__name
          review_status__name review_comment user__name created_at updated_at ]
    end

    # Returns an ordered array used in the index pages
    def index_fields
      fields - %i[nonop_source justification review_comment created_at updated_at]
    end
  end

  monetize :annual_base_pay_cents
  validates :annual_base_pay, presence: true
  validates :number_of_months, presence: true
  validates :contractor_name, presence: true, if: :contractor_name_required?

  def contractor_name_required?
    %w[Renewal ConvertC1].include? request_type
  end

  default_scope(lambda do
    joins("LEFT JOIN organizations as units ON units.id = #{current_table_name}.unit_id")
      .includes(%i[review_status organization user])
      .where(request_model_type: StaffRequest.request_model_types['contractor'])
  end)
end
