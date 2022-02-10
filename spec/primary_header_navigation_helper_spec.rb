require 'spec_helper'
require 'primary_header_navigation_helper'

RSpec.describe PrimaryHeaderNavigationHelper do

  let(:user) { double('user') }
  let(:unread_messages) { double('msgs') }
  describe '#nav_primary' do

    context 'current user is client' do
      let(:tester) do
        RSpec::Mocks::Double.new(
          current_user: user,
          my_projects_path: 'pmy_projects_pathath',
          inbox_path: 'inbox_path',
          company_dashboard_path: 'company_dashboard_path'
        )
      end
  
      before do
        tester.extend(PrimaryHeaderNavigationHelper)
        allow(user).to receive(:client?).and_return(true)
        allow(user).to receive(:unread_messages).and_return(unread_messages)
        allow(unread_messages).to receive(:present?).and_return(true)
        allow(unread_messages).to receive(:count).and_return(1)
      end

      it 'returns links to company dashboard' do
        expect(tester.nav_primary).to eq 1
      end
    end

    context 'current user is not a client' do  
    end

  end
end