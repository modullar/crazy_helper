# frozen_string_literal: true

require 'spec_helper'
require 'primary_header_navigation_helper'

RSpec.describe PrimaryHeaderNavigationHelper do
  let(:user) { double('user') }
  let(:unread_messages) { double('msgs') }

  describe '#nav_primary' do
    let(:tester) do
      RSpec::Mocks::Double.new(
        current_user: user,
        my_projects_path: 'my_projects_path',
        inbox_path: 'inbox_path',
        profiles_path: 'profiles_path',
        contests_path: 'contests_path',
        company_dashboard_path: 'company_dashboard_path'
      )
    end

    context 'client signed-in users' do
      before do
        tester.extend(PrimaryHeaderNavigationHelper)
        allow(user).to receive(:client?).and_return(true)
        allow(user).to receive(:unread_messages).and_return(unread_messages)
        allow(unread_messages).to receive(:present?).and_return(true)
        allow(unread_messages).to receive(:count).and_return(1)
      end

      it 'returns projects and messages tab' do
        expect(tester.nav_primary).to eq(
          [
            { text: 'My Company', url: tester.company_dashboard_path },
            { text: 'My Projects', url: tester.my_projects_path },
            { block: 'Messages<span class="unread-messages">1<span>', url: tester.inbox_path }
          ]
        )
      end
    end

    context 'non-client signed-in users' do
      before do
        tester.extend(PrimaryHeaderNavigationHelper)
        PrimaryHeaderNavigationHelper::APP_URL = 'APP_URL'
        allow(user).to receive(:client?).and_return(false)
        allow(user).to receive(:unread_messages).and_return(unread_messages)
        allow(unread_messages).to receive(:present?).and_return(true)
        allow(unread_messages).to receive(:count).and_return(1)
      end
      it 'returns company, projects and messages tab' do
        expect(tester.nav_primary).to eq(
          [
            { text: 'Find Projects', url: tester.contests_path },
            { text: 'My Projects', url: tester.my_projects_path },
            { block: 'Messages<span class="unread-messages">1<span>', url: tester.inbox_path }
          ]
        )
      end
    end

    context 'client guests' do
      before do
        allow(tester).to receive(:current_user).and_return(nil)
        tester.extend(PrimaryHeaderNavigationHelper)
      end

      it 'returns about us tab' do
        expect(tester.nav_primary(client: true)).to eq(
          [
            { text: 'How it works', url: tester.profiles_path },
            { text: 'About Us', url: 'APP_URL/about' },
            { text: 'Blog', url: 'APP_URL/blog' }
          ]
        )
      end
    end

    context 'non client guest' do
      before do
        PrimaryHeaderNavigationHelper::APP_URL = 'APP_URL'
        allow(tester).to receive(:current_user).and_return(nil)
        tester.extend(PrimaryHeaderNavigationHelper)
      end

      it 'returns blog tab' do
        expect(tester.nav_primary).to eq(
          [
            { text: 'Browse Projects', url: tester.contests_path },
            { text: 'How it works', url: tester.profiles_path },
            { text: 'Blog', url: 'APP_URL/blog' }
          ]
        )
      end
    end
  end
end
