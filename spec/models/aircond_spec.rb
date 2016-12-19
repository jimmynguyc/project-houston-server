require 'rails_helper'

RSpec.describe Aircond, type: :model do
	FactoryGirl.find_definitions
  describe '#get_state' do
  end

  describe '#send_signal' do
  end

  describe '#validate_AC_controls' do
  	context 'invalid status' do
  		it 'should return nil' do

  		end
  	end
  end
end
