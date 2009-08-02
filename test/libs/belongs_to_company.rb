module BelongsToCompany
  # belongs_to :company
  
  def company= (a_company)
    self["company_id"] = a_company[:id]
  end
  
  def company
    Company.get(self['company_id']) if self['company_id']
  end

end
  