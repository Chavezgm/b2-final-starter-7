require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  it { should belong_to :merchant }

  
  describe 'validations' do
    it { should validate_presence_of :percentage_discount}
    it { should validate_presence_of :quantity_threshold}
  end
  
end
